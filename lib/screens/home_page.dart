import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../json/app_preferences.dart';
import '../json/project.dart';
import '../shortcuts.dart';
import '../src/project_context.dart';
import '../util.dart';
import '../widgets/simple_scaffold.dart';
import 'project_context_screen.dart';

const _loading = 'Loading';

/// The home page for the application.
class HomePage extends StatefulWidget {
  /// Create an instance.
  // ignore: prefer_final_parameters
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppPreferences? _appPreferences;
  Directory? _documentsDirectory;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final String title;
    final Widget child;
    final appPreferences = _appPreferences;
    final documentsDirectory = _documentsDirectory;
    if (appPreferences == null) {
      AppPreferences.load().then(
        (final value) => setState(
          () => _appPreferences = value,
        ),
      );
      title = _loading;
      child = const CircularProgressIndicator(
        semanticsLabel: 'Loading preferences...',
      );
    } else if (documentsDirectory == null) {
      getApplicationDocumentsDirectory().then(
        (final value) => setState(
          () => _documentsDirectory = value,
        ),
      );
      title = 'Loading';
      child = const CircularProgressIndicator(
        semanticsLabel: 'Loading documents directory...',
      );
    } else {
      final filename = appPreferences.lastLoadedFilename;
      if (filename == null || !File(filename).existsSync()) {
        title = 'Select Project';
        child = CallbackShortcuts(
          bindings: {
            newShortcut: () => newProject(initialDirectory: documentsDirectory),
            openShortcut: () => openProject(
                  context: context,
                  documentsDirectory: documentsDirectory,
                ),
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
                onTap: () => openProject(
                  context: context,
                  documentsDirectory: documentsDirectory,
                ),
              )
            ],
          ),
        );
      } else {
        final projectContext = ProjectContext.fromFile(
          File(filename),
        );
        return ProjectContextScreen(
          projectContext: projectContext,
          onClose: () => setState(
            () => _appPreferences = AppPreferences()..save(),
          ),
        );
      }
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
    await AppPreferences(lastLoadedFilename: result).save();
    final projectContext = ProjectContext(project: project, file: file)..save();
    await pushWidget(
      context: context,
      builder: (final context) => ProjectContextScreen(
        projectContext: projectContext,
      ),
    );
  }

  /// Open an existing project.
  Future<void> openProject({
    required final BuildContext context,
    required final Directory documentsDirectory,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['.json'],
      dialogTitle: 'Open Project',
      initialDirectory: documentsDirectory.path,
    );
    if (result == null) {
      return;
    }
    final path = result.paths.first;
    if (path == null) {
      return showError(
        context: context,
        message: 'Path is `null`.',
      );
    }
    final file = File(path);
    if (!file.existsSync()) {
      return showError(
        context: context,
        message: 'File does not exist: $path.',
      );
    }
    final projectContext = ProjectContext.fromFile(file);
    await pushWidget(
      context: context,
      builder: (final context) => ProjectContextScreen(
        projectContext: projectContext,
      ),
    );
  }
}
