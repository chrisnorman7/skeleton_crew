import 'package:flutter/material.dart';

import '../../../json/levels/level_command_reference.dart';
import '../../../shortcuts.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/center_text.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/searchable_list_view.dart';
import 'edit_level_command_reference.dart';

/// A widget that allows the editing of a list of [commands].
class LevelCommandsList extends StatefulWidget {
  /// Create an instance.
  const LevelCommandsList({
    required this.projectContext,
    required this.commands,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The commands to edit.
  final List<LevelCommandReference> commands;

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
    final commands = widget.commands;
    if (commands.isEmpty) {
      return const CenterText(text: 'There are no commands to show.');
    }
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
                    commands: widget.commands,
                    command: command,
                    onYes: () => setState(() {}),
                  )
            },
            child: PushWidgetListTile(
              autofocus: i == 0,
              title: commandTrigger.commandTrigger.description,
              builder: (final context) => EditLevelCommandReference(
                projectContext: projectContext,
                commands: widget.commands,
                levelCommandReference: command,
              ),
            ),
          ),
        ),
      );
    }
    return SearchableListView(children: children);
  }
}
