import 'package:flutter/material.dart';

import '../../../json/levels/level_command_reference.dart';
import '../../../json/levels/level_reference.dart';
import '../../../shortcuts.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/center_text.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/searchable_list_view.dart';
import '../../command_triggers/select_command_trigger.dart';
import 'edit_level_command_reference.dart';

/// A widget that allows the editing of commands from a [levelReference].
class LevelCommandsList extends StatefulWidget {
  /// Create an instance.
  const LevelCommandsList({
    required this.projectContext,
    required this.levelReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The level that contains the commands to edit.
  final LevelReference levelReference;

  /// Create state for this widget.
  @override
  LevelCommandsListState createState() => LevelCommandsListState();
}

/// State for [LevelCommandsList].
class LevelCommandsListState extends ProjectContextState<LevelCommandsList> {
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
    final commands = level.commands;
    final Widget child;
    if (commands.isEmpty) {
      child = const CenterText(text: 'There are no commands to show.');
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < commands.length; i++) {
        final command = commands[i];
        final commandTrigger = projectContext.project.getCommandTrigger(
          command.commandTriggerId,
        );
        children.add(
          SearchableListTile(
            searchString: commandTrigger.commandTrigger.description,
            child: CallbackShortcuts(
              bindings: {
                deleteShortcut: () => deleteLevelCommand(
                      context: context,
                      projectContext: projectContext,
                      commands: commands,
                      command: command,
                      onYes: () => setState(() {}),
                    )
              },
              child: PushWidgetListTile(
                autofocus: i == 0,
                title: commandTrigger.commandTrigger.description,
                builder: (final context) => EditLevelCommandReference(
                  projectContext: projectContext,
                  levelReference: level,
                  value: command,
                ),
              ),
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return CallbackShortcuts(
      bindings: {
        newShortcut: () => createLevelCommand(
              context: context,
              projectContext: projectContext,
              levelReference: level,
              onDone: () => setState(() {}),
            )
      },
      child: child,
    );
  }
}

/// Create a new level command.
Future<void> createLevelCommand({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final LevelReference levelReference,
  required final VoidCallback onDone,
}) =>
    pushWidget(
      context: context,
      builder: (final context) => SelectCommandTrigger(
        projectContext: projectContext,
        onChanged: (final value) async {
          if (value == null) {
            return;
          }
          final levelCommand = LevelCommandReference(
            id: newId(),
            commandTriggerId: value.id,
          );
          levelReference.commands.add(levelCommand);
          projectContext.save();
          await pushWidget(
            context: context,
            builder: (final context) => EditLevelCommandReference(
              projectContext: projectContext,
              levelReference: levelReference,
              value: levelCommand,
            ),
          );
          onDone();
        },
        ignoredCommandTriggerNames: levelReference.commands.map<String>(
          (final e) {
            final commandTrigger =
                projectContext.project.getCommandTrigger(e.commandTriggerId);
            return commandTrigger.commandTrigger.name;
          },
        ).toList(),
      ),
    );

/// Delete the given [command] from the given [commands].
Future<void> deleteLevelCommand({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final List<LevelCommandReference> commands,
  required final LevelCommandReference command,
  required final VoidCallback onYes,
}) =>
    confirm(
      context: context,
      message: 'Are you sure you want to delete this command?',
      title: 'Delete Command',
      yesCallback: () {
        Navigator.pop(context);
        commands.removeWhere(
          (final element) => element.id == command.id,
        );
        projectContext.save();
        onYes();
      },
    );
