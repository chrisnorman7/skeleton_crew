import 'package:json_annotation/json_annotation.dart';

import '../../../src/generated_code.dart';

part 'tile_flag.g.dart';

/// A flag for use with tile maps.
@JsonSerializable()
class TileMapFlag {
  /// Create an instance.
  TileMapFlag({
    required this.id,
    required this.name,
    required this.variableName,
  });

  /// Create an instance from a JSON object.
  factory TileMapFlag.fromJson(final Map<String, dynamic> json) =>
      _$TileMapFlagFromJson(json);

  /// The ID of this flag.
  final String id;

  /// The name of this flag.
  ///
  /// This value will also be used as a comment.
  String name;

  /// The variable name to use.
  String variableName;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$TileMapFlagToJson(this);

  /// Get the code for this instance.
  GeneratedCode getCode(final int value) =>
      GeneratedCode(code: '/// $name\nconst $variableName = $value;');
}
