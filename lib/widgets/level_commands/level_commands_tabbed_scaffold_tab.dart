import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/levels/level_command_reference.dart';
import '../../screens/command_triggers/select_command_trigger.dart';
import '../../screens/levels/level_commands/edit_level_command_reference.dart';
import '../../screens/levels/level_commands/level_commands_list.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../tabbed_scaffold.dart';

/// A tab that allows the editing of level commands.
class LevelCommandsTabbedScaffoldTab extends TabbedScaffoldTab {
  /// Create an instance.
  LevelCommandsTabbedScaffoldTab({
    required final BuildContext context,
    required final ProjectContext projectContext,
    required final List<LevelCommandReference> commands,
    required final VoidCallback onDone,
  }) : super(
          title: 'Commands',
          icon: commandTriggersIcon,
          builder: (final context) => LevelCommandsList(
            projectContext: projectContext,
            commands: commands,
          ),
          floatingActionButton: FloatingActionButton(
            autofocus: commands.isEmpty,
            child: addIcon,
            onPressed: () => pushWidget(
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
                  commands.add(levelCommand);
                  projectContext.save();
                  await pushWidget(
                    context: context,
                    builder: (final context) => EditLevelCommandReference(
                      projectContext: projectContext,
                      commands: commands,
                      levelCommandReference: levelCommand,
                    ),
                  );
                  onDone();
                },
              ),
            ),
          ),
        );
}
