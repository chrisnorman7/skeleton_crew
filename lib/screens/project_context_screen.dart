import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../json/command_trigger_reference.dart';
import '../shortcuts.dart';
import '../src/project_context.dart';
import '../util.dart';
import '../widgets/project_context_state.dart';
import '../widgets/tabbed_scaffold.dart';
import '../widgets/tabs/asset_stores_tab.dart';
import '../widgets/tabs/command_triggers_tab.dart';
import '../widgets/tabs/levels_tab.dart';
import '../widgets/tabs/project_settings_tab.dart';
import 'command_triggers/edit_command_trigger.dart';

/// The main screen for a [projectContext].
class ProjectContextScreen extends StatefulWidget {
  /// Create an instance.
  const ProjectContextScreen({
    required this.projectContext,
    this.onClose,
    // ignore: prefer_final_parameters
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The function to call to close this widget.
  ///
  /// If this value is `null`, then `Navigator.pop` will be called.
  final VoidCallback? onClose;

  /// Create state for this widget.
  @override
  ProjectContextScreenState createState() => ProjectContextScreenState();
}

/// State for [ProjectContextScreen].
class ProjectContextScreenState
    extends ProjectContextState<ProjectContextScreen> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => CallbackShortcuts(
        bindings: {
          closeProjectShortcut: closeProject,
          buildProjectShortcut: () => buildProject(context)
        },
        child: getTabbedScaffold(context),
      );

  /// Get the tabbed scaffold to use.
  TabbedScaffold getTabbedScaffold(final BuildContext context) {
    final project = projectContext.project;
    final assetStores = project.assetStores;
    final commandTriggers = project.commandTriggers;
    final actions = [
      ElevatedButton(
        onPressed: closeProject,
        child: closeIcon,
      )
    ];
    return TabbedScaffold(
      tabs: [
        TabbedScaffoldTab(
          actions: actions,
          title: 'Project Settings',
          icon: const Icon(Icons.settings),
          builder: (final context) => ProjectSettingsTab(
            projectContext: projectContext,
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.build),
            onPressed: () => buildProject(context),
            tooltip: 'Build Project',
          ),
        ),
        TabbedScaffoldTab(
          title: 'Levels',
          icon: const Icon(Icons.workspace_premium),
          builder: (final context) => LevelsTab(
            projectContext: projectContext,
          ),
        ),
        TabbedScaffoldTab(
          actions: actions,
          title: 'Asset Stores',
          icon: filesIcon,
          builder: (final context) => AssetStoresTab(
            projectContext: projectContext,
          ),
          floatingActionButton: FloatingActionButton(
            autofocus: assetStores.isEmpty,
            child: addIcon,
            onPressed: () async {
              await createAssetStore(
                context: context,
                projectContext: projectContext,
              );
              setState(() {});
            },
          ),
        ),
        TabbedScaffoldTab(
          actions: actions,
          title: 'Command Triggers',
          icon: const Icon(Icons.mouse),
          builder: (final context) => CommandTriggersTab(
            projectContext: projectContext,
          ),
          floatingActionButton: FloatingActionButton(
            autofocus: commandTriggers.isEmpty,
            child: addIcon,
            onPressed: () async {
              await createCommandTrigger(
                context: context,
                projectContext: projectContext,
              );
              setState(() {});
            },
            tooltip: 'Add Command Trigger',
          ),
        )
      ],
    );
  }

  /// Close the project.
  void closeProject() {
    final f = widget.onClose;
    if (f == null) {
      Navigator.pop(context);
    } else {
      f();
    }
  }

  /// Edit the given [commandTriggerReference].
  Future<void> editCommandTrigger({
    required final BuildContext buildContext,
    required final CommandTriggerReference commandTriggerReference,
  }) async {
    await pushWidget(
      context: context,
      builder: (final context) => EditCommandTrigger(
        projectContext: projectContext,
        commandTriggerReference: commandTriggerReference,
      ),
    );
    setState(() {});
  }

  /// Build the project.
  void buildProject(final BuildContext context) {
    final started = DateTime.now().millisecondsSinceEpoch;
    try {
      projectContext.build();
      final duration = DateTime.now().millisecondsSinceEpoch - started;
      showMessage(
        context: context,
        message: 'Build completed in $duration milliseconds.',
        title: 'Complete',
      );
    } on FormatterException catch (e, s) {
      showMessage(context: context, message: '$e\n$s');
    }
  }
}
