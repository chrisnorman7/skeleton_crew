import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../json/asset_stores/asset_store_reference.dart';
import '../json/asset_stores/pretend_asset_reference.dart';
import '../json/project.dart';
import '../util.dart';
import 'generated_code.dart';

const _jsonEncoder = JsonEncoder.withIndent('  ');

/// A reference to a project.
class ProjectContext {
  /// Create an instance.
  const ProjectContext({
    required this.project,
    required this.file,
    required this.game,
  });

  /// Load a project from the given [file].
  ProjectContext.fromFile({required this.file, required this.game})
      : project = Project.fromJson(
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
        );

  /// The project that has been loaded.
  final Project project;

  /// The file where [project] resides.
  final File file;

  /// The directory where [file] lives.
  Directory get directory => file.parent;

  /// The game to use.
  final Game game;

  /// Save the [project] to its [file].
  void save() {
    final json = project.toJson();
    final data = _jsonEncoder.convert(json);
    file.writeAsStringSync(data);
  }

  /// Delete the given [asset] from the given [assetStoreReference].
  void deleteAssetReferenceReference({
    required final AssetStoreReference assetStoreReference,
    required final PretendAssetReference asset,
  }) {
    assetStoreReference.assets.removeWhere(
      (final element) => element.id == asset.id,
    );
    save();
    switch (asset.assetType) {
      case AssetType.file:
        final file = File(asset.name);
        if (file.existsSync()) {
          file.deleteSync(recursive: true);
        }
        break;
      case AssetType.collection:
        final directory = Directory(asset.name);
        if (directory.existsSync()) {
          directory.deleteSync(recursive: true);
        }
        break;
    }
  }

  /// Get the generated header for use with the [build] method and the methods
  /// it calls.
  String get generatedHeader {
    final now = DateTime.now();
    return '/// Autogenerated on $now.';
  }

  /// Write the flags.
  void writeFlags() {
    final imports = <String>{};
    final libraryName = path.basenameWithoutExtension(flagsFilename);
    final stringBuffer = StringBuffer()
      ..writeln(generatedHeader)
      ..writeln('/// Tile map flags.')
      ..writeln('library $libraryName;');
    var value = 1;
    for (final flags in project.tileMapFlags) {
      final code = flags.getCode(value);
      imports.addAll(code.imports);
      stringBuffer.writeln(code.code);
      value *= 2;
    }
    final generatedCode =
        GeneratedCode(code: stringBuffer.toString(), imports: imports);
    final file = File(
      path.join(directory.path, project.outputDirectory, flagsFilename),
    );
    final sortedImports = generatedCode.getImports();
    final code = dartFormatter.format('$sortedImports\n${generatedCode.code}');
    file.writeAsStringSync(code);
  }

  /// Write the custom game class.
  void writeGame() {
    final className = project.gameClassName;
    final stringBuffer = StringBuffer()
      ..writeln(generatedHeader)
      ..writeln('/// Provides the [$className] class.')
      ..writeln("import 'dart:io';")
      ..writeln("import 'package:dart_sdl/dart_sdl.dart';")
      ..writeln("import 'package:ziggurat/ziggurat.dart';")
      ..writeln("import '$commandTriggersFilename';")
      ..writeln('/// ${project.gameClassComment}')
      ..writeln('abstract class $className extends Game {')
      ..writeln('/// Create an instance.')
      ..writeln('$className({required this.sdl,}):')
      ..writeln(' orgName = ${getQuotedString(project.orgName)},')
      ..writeln('appName = ${getQuotedString(project.appName)},')
      ..writeln('super(${getQuotedString(project.title)},')
      ..writeln('triggerMap: const TriggerMap([');
    for (final commandTriggerReference in project.commandTriggers) {
      final comment = commandTriggerReference.comment;
      final variableName = commandTriggerReference.variableName;
      stringBuffer
        ..writeln('/// $comment')
        ..writeln('$variableName,');
    }
    stringBuffer
      ..writeln('],),);')
      ..writeln('/// Organisation name.')
      ..writeln('final String orgName;')
      ..writeln('/// Application name.')
      ..writeln('final String appName;')
      ..writeln('/// The SDL instance to use.')
      ..writeln('final Sdl sdl;')
      ..writeln('/// Get the preferences directory for this game.')
      ..writeln('Directory get preferencesDirectory => Directory(')
      ..writeln('sdl.getPrefPath(orgName, appName));')
      ..writeln('}');
    final code = dartFormatter.format(stringBuffer.toString());
    File(path.join(project.outputDirectory, gameFilename))
        .writeAsStringSync(code);
  }

