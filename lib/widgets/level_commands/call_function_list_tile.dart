import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/levels/functions/call_function.dart';
import '../../json/levels/level_reference.dart';
import '../../screens/levels/functions/edit_call_function.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../push_widget_list_tile.dart';
import '../sounds/play_sound_semantics.dart';

/// A widget to show a call function [value].
class CallFunctionListTile extends StatelessWidget {
  /// Create an instance.
  const CallFunctionListTile({
    required this.projectContext,
    required this.levelReference,
    required this.value,
    required this.onChanged,
    this.title = 'Call Function',
    this.autofocus = false,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The level that [value] belongs to.
  final LevelReference levelReference;

  /// The call function to show.
  final CallFunction? value;

  /// The function to call when [value] changes.
  final ValueChanged<CallFunction?> onChanged;

  /// The title of the resulting [ListTile].
  final String title;

  /// Whether the resulting [ListTile] should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final callFunction = value;
    final sound = callFunction?.soundReference;
    final assetReference = sound == null
        ? null
        : projectContext.project
            .getPretendAssetReference(sound)
            .assetReferenceReference
            .reference;
    return CallbackShortcuts(
      bindings: {deleteShortcut: () => onChanged(null)},
      child: PlaySoundSemantics(
        child: Builder(
          builder: (final builderContext) => PushWidgetListTile(
            autofocus: autofocus,
            title: title,
            builder: (final context) {
              PlaySoundSemantics.of(builderContext)?.stop();
              return EditCallFunction(
                projectContext: projectContext,
                levelReference: levelReference,
                value: callFunction ?? CallFunction(id: newId()),
                onChanged: onChanged,
              );
            },
            subtitle: callFunction == null ? notSet : 'Set',
          ),
        ),
        game: projectContext.game,
        assetReference: assetReference,
        gain: sound?.gain ?? 1.0,
      ),
    );
  }
}
