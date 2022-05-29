import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/levels.dart';

import '../../src/generated_code.dart';
import '../../src/project_context.dart';
import 'functions/function_reference.dart';
import 'level_command_reference.dart';
import 'sounds/ambiance_reference.dart';
import 'sounds/sound_reference.dart';

part 'level_reference.g.dart';

/// A reference to a [Level].
@JsonSerializable()
class LevelReference {
  /// Create an instance.
  LevelReference({
    required this.id,
    required this.title,
    this.className = 'CustomLevel',
    this.comment = 'A level which must be extended.',
    this.music,
    final List<AmbianceReference>? ambiances,
    final List<LevelCommandReference>? commands,
    final List<FunctionReference>? functions,
  })  : ambiances = ambiances ?? [],
        commands = commands ?? [],
        functions = functions ?? [];

  /// Create an instance from a JSON object.
  factory LevelReference.fromJson(final Map<String, dynamic> json) =>
      _$LevelReferenceFromJson(json);

  /// The ID of this menu.
  final String id;

  /// The title of this level.
  String title;

  /// The class name for this level.
  String className;

  /// The comment for this level.
  String comment;

  /// Music for the level.
  SoundReference? music;

  /// Ambiances for the level.
  final List<AmbianceReference> ambiances;

  /// The commands that are registered for this instance.
  final List<LevelCommandReference> commands;

  /// The functions that are bound to this level.
  final List<FunctionReference> functions;

  /// Get the function with the given [id].
  FunctionReference getFunctionReference(final String id) =>
      functions.firstWhere((final element) => element.id == id);

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$LevelReferenceToJson(this);

  /// Get the code that will write [music] and [ambiances].
  GeneratedCode? getMusicAmbianceCode(final ProjectContext projectContext) {
    final musicReference = music;
    final ambianceReferences = ambiances;
    if (musicReference != null || ambianceReferences.isNotEmpty) {
      final imports = <String>{};
      final stringBuffer = StringBuffer();
      if (musicReference != null) {
        final code = musicReference.getCode(projectContext);
        imports.addAll(code.imports);
        stringBuffer
          ..writeln('music: const Music(')
          ..writeln('sound: ${code.code},')
          ..writeln('gain: ${musicReference.gain},')
          ..writeln('),');
      }
      if (ambianceReferences.isNotEmpty) {
        stringBuffer.writeln('ambiances: [');
        for (final ambianceReference in ambianceReferences) {
          final code = ambianceReference.getCode(projectContext);
          imports.addAll(code.imports);
          stringBuffer.writeln('${code.code},');
        }
        stringBuffer.writeln('],');
      }
      return GeneratedCode(code: stringBuffer.toString(), imports: imports);
    }
    return null;
  }

  /// Get code for the created [commands].
  GeneratedCode? getCommandsCode(final ProjectContext projectContext) {
    final commandReferences = commands;
    if (commandReferences.isEmpty) {
      return null;
    }
    final imports = <String>{};
    final stringBuffer = StringBuffer();
    for (final command in commandReferences) {
      final code = command.getCode(projectContext, this);
      imports.addAll(code.imports);
      stringBuffer.writeln(code.code);
    }
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }

  /// Get function headers for this instance.
  @mustCallSuper
  GeneratedCode getFunctionHeaders(final ProjectContext projectContext) {
    final imports = <String>{};
    final stringBuffer = StringBuffer();
    for (final function in functions) {
      stringBuffer.writeln(function.header);
    }
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }

  /// Get code for this instance.
  GeneratedCode getCode(final ProjectContext projectContext) {
    final imports = <String>{
      'package:ziggurat/levels.dart',
      'package:ziggurat/sound.dart',
    };
    final stringBuffer = StringBuffer()
      ..writeln('/// $comment')
      ..writeln('abstract class $className extends Level {')
      ..writeln('/// Create an instance.')
      ..writeln('$className({')
      ..writeln('required super.game,')
      ..writeln('})');
    final musicAmbiancesCode = getMusicAmbianceCode(projectContext);
    if (musicAmbiancesCode != null) {
      imports.addAll(musicAmbiancesCode.imports);
      stringBuffer
        ..writeln(': super(')
        ..writeln(musicAmbiancesCode.code)
        ..writeln(')');
    }
    final commandsCode = getCommandsCode(projectContext);
    if (commandsCode == null) {
      stringBuffer.write(';');
    } else {
      imports.addAll(commandsCode.imports);
      stringBuffer
        ..writeln('{')
        ..writeln(commandsCode.code)
        ..writeln('}');
    }
    final functionHeadersCode = getFunctionHeaders(projectContext);
    imports.addAll(functionHeadersCode.imports);
    stringBuffer
      ..writeln(functionHeadersCode.code)
      ..writeln('}');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
