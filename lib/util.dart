import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ziggurat/ziggurat.dart';
import 'package:ziggurat_sounds/ziggurat_sounds.dart';

import 'constants.dart';
import 'json/asset_stores/asset_store_reference.dart';
import 'json/asset_stores/pretend_asset_reference.dart';
import 'json/command_trigger_reference.dart';
import 'json/levels/menus/menu_reference.dart';
import 'json/levels/sounds/ambiance_reference.dart';
import 'json/levels/sounds/sound_reference.dart';
import 'screens/asset_stores/create_asset_store.dart';
import 'screens/command_triggers/edit_command_trigger.dart';
import 'screens/lists/select_item.dart';
import 'screens/sounds/ambiances/edit_ambiance.dart';
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

/// Show a message with an OK button.
Future<void> showMessage({
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
              game: projectContext.game,
              child: Text('${value.variableName}: ${value.comment}'),
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
  if (string.contains("'")) {
    return jsonEncode(string);
  }
  final result = string.replaceAll('"', '"');
  return "'$result'";
}

/// Delete the given [assetReference].
Future<void> deleteAssetReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final PretendAssetReference assetReference,
  final VoidCallback? onYes,
}) {
  final project = projectContext.project;
  const prefix = 'You cannot delete the';
  for (final level in [...project.menus, ...project.levels]) {
    if (level.music?.assetReferenceId == assetReference.id) {
      return showMessage(
        context: context,
        message: '$prefix music for ${level.title}.',
      );
    }
    if (level is MenuReference) {
      for (final menuItem in level.menuItems) {
        if (menuItem.soundReference?.assetReferenceId == assetReference.id) {
          return showMessage(
            context: context,
            message: '$prefix sound for the "${menuItem.title}" item of the '
                '${level.title} menu.',
          );
        }
      }
    }
    for (final ambiance in level.ambiances) {
      if (ambiance.sound.assetReferenceId == assetReference.id) {
        return showMessage(
          context: context,
          message: '$prefix ${level.title} ambiance.',
        );
      }
    }
  }
  return confirm(
    context: context,
    message: 'Are you sure you want to delete this asset?',
    yesCallback: () {
      Navigator.pop(context);
      project.getAssetStore(assetReference.assetStoreId).assets.removeWhere(
            (final element) => element.id == assetReference.id,
          );
      if (onYes != null) {
        onYes();
      }
      projectContext.save();
    },
    title: 'Delete Asset',
  );
}

/// Delete the given [assetStore].
Future<void> deleteAssetStore({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final AssetStoreReference assetStore,
  final VoidCallback? onYes,
}) {
  final project = projectContext.project;
  if (assetStore.assets.isNotEmpty) {
    return showMessage(
      context: context,
      message: 'You cannot delete an asset store which still contains assets.',
    );
  } else {
    return confirm(
      context: context,
      message: 'Are you sure you want to delete this asset store?',
      yesCallback: () {
        Navigator.pop(context);
        project.assetStores.removeWhere(
          (final element) => element.id == assetStore.id,
        );
        projectContext.save();
        if (onYes != null) {
          onYes();
        }
      },
      title: 'Delete Asset Store',
    );
  }
}

/// Add a new ambiance.
Future<void> addAmbiance({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final List<AmbianceReference> ambiances,
  required final VoidCallback onDone,
}) =>
    selectAsset(
      context: context,
      projectContext: projectContext,
      onDone: (final value) async {
        if (value == null) {
          return;
        }
        final ambiance = AmbianceReference(
          id: newId(),
          sound: SoundReference(
            assetStoreId: value.assetStoreId,
            assetReferenceId: value.id,
          ),
        );
        ambiances.add(ambiance);
        projectContext.save();
        await pushWidget(
          context: context,
          builder: (final context) => EditAmbiance(
            projectContext: projectContext,
            ambiances: ambiances,
            value: ambiance,
          ),
        );
        onDone();
      },
    );

/// Delete the given [AmbianceReference] from the list of [ambiances].
Future<void> deleteAmbiance({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final List<AmbianceReference> ambiances,
  required final AmbianceReference ambianceReference,
  required final VoidCallback onYes,
}) =>
    confirm(
      context: context,
      message: 'Are you sure you want to delete this ambiance?',
      yesCallback: () {
        Navigator.pop(context);
        ambiances.removeWhere(
          (final element) => element.id == ambianceReference.id,
        );
        projectContext.save();
        onYes();
      },
      title: 'Delete Ambiance',
    );
