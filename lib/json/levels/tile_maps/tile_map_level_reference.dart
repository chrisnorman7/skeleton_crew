import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/levels.dart';

import '../../coordinates.dart';
import '../functions/function_reference.dart';
import '../level_command_reference.dart';
import '../level_reference.dart';
import '../sounds/ambiance_reference.dart';
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
    super.className = 'CustomMapLevelBase',
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
}
