import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'json/asset_stores/asset_store_reference.dart';
import 'json/asset_stores/pretend_asset_reference.dart';
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

/// Copy the given [text] to the [Clipboard].
void setClipboardText(final String text) {
  final data = ClipboardData(text: text);
  Clipboard.setData(data);
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
              assetReference: value.isAudio
                  ? value.assetReferenceReference.reference
                  : null,
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
