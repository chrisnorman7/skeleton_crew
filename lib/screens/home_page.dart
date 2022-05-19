import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../json/project.dart';
import '../shortcuts.dart';
import '../src/project_context.dart';
import '../util.dart';
import '../widgets/simple_scaffold.dart';
import 'project_context_screen.dart';

/// The home page for the application.
class HomePage extends StatefulWidget {
  /// Create an instance.
  // ignore: prefer_final_parameters
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Directory? _documentsDirectory;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final String title;
    final Widget child;
    final documentsDirectory = _documentsDirectory;
    if (documentsDirectory != null) {
      title = 'Select Project';
      child = CallbackShortcuts(
        bindings: {
          newShortcut: () => newProject(initialDirectory: documentsDirectory),
          openShortcut: openProject,
        },
        child: ListView(
          children: [
            ListTile(
              autofocus: true,
              title: const Text('New Project'),
              onTap: () => newProject(initialDirectory: documentsDirectory),
            ),
            ListTile(
              title: const Text('Open Project'),
              onTap: openProject,
            )
          ],
        ),
      );
    } else {
      title = 'Loading';
      child = const CircularProgressIndicator(
        semanticsLabel: 'Loading...',
      );
      getApplicationDocumentsDirectory().then(
        (final value) => setState(
          () => _documentsDirectory = value,
        ),
      );
    }
    return SimpleScaffold(
      title: title,
      body: child,
    );
  }

  /// Create a new project.
  Future<void> newProject({
    required final Directory initialDirectory,
  }) async {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save As',
      fileName: 'project.json',
      initialDirectory: initialDirectory.path,
    );
    if (result == null) {
      return;
    }
    final file = File(result);
    final project = Project(
      title: 'Untitled Game',
      commandTriggers: [],
      assetStores: [],
    );
    final projectContext = ProjectContext(project: project, file: file)..save();
    await pushWidget(
      context: context,
      builder: (final context) =>
          ProjectContextScreen(projectContext: projectContext),
    );
  }

  /// Open an existing project.
  void openProject() {}
}
