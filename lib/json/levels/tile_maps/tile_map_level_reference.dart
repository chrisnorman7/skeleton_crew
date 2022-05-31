import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/levels.dart';

import '../../../constants.dart';
import '../../../src/generated_code.dart';
import '../../../src/project_context.dart';
import '../../coordinates.dart';
import '../functions/function_reference.dart';
import '../level_command_reference.dart';
import '../level_reference.dart';
import '../sounds/ambiance_reference.dart';
import '../sounds/sound_reference.dart';
import 'tile_map_reference.dart';

part 'tile_map_level_reference.g.dart';

/// A class that can be used to generate a [TileMapLevel] instance.
@JsonSerializable()
class TileMapLevelReference extends LevelReference {
  /// Create an instance.
  TileMapLevelReference({
    required super.id,
    required this.tileMapId,
    super.title = 'Untitled Map Level',
    super.className = 'CustomMapLevel',
    super.comment = 'A new map level.',
    super.ambiances,
    super.commands,
    super.functions,
    super.music,
    final Coordinates? initialCoordinates,
    this.initialHeading = 0,
  }) : initialCoordinates = initialCoordinates ??
            Coordinates(
              0,
              0,
              0,
            );

  /// Create an instance from a JSON object.
  factory TileMapLevelReference.fromJson(final Map<String, dynamic> json) =>
      _$TileMapLevelReferenceFromJson(json);

  /// The ID of the [TileMapReference] that this level will work with.
  String tileMapId;

  /// The initial coordinates.
  final Coordinates initialCoordinates;

  /// The initial heading.
  int initialHeading;

  /// Convert an instance to JSON.
  @override
  Map<String, dynamic> toJson() => _$TileMapLevelReferenceToJson(this);

  /// Get code for this instance.
  @override
  GeneratedCode getCode(final ProjectContext projectContext) {
    final imports = {
      'dart:math',
      'package:ziggurat/levels.dart',
      'package:ziggurat/sound.dart',
      'package:ziggurat/ziggurat.dart',
      flagsFilename,
      tileMapsFilename,
    };
    final project = projectContext.project;
    final tileMap = project.getTileMap(tileMapId);
    final tileClassName = '${className}Tile';
    final levelClassName = '${className}Base';
    final x = initialCoordinates.x;
    final y = initialCoordinates.y;
    final stringBuffer = StringBuffer()
      ..writeln('/// The type of tile returned by the [$levelClassName] class.')
      ..writeln('class $tileClassName extends Tile {')
      ..writeln('/// Create an instance.')
      ..writeln('const $tileClassName({')
      ..writeln('required super.x, required super.y, required super.value,')
      ..writeln('});');
    for (final flag in project.tileMapFlags) {
      stringBuffer
        ..writeln('/// ${flag.name}')
        ..writeln('bool get ${flag.variableName} =>')
        ..writeln('value & ${flag.variableName}Flag != 0;');
    }
    stringBuffer
      ..writeln('}')
      ..writeln('/// $comment')
      ..writeln(
        'abstract class $levelClassName extends TileMapLevel<$tileClassName> {',
      )
      ..writeln('/// Create an instance.')
      ..writeln('$levelClassName({')
      ..writeln('required super.game,')
      ..writeln('super.initialCoordinates = const Point($x, $y),')
      ..writeln('super.initialHeading = $initialHeading,')
      ..writeln('})')
      ..writeln(': super(')
      ..writeln('tileMap: TileMap.fromJson(')
      ..writeln('${tileMap.variableName}.toJson(),')
      ..writeln('),')
      ..writeln('makeTile: (final point, final value) =>')
      ..writeln(
        '$tileClassName(x: point.x, y: point.y, value: value,),',
      );
    final musicAmbiancesCode = getMusicAmbianceCode(projectContext);
    if (musicAmbiancesCode != null) {
      imports.addAll(musicAmbiancesCode.imports);
      stringBuffer.writeln(musicAmbiancesCode.code);
    }
    stringBuffer.writeln(')');
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
