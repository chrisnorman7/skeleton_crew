import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/levels/function_reference.dart';
import '../../validators.dart';
import '../../widgets/cancel.dart';
import '../../widgets/simple_scaffold.dart';
import '../../widgets/text_list_tile.dart';

/// A widget for editing a function reference [value].
class EditFunctionReference extends StatefulWidget {
  /// Create an instance.
  const EditFunctionReference({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// The function reference to edit.
  final FunctionReference value;

  /// The function to call when [value] changes.
  final ValueChanged<FunctionReference?> onChanged;

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
              autofocus: true,
              title: 'Function Name',
              validator: (final value) => validateVariableName(value: value),
            ),
            TextListTile(
              value: functionReference.comment,
              onChanged: (final value) {
                functionReference.comment = value;
                save();
              },
              header: 'Comment',
              title: 'Comment',
              validator: (final value) => validateNonEmptyValue(value: value),
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
