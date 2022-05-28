import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/levels.dart';

import '../../src/generated_code.dart';
import '../../src/project_context.dart';
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
  })  : ambiances = ambiances ?? [],
        commands = commands ?? [];

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
        ..writeln(');');
    } else {
      stringBuffer.writeln(';');
    }
    stringBuffer.writeln('}');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
