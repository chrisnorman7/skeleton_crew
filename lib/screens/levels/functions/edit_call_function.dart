import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/functions/call_function.dart';
import '../../../json/levels/functions/function_reference.dart';
import '../../../json/levels/level_reference.dart';
import '../../../src/project_context.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/simple_scaffold.dart';
import '../../../widgets/sounds/sound_list_tile.dart';
import '../../../widgets/text_list_tile.dart';
import '../../lists/select_item.dart';

/// A widget for editing a call function [value].
class EditCallFunction extends StatefulWidget {
  /// Create an instance.
  const EditCallFunction({
    required this.projectContext,
    required this.levelReference,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The level that [value] is part of.
  final LevelReference levelReference;

  /// The call function to edit.
  final CallFunction value;

  /// The function to call when [value] changes.
  final ValueChanged<CallFunction?> onChanged;

  /// Create state for this widget.
  @override
  EditCallFunctionState createState() => EditCallFunctionState();
}

/// State for [EditCallFunction].
class EditCallFunctionState extends ProjectContextState<EditCallFunction> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final level = widget.levelReference;
    final callFunction = widget.value;
    final functionName = callFunction.functionName;
    final functions = level.functions;
    final function = functionName == null
        ? null
        : functions.firstWhere(
            (final element) => element.name == functionName,
          );
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Callback',
        body: ListView(
          children: [
            TextListTile(
              autofocus: true,
              value: callFunction.text ?? '',
              onChanged: (final value) {
                callFunction.text = value.isEmpty ? null : value;
                save();
              },
              header: 'Output Text',
            ),
            SoundListTile(
              projectContext: projectContext,
              value: callFunction.soundReference,
              onChanged: (final value) {
                callFunction.soundReference = value;
                save();
              },
            ),
            PushWidgetListTile(
              builder: (final context) => SelectItem<FunctionReference?>(
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      final functionReference = FunctionReference(
                        name: 'function${functions.length}',
                        comment: 'New function.',
                      );
                      functions.add(functionReference);
                      callFunction.functionName = functionReference.name;
                      save();
                    },
                    child: addIcon,
                  )
                ],
                onDone: (final value) {
                  callFunction.functionName = value?.name;
                  save();
                },
                values: [null, ...functions],
                getSearchString: (final value) =>
                    value == null ? 'Clear' : value.name,
                getWidget: (final value) => Text(
                  value == null ? 'Unset' : '${value.name}: ${value.comment}',
                ),
                title: 'Select Function',
                value: function,
              ),
              title: 'Function',
              subtitle: functionName ?? notSet,
            ),
          ],
        ),
      ),
    );
  }

  /// Save the value, and call `onChanged`.
  @override
  void save() {
    super.save();
    widget.onChanged(widget.value);
  }
}
