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
class CallFunctionListTile extends StatefulWidget {
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

  @override
  State<CallFunctionListTile> createState() => _CallFunctionListTileState();
}

class _CallFunctionListTileState extends State<CallFunctionListTile> {
  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final project = widget.projectContext.project;
    final callFunction = widget.value;
    final sound = callFunction?.soundReference;
    final pretendAssetReference =
        sound == null ? null : project.getPretendAssetReference(sound);
    final assetReference =
        pretendAssetReference?.assetReferenceReference.reference;
    final String subtitle;
    if (callFunction == null) {
      subtitle = notSet;
    } else {
      final entries = <String>[];
      final text = callFunction.text;
      if (text != null) {
        entries.add(getQuotedString(text));
      }
      if (pretendAssetReference != null) {
        final assetStore = project.getAssetStore(
          pretendAssetReference.assetStoreId,
        );
        entries.add(assetStore.getPrintableString(pretendAssetReference));
      }
      final functionId = callFunction.functionId;
      if (functionId != null) {
        entries.add(
          widget.levelReference.getFunctionReference(functionId).name,
        );
      }
      if (entries.isEmpty) {
        subtitle = 'Default';
      } else {
        subtitle = entries.join(', ');
      }
    }
    return CallbackShortcuts(
      bindings: {
        deleteShortcut: () => widget.onChanged(null),
      },
      child: PlaySoundSemantics(
        child: Builder(
          builder: (final builderContext) => PushWidgetListTile(
            autofocus: widget.autofocus,
            title: widget.title,
            builder: (final context) {
              PlaySoundSemantics.of(builderContext)?.stop();
              return EditCallFunction(
                projectContext: widget.projectContext,
                levelReference: widget.levelReference,
                value: callFunction ?? CallFunction(id: newId()),
                onChanged: widget.onChanged,
              );
            },
            subtitle: subtitle,
            onSetState: () => setState(() {}),
          ),
        ),
        game: widget.projectContext.game,
        assetReference: assetReference,
        gain: sound?.gain ?? 1.0,
      ),
    );
  }
}
