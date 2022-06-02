import 'package:flutter/material.dart';

import '../constants.dart';
import '../json/message_reference.dart';
import '../screens/edit_message_reference.dart';
import '../shortcuts.dart';
import '../src/project_context.dart';
import '../util.dart';
import 'push_widget_list_tile.dart';
import 'sounds/play_sound_semantics.dart';

/// A list tile to display a [MessageReference] [value].
class MessageReferenceListTile extends StatelessWidget {
  /// Create an instance.
  const MessageReferenceListTile({
    required this.projectContext,
    required this.value,
    required this.onChanged,
    this.nullable = false,
    this.autofocus = false,
    this.title = 'Message',
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The message to edit.
  final MessageReference? value;

  /// The function to call when [value] is changed.
  final ValueChanged<MessageReference?> onChanged;

  /// The title of this list tile.
  final String title;

  /// Whether this list tile should be autofocused.
  final bool autofocus;

  /// Whether [value] can be set to `null`.
  final bool nullable;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final text = value?.text;
    final sound = value?.soundReference;
    final assetReference = sound == null
        ? null
        : projectContext.project
            .getPretendAssetReference(sound)
            .assetReferenceReference
            .reference;
    return CallbackShortcuts(
      bindings: {
        deleteShortcut: () {
          if (nullable && value != null) {
            confirm(
              context: context,
              message: 'Are you sure you want to clear this message?',
              title: 'Clear Message',
              yesCallback: () {
                Navigator.pop(context);
                onChanged(null);
              },
            );
          }
        }
      },
      child: PlaySoundSemantics(
        child: PushWidgetListTile(
          autofocus: autofocus,
          title: title,
          builder: (final context) {
            var message = value;
            if (message == null) {
              message = MessageReference(id: newId());
              onChanged(message);
            }
            return EditMessageReference(
              projectContext: projectContext,
              messageReference: message,
            );
          },
          subtitle: value == null ? notSet : '$text',
        ),
        game: projectContext.game,
        assetReference: assetReference,
        gain: sound?.gain ?? 1.0,
      ),
    );
  }
}
