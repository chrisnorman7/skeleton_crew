import 'package:json_annotation/json_annotation.dart';

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
}
