import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../json/asset_stores/asset_store_reference.dart';
import '../json/asset_stores/pretend_asset_reference.dart';
import '../json/levels/function_reference.dart';
import '../json/project.dart';

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

  /// Write all menus.
  void writeMenus() {
    final imports = <String>{};
    final stringBuffer = StringBuffer();
    for (final menu in project.menus) {
      final titleQuote = menu.title.contains("'") ? '"' : "'";
      stringBuffer
        ..writeln('/// ${menu.comment}')
        ..writeln('abstract class ${menu.className} extends Menu {')
        ..writeln('/// Create an instance.')
        ..writeln('${menu.className}({')
        ..writeln('required super.game,')
        ..writeln('}) : super(')
        ..writeln('title: const Message(')
        ..writeln('text: $titleQuote${menu.title}$titleQuote,')
        ..writeln('),')
        ..writeln('items: [],')
        ..writeln('upScanCode: ${menu.upScanCode},')
        ..writeln('upButton: ${menu.upButton},')
        ..writeln('downScanCode : ${menu.downScanCode},')
        ..writeln('downButton: ${menu.downButton},')
        ..writeln('activateScanCode: ${menu.activateScanCode},')
        ..writeln('activateButton: ${menu.activateButton},')
        ..writeln('cancelScanCode: ${menu.cancelScanCode},')
        ..writeln('cancelButton: ${menu.cancelButton},')
        ..writeln('movementAxis: ${menu.movementAxis},')
        ..writeln('activateAxis: ${menu.activateAxis},')
        ..writeln('cancelAxis: ${menu.cancelAxis},')
        ..writeln('controllerMovementSpeed: ${menu.controllerMovementSpeed},')
        ..writeln(
          'controllerAxisSensitivity: ${menu.controllerAxisSensitivity},',
        )
        ..writeln('searchEnabled: ${menu.searchEnabled},')
        ..writeln('searchInterval: ${menu.searchInterval},');
      final music = menu.music;
      if (music != null) {
        final assetStore = project.getAssetStore(music.assetStoreId);
        imports.add(assetStore.dartFilename);
        final assetReference =
            assetStore.getAssetReference(music.assetReferenceId);
        stringBuffer
          ..writeln('music: Music(')
          ..writeln('sound: ${assetReference.variableName},')
          ..writeln('gain: ${music.gain},')
          ..writeln('),');
      }
      stringBuffer
        ..writeln(') {')
        ..writeln('menuItems.addAll([');
      final functionReferences = <FunctionReference>{};
      for (final item in menu.menuItems) {
        final title = item.title;
        stringBuffer
          ..writeln('MenuItem(')
          ..writeln('const Message(');
        if (title != null) {
          final titleQuote = title.contains("'") ? '"' : "'";
          stringBuffer.writeln('text: $titleQuote$title$titleQuote,');
        }
        final soundReference = item.soundReference;
        if (soundReference != null) {
          final assetStore = project.getAssetStore(soundReference.assetStoreId);
          imports.add(assetStore.dartFilename);
          final assetReference =
              assetStore.getAssetReference(soundReference.assetReferenceId);
          stringBuffer
            ..writeln('gain: ${soundReference.gain},')
            ..writeln('sound: ${assetReference.variableName},')
            ..writeln('keepAlive: true,');
        }
        stringBuffer.writeln('),');
        final function = item.functionReference;
        if (function == null) {
          stringBuffer.writeln('menuItemLabel,');
        } else {
          functionReferences.add(function);
          stringBuffer.writeln('Button(${function.name}),');
        }
        stringBuffer.writeln('),');
      }
      stringBuffer.writeln('],);}');
      for (final function in functionReferences) {
        stringBuffer
          ..writeln('/// ${function.comment}')
          ..writeln('void ${function.name}();');
      }
      stringBuffer.writeln('}');
    }
    final codeBuffer = StringBuffer()
      ..writeln(generatedHeader)
      ..writeln('// ignore_for_file: avoid_redundant_argument_values')
      ..writeln("import 'package:dart_sdl/dart_sdl.dart';")
      ..writeln("import 'package:ziggurat/menus.dart';")
      ..writeln("import 'package:ziggurat/ziggurat.dart';");
    for (final importName in imports) {
      codeBuffer.writeln("import '$assetStoresDirectory/$importName';");
    }
    codeBuffer.write(stringBuffer);
    final code = dartFormatter.format(codeBuffer.toString());
    File(path.join(project.outputDirectory, menuFilename))
        .writeAsStringSync(code);
  }

  /// Write the given [assetStoreReference].
  void writeAssetStore(final AssetStoreReference assetStoreReference) {
    final stringBuffer = StringBuffer()
      ..writeln(generatedHeader)
      ..writeln('/// ${assetStoreReference.comment}')
      ..writeln("import 'package:ziggurat/ziggurat.dart';");
    for (final asset in assetStoreReference.assets) {
      stringBuffer
        ..writeln('/// ${asset.comment}')
        ..writeln('const ${asset.variableName} = AssetReference(')
        ..writeln("  '${asset.name}',")
        ..writeln('  ${asset.assetType},')
        ..writeln("  encryptionKey: '${asset.encryptionKey}',")
        ..writeln(');');
    }
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
    final stringBuffer = StringBuffer()
      ..writeln(generatedHeader)
      ..writeln("import 'package:dart_sdl/dart_sdl.dart';")
      ..writeln("import 'package:ziggurat/ziggurat.dart';");
    final commandTriggers = project.commandTriggers;
    for (final reference in commandTriggers) {
      final commandTrigger = reference.commandTrigger;
      final nameQuote = commandTrigger.name.contains("'") ? '"' : "'";
      final descriptionQuote =
          commandTrigger.description.contains("'") ? '"' : "'";
      final button = commandTrigger.button;
      final keyboardKey = commandTrigger.keyboardKey;
      stringBuffer
        ..writeln('/// ${reference.comment ?? commandTrigger.description}')
        ..writeln('const ${reference.variableName} = CommandTrigger(')
        ..writeln('name: $nameQuote${commandTrigger.name}$nameQuote,')
        ..writeln(
          'description: $descriptionQuote${commandTrigger.description}'
          '$descriptionQuote,',
        );
      if (button != null) {
        stringBuffer.writeln('button: $button,');
      }
      if (keyboardKey != null) {
        stringBuffer.writeln(
          'keyboardKey: CommandKeyboardKey(${keyboardKey.scanCode},',
        );
        if (keyboardKey.altKey) {
          stringBuffer.writeln('altKey: ${keyboardKey.altKey},');
        }
        if (keyboardKey.controlKey) {
          stringBuffer.writeln('controlKey: ${keyboardKey.controlKey},');
        }
        if (keyboardKey.shiftKey) {
          stringBuffer.writeln('shiftKey: ${keyboardKey.shiftKey},');
        }
        stringBuffer.writeln('),');
      }
      stringBuffer.writeln(');');
    }
    final code = dartFormatter.format(stringBuffer.toString());
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
  }
}
