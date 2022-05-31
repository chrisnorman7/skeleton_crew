import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/level_reference.dart';
import '../../../src/project_context.dart';
import '../../../validators.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/functions/functions_tabbed_scaffold_tab.dart';
import '../../../widgets/level_commands/level_commands_tabbed_scaffold_tab.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/sounds/ambiances/ambiances_tabbed_scaffold_tab.dart';
import '../../../widgets/sounds/sound_list_tile.dart';
import '../../../widgets/tabbed_scaffold.dart';
import '../../../widgets/text_list_tile.dart';
import 'levels_list.dart';

/// A widget for editing the given [levelReference].
class EditLevelReference extends StatefulWidget {
  /// Create an instance.
  const EditLevelReference({
    required this.projectContext,
    required this.levelReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The level to edit.
  final LevelReference levelReference;

  /// Create state for this widget.
  @override
  EditLevelReferenceState createState() => EditLevelReferenceState();
}

/// State for [EditLevelReference].
class EditLevelReferenceState extends ProjectContextState<EditLevelReference> {
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
    return Cancel(
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            title: 'Settings',
            icon: const Icon(Icons.settings),
            builder: (final context) => ListView(
              children: [
                TextListTile(
                  value: level.className,
                  onChanged: (final value) {
                    level.className = value;
                    save();
                  },
                  header: 'Class Name',
                  validator: (final value) => validateClassName(
                    value: value,
                    classNames: projectContext.project.levels.map<String>(
                      (final e) => e.className,
                    ),
                  ),
                ),
                TextListTile(
                  value: level.comment,
                  onChanged: (final value) {
                    level.comment = value;
                    save();
                  },
                  header: 'Comment',
                  validator: (final value) =>
                      validateNonEmptyValue(value: value),
                ),
                TextListTile(
                  value: level.title,
                  onChanged: (final value) {
                    level.title = value;
                    save();
                  },
                  header: 'Title',
                  autofocus: true,
                  validator: (final value) =>
                      validateNonEmptyValue(value: value),
                ),
                SoundListTile(
                  projectContext: projectContext,
                  value: level.music,
                  onChanged: (final value) {
                    level.music = value;
                    save();
                  },
                  title: 'Music',
                )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => deleteLevelReference(
                  context: context,
                  projectContext: projectContext,
                  levelReference: level,
                  onYes: () => Navigator.pop(context),
                ),
                child: deleteIcon,
              )
            ],
          ),
          FunctionsTabbedScaffoldTab(
            context: context,
            projectContext: projectContext,
            levelReference: level,
            onDone: () => setState(() {}),
          ),
          LevelCommandsTabbedScaffoldTab(
            context: context,
            projectContext: projectContext,
            levelReference: level,
            onDone: () => setState(() {}),
          ),
          AmbiancesTabbedScaffoldTab(
            context: context,
            projectContext: projectContext,
            ambiances: level.ambiances,
            onDone: () => setState(() {}),
          ),
        ],
      ),
    );
  }

  /// Add a new ambiance.
}