  /// Write all levels.
  void writeLevels() {
    final imports = <String>{};
    final stringBuffer = StringBuffer();
    for (final level in project.levels) {
      final code = level.getCode(this);
      imports.addAll(code.imports);
      stringBuffer.writeln(code.code);
    }
    final generatedCode = GeneratedCode(
      code: stringBuffer.toString(),
      imports: imports,
    );
    final codeBuffer = StringBuffer()
      ..writeln(generatedHeader)
      ..writeln('/// Levels.')
      ..writeln(generatedCode.getImports())
      ..write(generatedCode.code);
    final levelPath = path.join(project.outputDirectory, levelFilename);
    Clipboard.setData(ClipboardData(text: codeBuffer.toString()));
    final code = dartFormatter.format(
      codeBuffer.toString(),
      uri: levelPath,
    );
    File(levelPath).writeAsStringSync(code);
  }

  /// Write all menus.
  void writeMenus() {
    final imports = <String>{};
    final stringBuffer = StringBuffer();
    for (final menu in project.menus) {
      final code = menu.getCode(this);
      imports.addAll(code.imports);
      stringBuffer.writeln(code.code);
    }
    final generatedCode = GeneratedCode(
      code: stringBuffer.toString(),
      imports: imports,
    );
    final codeBuffer = StringBuffer()
      ..writeln(generatedHeader)
      ..writeln('// ignore_for_file: avoid_redundant_argument_values')
      ..writeln('/// Menus.')
      ..writeln(generatedCode.getImports())
      ..write(generatedCode.code);
    final menuPath = path.join(project.outputDirectory, menuFilename);
    final code = dartFormatter.format(
      codeBuffer.toString(),
      uri: menuPath,
    );
    File(menuPath).writeAsStringSync(code);
  }

  /// Write the given [assetStoreReference].
  void writeAssetStore(final AssetStoreReference assetStoreReference) {
    final storeCode = assetStoreReference.getCode(this);
    final stringBuffer = StringBuffer()
      ..writeln(generatedHeader)
      ..writeln(storeCode.getImports())
      ..writeln(storeCode.code);
    final code = dartFormatter.format(stringBuffer.toString());
    File(
      path.join(
        project.outputDirectory,
        assetStoresDirectory,
        assetStoreReference.dartFilename,
      ),
    ).writeAsStringSync(code);
  }

  /// Write asset stores.
  void writeAssetStores() {
    final directory = Directory(
      path.join(project.outputDirectory, assetStoresDirectory),
    );
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    project.assetStores.forEach(writeAssetStore);
  }

  /// Write command triggers.
  void writeCommandTriggers() {
    final imports = <String>{};
    final stringBuffer = StringBuffer();
    final commandTriggers = project.commandTriggers;
    for (final reference in commandTriggers) {
      final commandTriggerCode = reference.getCode(this);
      imports.addAll(commandTriggerCode.imports);
      stringBuffer.writeln(commandTriggerCode.code);
    }
    final generatedCode = GeneratedCode(
      code: stringBuffer.toString(),
      imports: imports,
    );
    final code = dartFormatter.format(
      '$generatedHeader\n/// Command triggers.\n${generatedCode.getImports()}\n${generatedCode.code}',
    );
    File(
      path.join(
        file.parent.path,
        project.outputDirectory,
        commandTriggersFilename,
      ),
    ).writeAsStringSync(code);
  }

  /// Build the dart for [project].
  void build() {
    final directory = Directory(project.outputDirectory);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    writeAssetStores();
    final commandTriggers = project.commandTriggers;
    if (commandTriggers.isNotEmpty) {
      writeCommandTriggers();
    }
    final menus = project.menus;
    if (menus.isNotEmpty) {
      writeMenus();
    }
    final levels = project.levels;
    if (levels.isNotEmpty) {
      writeLevels();
    }
    writeGame();
    writeFlags();
  }
}
