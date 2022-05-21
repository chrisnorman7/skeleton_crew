import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../json/command_trigger_reference.dart';
import '../shortcuts.dart';
import '../src/project_context.dart';
import '../util.dart';
import '../validators.dart';
import '../widgets/center_text.dart';
import '../widgets/project_context_state.dart';
import '../widgets/push_widget_list_tile.dart';
import '../widgets/searchable_list_view.dart';
import '../widgets/tabbed_scaffold.dart';
import '../widgets/text_list_tile.dart';
import 'asset_stores/create_asset_store.dart';
import 'asset_stores/edit_asset_store.dart';
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
  Widget build(final BuildContext context) {
    final project = projectContext.project;
    final actions = [
      ElevatedButton(
        onPressed: closeProject,
        child: closeIcon,
      )
    ];
    final assetStores = project.assetStores;
    final commandTriggers = project.commandTriggers;
    return CallbackShortcuts(
      bindings: {
        closeProjectShortcut: closeProject,
        buildProjectShortcut: () => buildProject(context)
      },
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            actions: actions,
            title: 'Project Settings',
            icon: const Icon(Icons.settings),
            builder: (final context) => ListView(
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
                  validator: (final value) =>
                      validateNonEmptyValue(value: value),
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
                TextListTile(
                  value: project.commandTriggersFilename,
                  onChanged: (final value) {
                    project.commandTriggersFilename = value;
                    save();
                  },
                  header: 'Command Triggers Filename',
                  labelText: 'Filename',
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.build),
              onPressed: () => buildProject(context),
              tooltip: 'Build Project',
            ),
          ),
          TabbedScaffoldTab(
            actions: actions,
            title: 'Asset Stores',
            icon: filesIcon,
            builder: (final context) {
              final Widget child;
              if (assetStores.isEmpty) {
                child =
                    const CenterText(text: 'There are no asset stores yet.');
              } else {
                final children = <SearchableListTile>[];
                for (var i = 0; i < project.assetStores.length; i++) {
                  final assetStoreReference = project.assetStores[i];
                  final numberOfAssets =
                      assetStoreReference.assetStore.assets.length;
                  children.add(
                    SearchableListTile(
                      searchString: assetStoreReference.name,
                      child: PushWidgetListTile(
                        builder: (final context) => EditAssetStore(
                          projectContext: projectContext,
                          assetStoreReference: assetStoreReference,
                        ),
                        onSetState: () => setState(() {}),
                        autofocus: i == 0,
                        title: '${assetStoreReference.name} ($numberOfAssets)',
                        subtitle: '${assetStoreReference.assetStore.comment}',
                      ),
                    ),
                  );
                }
                child = SearchableListView(children: children);
              }
              return CallbackShortcuts(
                bindings: {newShortcut: () => createAssetStore(context)},
                child: child,
              );
            },
            floatingActionButton: FloatingActionButton(
              autofocus: assetStores.isEmpty,
              child: addIcon,
              onPressed: () => createAssetStore(context),
            ),
          ),
          TabbedScaffoldTab(
            actions: actions,
            title: 'Command Triggers',
            icon: const Icon(Icons.mouse),
            builder: (final context) {
              final Widget child;
              if (commandTriggers.isEmpty) {
                child = const CenterText(
                  text: 'There are no command triggers yet.',
                );
              } else {
                child = ListView.builder(
                  itemBuilder: (final context, final index) {
                    final commandTriggerReference = commandTriggers[index];
                    final commandTrigger =
                        commandTriggerReference.commandTrigger;
                    return ListTile(
                      autofocus: index == 0,
                      title: Text(commandTrigger.name),
                      subtitle: Text(commandTrigger.description),
                      onTap: () => editCommandTrigger(
                        buildContext: context,
                        commandTriggerReference: commandTriggerReference,
                      ),
                    );
                  },
                  itemCount: project.commandTriggers.length,
                );
              }
              return CallbackShortcuts(
                bindings: {newShortcut: () => createCommandTrigger(context)},
                child: child,
              );
            },
            floatingActionButton: FloatingActionButton(
              autofocus: commandTriggers.isEmpty,
              child: addIcon,
              onPressed: () => createCommandTrigger(context),
              tooltip: 'Add Command Trigger',
            ),
          )
        ],
      ),
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
      showError(
        context: context,
        message: 'Build completed in $duration milliseconds.',
        title: 'Complete',
      );
    } on FormatterException catch (e, s) {
      showError(context: context, message: '$e\n$s');
    }
  }

  /// Create a new command trigger.
  Future<void> createCommandTrigger(final BuildContext context) async {
    final project = projectContext.project;
    final commandTrigger = CommandTrigger(
      name: newId(),
      description: 'Do something fun',
    );
    final commandTriggerReference = CommandTriggerReference(
      id: newId(),
      variableName: 'commandTrigger${project.commandTriggers.length + 1}',
      commandTrigger: commandTrigger,
    );
    project.commandTriggers.add(commandTriggerReference);
    projectContext.save();
    await pushWidget(
      context: context,
      builder: (final context) => EditCommandTrigger(
        projectContext: projectContext,
        commandTriggerReference: commandTriggerReference,
      ),
    );
    setState(() {});
  }

  /// Create a new asset store.
  void createAssetStore(final BuildContext context) => pushWidget(
        context: context,
        builder: (final context) {
          final project = projectContext.project;
          return CreateAssetStore(
            project: project,
            onDone: (final value) {
              project.assetStores.add(value);
              save();
            },
          );
        },
      );
}
