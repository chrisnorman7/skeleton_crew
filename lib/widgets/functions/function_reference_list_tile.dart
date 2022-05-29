import 'package:flutter/material.dart';

import '../../json/levels/functions/function_reference.dart';
import '../../json/levels/level_reference.dart';
import '../../screens/levels/functions/edit_function_reference.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../push_widget_list_tile.dart';
import 'functions_list.dart';

/// A list tile that shows a function reference [value].
class FunctionReferenceListTile extends StatefulWidget {
  /// Create an instance.
  const FunctionReferenceListTile({
    required this.projectContext,
    required this.levelReference,
    required this.value,
    required this.onDelete,
    this.autofocus = false,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The level that [value] is part of.
  final LevelReference levelReference;

  /// The value to use.
  final FunctionReference value;

  /// The function to call when [value] is deleted.
  final VoidCallback onDelete;

  /// Whether or not the resulting [ListTile] should be autofocused.
  final bool autofocus;

  @override
  State<FunctionReferenceListTile> createState() =>
      _FunctionReferenceListTileState();
}

class _FunctionReferenceListTileState extends State<FunctionReferenceListTile> {
  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final name = widget.value.name;
    final comment = widget.value.comment;
    return CallbackShortcuts(
      bindings: {
        deleteShortcut: () => deleteFunctionReference(
              context: context,
              projectContext: widget.projectContext,
              levelReference: widget.levelReference,
              functionReference: widget.value,
              onYes: widget.onDelete,
            )
      },
      child: PushWidgetListTile(
        title: name,
        subtitle: comment,
        builder: (final context) => EditFunctionReference(
          projectContext: widget.projectContext,
          levelReference: widget.levelReference,
          value: widget.value,
        ),
        autofocus: widget.autofocus,
        onSetState: () => setState(() {}),
      ),
    );
  }
}
