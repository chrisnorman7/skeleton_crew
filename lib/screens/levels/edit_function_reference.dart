import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/levels/function_reference.dart';
import '../../src/project_context.dart';
import '../../validators.dart';
import '../../widgets/cancel.dart';
import '../../widgets/simple_scaffold.dart';
import '../../widgets/sounds/sound_list_tile.dart';
import '../../widgets/text_list_tile.dart';

/// A widget for editing a function reference [value].
class EditFunctionReference extends StatefulWidget {
  /// Create an instance.
  const EditFunctionReference({
    required this.projectContext,
    required this.value,
    required this.onChanged,
    this.nullable = true,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The function reference to edit.
  final FunctionReference value;

  /// The function to call when [value] changes.
  final ValueChanged<FunctionReference?> onChanged;

  /// Whether or not [value] is nullable.
  final bool nullable;

  /// Create state for this widget.
  @override
  EditFunctionReferenceState createState() => EditFunctionReferenceState();
}

/// State for [EditFunctionReference].
class EditFunctionReferenceState extends State<EditFunctionReference> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final functionReference = widget.value;
    return Cancel(
      child: SimpleScaffold(
        actions: [
          if (widget.nullable)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onChanged(null);
              },
              child: deleteIcon,
            )
        ],
        title: 'Edit Function',
        body: ListView(
          children: [
            TextListTile(
              value: functionReference.name,
              onChanged: (final value) {
                functionReference.name = value;
                save();
              },
              header: 'Name',
              title: 'Function Name',
              validator: (final value) => validateVariableName(value: value),
            ),
            TextListTile(
              autofocus: true,
              value: functionReference.comment,
              onChanged: (final value) {
                functionReference.comment = value;
                save();
              },
              header: 'Comment',
              title: 'Comment',
              validator: (final value) => validateNonEmptyValue(value: value),
            ),
            TextListTile(
              value: functionReference.text ?? '',
              onChanged: (final value) {
                functionReference.text = value.isEmpty ? null : value;
                save();
              },
              header: 'Output Text',
            ),
            SoundListTile(
              projectContext: widget.projectContext,
              value: functionReference.soundReference,
              onChanged: (final value) {
                functionReference.soundReference = value;
                save();
              },
            )
          ],
        ),
      ),
    );
  }

  /// Save a new value.
  void save() {
    widget.onChanged(widget.value);
    setState(() {});
  }
}
