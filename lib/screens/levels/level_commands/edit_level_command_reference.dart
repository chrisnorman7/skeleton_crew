import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/level_command_reference.dart';
import '../../../json/levels/level_reference.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/int_list_tile.dart';
import '../../../widgets/level_commands/call_function_list_tile.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/simple_scaffold.dart';

/// A widget to edit the given [value].
class EditLevelCommandReference extends StatefulWidget {
  /// Create an instance.
  const EditLevelCommandReference({
    required this.projectContext,
    required this.levelReference,
    required this.value,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The level that [value] is part of.
  final LevelReference levelReference;

  /// The command reference to edit.
  final LevelCommandReference value;

  /// Create state for this widget.
  /// The commands that [value] originated from.

  @override
  EditLevelCommandReferenceState createState() =>
      EditLevelCommandReferenceState();
}

/// State for [EditLevelCommandReference ].
class EditLevelCommandReferenceState
    extends ProjectContextState<EditLevelCommandReference> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  @override
  Widget build(final BuildContext context) {
    final command = widget.value;
    final commandInterval = command.interval;
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Command',
        actions: [
          ElevatedButton(
            onPressed: () => deleteLevelCommand(
              context: context,
              projectContext: projectContext,
              commands: widget.levelReference.commands,
              command: command,
              onYes: () => Navigator.pop(context),
            ),
            child: deleteIcon,
          )
        ],
        body: ListView(
          children: [
            CallFunctionListTile(
              projectContext: projectContext,
              levelReference: widget.levelReference,
              value: command.startFunction,
              onChanged: (final value) {
                command.startFunction = value;
                save();
              },
              autofocus: true,
              title: 'Start Function',
            ),
            CallFunctionListTile(
              projectContext: projectContext,
              levelReference: widget.levelReference,
              value: command.stopFunction,
              onChanged: (final value) {
                command.stopFunction = value;
                save();
              },
              title: 'Stop Function',
            ),
            CallFunctionListTile(
              projectContext: projectContext,
              levelReference: widget.levelReference,
              value: command.undoFunction,
              onChanged: (final value) {
                command.undoFunction = value;
                save();
              },
              title: 'Undo Function',
            ),
            IntListTile(
              value: commandInterval ?? 0,
              onChanged: (final value) {
                command.interval = value == 0 ? null : value;
                save();
              },
              title: 'Command Interval',
              labelText: 'Interval',
              min: 0,
              modifier: 100,
              subtitle: commandInterval == null
                  ? 'Will Not Repeat'
                  : '$commandInterval ms',
            )
          ],
        ),
      ),
    );
  }
}
