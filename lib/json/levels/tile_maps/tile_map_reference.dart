import 'package:json_annotation/json_annotation.dart';

import '../../../constants.dart';
import '../../../src/generated_code.dart';
import '../../../src/project_context.dart';

part 'tile_map_reference.g.dart';

/// A reference to a tile map.
@JsonSerializable()
class TileMapReference {
  /// Create an instance.
  TileMapReference({
    required this.id,
    required this.name,
    required this.variableName,
    required this.tiles,
    this.width = 10,
    this.height = 10,
    final List<String>? defaultFlagIds,
  }) : defaultFlagIds = defaultFlagIds ?? [];

  /// Create an instance from a JSON object.
  factory TileMapReference.fromJson(final Map<String, dynamic> json) =>
      _$TileMapReferenceFromJson(json);

  /// The ID of this map.
  final String id;

  /// The name of this map.
  ///
  /// This value will also be used as the comment.
  String name;

  /// The variable name for this map.
  String variableName;

  /// The width of this map.
  int width;

  /// The height of this map.
  int height;

  /// The default flags for tiles on this map.
  List<String> defaultFlagIds;

  /// The populated tiles.
  final Map<int, Map<int, List<String>>> tiles;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$TileMapReferenceToJson(this);

  /// Get the code for this instance.
  GeneratedCode getCode(final ProjectContext projectContext) {
    final flags = projectContext.project.tileMapFlags;
    final flagValues = <String, int>{};
    var value = 1;
    for (final flag in flags) {
      flagValues[flag.id] = value;
      value *= 2;
    }

    String getFlags(final Iterable<String> tileFlags) {
      final flags = projectContext.project.getFlags(tileFlags);
      return flags
          .map(
            (final e) => e.variableName,
          )
          .join(' | ');
    }

    final imports = {
      'package:ziggurat/ziggurat.dart',
      flagsFilename,
    };
    final stringBuffer = StringBuffer()
      ..writeln('/// $name')
      ..writeln('const $variableName = TileMap(')
      ..writeln('width: $width,')
      ..writeln('height: $height,')
      ..writeln('defaultFlags: ${getFlags(defaultFlagIds)},');
    final tilesStringBuffer = StringBuffer()..writeln('tiles: {');
    var numberOfTiles = 0;
    for (final xEntry in tiles.entries.where(
      (final element) => element.key < width,
    )) {
      tilesStringBuffer.writeln('${xEntry.key}: {');
      for (final yEntry in xEntry.value.entries.where(
        (final element) => element.key < height,
      )) {
        numberOfTiles++;
        final value = getFlags(yEntry.value);
        tilesStringBuffer.writeln('${yEntry.key}: $value,');
      }
      tilesStringBuffer.writeln('},');
    }
    tilesStringBuffer.writeln('},');
    if (numberOfTiles > 0) {
      stringBuffer.writeln(tilesStringBuffer);
    }
    stringBuffer.writeln(');');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
