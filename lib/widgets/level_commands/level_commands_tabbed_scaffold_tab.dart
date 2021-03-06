import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/levels/level_reference.dart';
import '../../screens/levels/level_commands/level_commands_list.dart';
import '../../src/project_context.dart';
import '../tabbed_scaffold.dart';

/// A tab that allows the editing of level commands.
class LevelCommandsTabbedScaffoldTab extends TabbedScaffoldTab {
  /// Create an instance.
  LevelCommandsTabbedScaffoldTab({
    required final BuildContext context,
    required final ProjectContext projectContext,
    required final LevelReference levelReference,
    required final VoidCallback onDone,
  }) : super(
          title: 'Commands',
          icon: commandTriggersIcon,
          builder: (final context) => LevelCommandsList(
            projectContext: projectContext,
            levelReference: levelReference,
          ),
          floatingActionButton: FloatingActionButton(
            autofocus: levelReference.commands.isEmpty,
            child: addIcon,
            onPressed: () => createLevelCommand(
              context: context,
              projectContext: projectContext,
              levelReference: levelReference,
              onDone: onDone,
            ),
          ),
        );
}
