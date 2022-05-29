import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/functions/function_reference.dart';
import '../../../json/levels/level_reference.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../validators.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/simple_scaffold.dart';
import '../../../widgets/text_list_tile.dart';

/// A widget for editing a function reference [value].
class EditFunctionReference extends StatefulWidget {
  /// Create an instance.
  const EditFunctionReference({
    required this.projectContext,
    required this.levelReference,
    required this.value,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The level that [value] is part of.
  final LevelReference levelReference;

  /// The function reference to edit.
  final FunctionReference value;

  /// Create state for this widget.
  @override
  EditFunctionReferenceState createState() => EditFunctionReferenceState();
}

/// State for [EditFunctionReference].
class EditFunctionReferenceState
    extends ProjectContextState<EditFunctionReference> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final functionReference = widget.value;
    return Cancel(
      child: SimpleScaffold(
        actions: [
          ElevatedButton(
            onPressed: () => deleteFunctionReference(
              context: context,
              projectContext: projectContext,
              levelReference: widget.levelReference,
              functionReference: functionReference,
              onYes: () => Navigator.pop(context),
            ),
            child: deleteIcon,
          )
        ],
        title: 'Edit Function',
        body: ListView(
          children: [
            TextListTile(
              autofocus: true,
              value: functionReference.name,
              onChanged: (final value) {
                functionReference.name = value;
                save();
              },
              header: 'Name',
              title: 'Function Name',
              validator: (final value) => validateVariableName(
                value: value,
                variableNames: widget.levelReference.functions.map<String>(
                  (final e) => e.name,
                ),
              ),
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
            ),
          ],
        ),
      ),
    );
  }

  /// Save a new value.
  @override
  void save() {
    projectContext.save();
    setState(() {});
  }
}
