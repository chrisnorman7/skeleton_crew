import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ziggurat/ziggurat.dart';
import 'package:ziggurat_sounds/ziggurat_sounds.dart';

import 'constants.dart';
import 'json/asset_stores/asset_store_reference.dart';
import 'json/asset_stores/pretend_asset_reference.dart';
import 'json/command_trigger_reference.dart';
import 'screens/asset_stores/create_asset_store.dart';
import 'screens/command_triggers/edit_command_trigger.dart';
import 'screens/lists/select_item.dart';
import 'src/project_context.dart';
import 'widgets/sounds/play_sound_semantics.dart';

/// Round the given [value] to the given number of decimal [places].
///
/// This code copied and modified from[here](https://www.bezkoder.com/dart-round-double/#:~:text=Dart%20round%20double%20to%20N%20decimal%20places,-We%20have%202&text=%E2%80%93%20Multiply%20the%20number%20by%2010,12.3412%20*%2010%5E2%20%3D%201234.12).
double roundDouble(final double value, {final int places = 2}) {
  final mod = pow(10.0, places);
  return (value * mod).round().toDouble() / mod;
}

/// Push the result of the given [builder] onto the stack.
Future<void> pushWidget({
  required final BuildContext context,
  required final WidgetBuilder builder,
}) =>
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: builder,
      ),
    );

/// Generate a new ID.
String newId() => shortUuid.generate();

/// Confirm something.
Future<void> confirm({
  required final BuildContext context,
  final String title = 'Confirm',
  final String message = 'Are you sure?',
  final VoidCallback? yesCallback,
  final VoidCallback? noCallback,
  final String yesLabel = 'Yes',
  final String noLabel = 'No',
}) =>
    showDialog<void>(
      context: context,
      builder: (final context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            autofocus: true,
            onPressed: yesCallback ?? () => Navigator.pop(context),
            child: Text(yesLabel),
          ),
          ElevatedButton(
            onPressed: noCallback ?? () => Navigator.pop(context),
            child: Text(noLabel),
          )
        ],
      ),
    );

/// Show a snackbar, with an optional action.
void showError({
  required final BuildContext context,
  required final String message,
  final String title = 'Error',
}) =>
    showDialog<void>(
      context: context,
      builder: (final context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
        title: Text(title),
        content: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.enter): () =>
                Navigator.pop(context)
          },
          child: Focus(
            autofocus: true,
            child: Text(message),
          ),
        ),
      ),
    );

/// Make a printable string from the given [assetReferenceReference].
String assetString(final AssetReferenceReference assetReferenceReference) =>
    '${assetReferenceReference.comment} '
    '(${assetReferenceReference.reference.type.name})';

/// Copy the given [text] to the [Clipboard].
void setClipboardText(final String text) {
  final data = ClipboardData(text: text);
  Clipboard.setData(data);
}

/// Create a new asset store.
Future<void> createAssetStore({
  required final BuildContext context,
  required final ProjectContext projectContext,
}) async {
  final project = projectContext.project;
  return pushWidget(
    context: context,
    builder: (final context) => CreateAssetStore(
      project: project,
      onDone: (final value) {
        project.assetStores.add(value);
        projectContext.save();
      },
    ),
  );
}

/// Create a new command trigger.
Future<void> createCommandTrigger({
  required final BuildContext context,
  required final ProjectContext projectContext,
}) async {
  final project = projectContext.project;
  final commandTriggerNumber = project.commandTriggers.length + 1;
  final commandTrigger = CommandTrigger(
    name: 'command_trigger_$commandTriggerNumber',
    description: 'Do something fun',
  );
  final commandTriggerReference = CommandTriggerReference(
    id: newId(),
    variableName: 'commandTrigger$commandTriggerNumber',
    commandTrigger: commandTrigger,
  );
  project.commandTriggers.add(commandTriggerReference);
  projectContext.save();
  return pushWidget(
    context: context,
    builder: (final context) => EditCommandTrigger(
      projectContext: projectContext,
      commandTriggerReference: commandTriggerReference,
    ),
  );
}

/// Select an asset.
Future<void> selectAsset({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final ValueChanged<PretendAssetReference?> onDone,
  final AssetStoreReference? assetStoreReference,
  final PretendAssetReference? pretendAssetReference,
}) =>
    pushWidget(
      context: context,
      builder: (final context) => SelectItem<AssetStoreReference>(
        onDone: (final assetStore) => pushWidget(
          context: context,
          builder: (final context) => SelectItem<PretendAssetReference>(
            onDone: onDone,
            values: assetStore.assets,
            getSearchString: (final value) => value.variableName,
            getWidget: (final value) => PlaySoundSemantics(
              child: Text('${value.variableName}: ${value.comment}'),
              soundChannel: projectContext.game.interfaceSounds,
              assetReference: value.assetReferenceReference.reference,
            ),
            title: 'Select Asset',
            value: pretendAssetReference,
          ),
        ),
        values: projectContext.project.assetStores,
        getSearchString: (final value) => value.name,
        getWidget: (final value) => Text('${value.name}: ${value.comment}'),
        title: 'Select Asset Store',
        value: assetStoreReference,
      ),
    );

/// Return a quoted version of [string].
String getQuotedString(final String string) {
  final result = string.replaceAll("'", r"\'");
  return "'$result'";
}
