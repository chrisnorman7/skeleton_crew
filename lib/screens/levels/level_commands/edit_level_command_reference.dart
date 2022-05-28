import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/level_command_reference.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/function_reference_list_tile.dart';
import '../../../widgets/int_list_tile.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/simple_scaffold.dart';

/// A widget to edit the given [levelCommandReference].
class EditLevelCommandReference extends StatefulWidget {
  /// Create an instance.
  const EditLevelCommandReference({
    required this.projectContext,
    required this.commands,
    required this.levelCommandReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The commands that [levelCommandReference] originated from.
  final List<LevelCommandReference> commands;

  /// The command reference to edit.
  final LevelCommandReference levelCommandReference;

  /// Create state for this widget.
  /// The commands that [levelCommandReference] originated from.

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
    final command = widget.levelCommandReference;
    final commandTrigger = projectContext.project
        .getCommandTrigger(
          command.commandTriggerId,
        )
        .commandTrigger;
    final index =
        widget.commands.indexWhere((final element) => element.id == command.id);
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Command',
        actions: [
          ElevatedButton(
            onPressed: () => deleteLevelCommand(
              context: context,
              projectContext: projectContext,
              commands: widget.commands,
              command: command,
              onYes: () => Navigator.pop(context),
            ),
            child: deleteIcon,
          )
        ],
        body: ListView(
          children: [
            FunctionReferenceListTile(
              projectContext: projectContext,
              value: command.startFunction,
              onChanged: (final value) {
                command.startFunction = value;
                save();
              },
              autofocus: true,
              title: 'Start Function',
              defaultName: 'command${index}onStart',
              defaultComment: '${commandTrigger.description} start.',
            ),
            FunctionReferenceListTile(
              projectContext: projectContext,
              value: command.stopFunction,
              onChanged: (final value) {
                command.stopFunction = value;
                save();
              },
              title: 'Stop Function',
              defaultName: 'command${index}onStop',
              defaultComment: '${commandTrigger.description} stop.',
            ),
            FunctionReferenceListTile(
              projectContext: projectContext,
              value: command.undoFunction,
              onChanged: (final value) {
                command.undoFunction = value;
                save();
              },
              title: 'Undo Function',
              defaultName: 'command${index}onUndo',
              defaultComment: '${commandTrigger.description} undo.',
            ),
            IntListTile(
              value: command.interval ?? 0,
              onChanged: (final value) {
                command.interval = value == 0 ? null : value;
                save();
              },
              title: 'Command Interval',
              labelText: 'Interval',
              min: 0,
            )
          ],
        ),
      ),
    );
  }
}
