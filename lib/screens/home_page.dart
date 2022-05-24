// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:ziggurat/ziggurat.dart';
import 'package:ziggurat_sounds/ziggurat_sounds.dart';

import '../json/app_preferences.dart';
import '../json/project.dart';
import '../project_sound_manager.dart';
import '../shortcuts.dart';
import '../src/project_context.dart';
import '../util.dart';
import '../widgets/simple_scaffold.dart';
import 'project_context_screen.dart';

const _loading = 'Loading';

/// The home page for the application.
class HomePage extends StatefulWidget {
  /// Create an instance.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Synthizer _synthizer;
  late final Context _audioContext;
  late final Game _game;
  late final ProjectSoundManager _projectSoundManager;
  AppPreferences? _appPreferences;
  Directory? _documentsDirectory;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _synthizer = Synthizer();
    String? libsndfilePath;
    if (Platform.isLinux) {
      libsndfilePath = './libsndfile.so';
    } else if (Platform.isWindows) {
      libsndfilePath = 'libsndfile-1.dll';
    } else if (Platform.isMacOS) {
      libsndfilePath = 'libsndfile.dylib';
    }
    if (libsndfilePath == null || File(libsndfilePath).existsSync() == false) {
      libsndfilePath = null;
    }
    _synthizer.initialize(libsndfilePath: libsndfilePath);
    _audioContext = _synthizer.createContext();
    _game = Game('Skeleton Crew');
    _projectSoundManager = ProjectSoundManager(
      game: _game,
      context: _audioContext,
      soundsDirectory: '.',
      bufferCache: BufferCache(
        synthizer: _synthizer,
        maxSize: pow(1024, 3).floor(),
        random: _game.random,
      ),
    );
    _game.sounds.listen(
      (final event) {
        print(event);
        _projectSoundManager.handleEvent(event);
      },
      onDone: () => print('Sound manager shut down.'),
      onError: (final dynamic e, final dynamic s) {
        print('*** SOUND ERROR ***');
        print(e);
        print(s);
      },
    );
  }

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
          file: File(filename),
          game: _game,
        );
        _projectSoundManager.soundsDirectory = projectContext.directory.path;
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
      appName: path.basename(file.parent.path),
    );
    await AppPreferences(lastLoadedFilename: result).save();
    _projectSoundManager.soundsDirectory = file.parent.path;
    final projectContext = ProjectContext(
      project: project,
      file: file,
      game: _game,
    )..save();
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
      return showMessage(
        context: context,
        message: 'Path is `null`.',
      );
    }
    final file = File(path);
    if (!file.existsSync()) {
      return showMessage(
        context: context,
        message: 'File does not exist: $path.',
      );
    }
    _projectSoundManager.soundsDirectory = file.parent.path;
    final projectContext = ProjectContext.fromFile(
      file: file,
      game: _game,
    );
    await pushWidget(
      context: context,
      builder: (final context) => ProjectContextScreen(
        projectContext: projectContext,
      ),
    );
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _audioContext.destroy();
    _synthizer.shutdown();
  }
}
