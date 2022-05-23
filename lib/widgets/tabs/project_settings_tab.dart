import 'package:flutter/material.dart';

import '../../src/project_context.dart';
import '../../validators.dart';
import '../project_context_state.dart';
import '../text_list_tile.dart';

/// The widget that shows the project settings.
class ProjectSettingsTab extends StatefulWidget {
  /// Create an instance.
  const ProjectSettingsTab({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  ProjectSettingsTabState createState() => ProjectSettingsTabState();
}

/// State for [ProjectSettingsTab].
class ProjectSettingsTabState extends ProjectContextState<ProjectSettingsTab> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = projectContext.project;
    return ListView(
      children: [
        TextListTile(
          value: project.title,
          onChanged: (final value) {
            project.title = value;
            save();
          },
          header: 'Project Title',
          autofocus: true,
          labelText: 'Title',
          validator: (final value) => validateNonEmptyValue(
            value: value,
          ),
        ),
        TextListTile(
          value: project.version,
          onChanged: (final value) {
            project.version = value;
            save();
          },
          header: 'Project Version',
          labelText: 'Version',
        ),
        TextListTile(
          value: project.orgName,
          onChanged: (final value) {
            project.orgName = value;
            save();
          },
          header: 'Organisation Name',
        ),
        TextListTile(
          value: project.appName,
          onChanged: (final value) {
            project.appName = value;
            save();
          },
          header: 'Application Name',
        ),
        TextListTile(
          value: project.outputDirectory,
          onChanged: (final value) {
            project.outputDirectory = value;
            save();
          },
          header: 'Output Directory',
        ),
      ],
    );
  }
}
