import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../constants.dart';
import '../json/project.dart';

const _jsonEncoder = JsonEncoder.withIndent('  ');

/// A reference to a project.
class ProjectContext {
  /// Create an instance.
  const ProjectContext({
    required this.project,
    required this.file,
  });

  /// Load a project from the given [file].
  ProjectContext.fromFile(this.file)
      : project = Project.fromJson(
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
        );

  /// The project that has been loaded.
  final Project project;

  /// The file where [project] resides.
  final File file;

  /// Save the [project] to its [file].
  void save() {
    final json = project.toJson();
    final data = _jsonEncoder.convert(json);
    file.writeAsStringSync(data);
  }

  /// Get the generated header for use with the [build] method and the methods
  /// it calls.
  String get generatedHeader {
    final now = DateTime.now();
    return '/// Autogenerated on $now.';
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
    final triggerFile = File(
      path.join(
        file.parent.path,
        project.outputDirectory,
        project.commandTriggersFilename,
      ),
    );
    if (!triggerFile.parent.existsSync()) {
      triggerFile.parent.createSync(recursive: true);
    }
    triggerFile.writeAsStringSync(code);
  }

  /// Build the dart for [project].
  void build() {
    final commandTriggers = project.commandTriggers;
    if (commandTriggers.isNotEmpty) {
      writeCommandTriggers();
    }
  }
}
