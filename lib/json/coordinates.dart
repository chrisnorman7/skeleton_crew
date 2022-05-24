import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart';

/// Coordinates for something.
@JsonSerializable()
class Coordinates {
  /// Create an instance.
  Coordinates(this.x, this.y, this.z);

  /// Create an instance from a JSON object.
  factory Coordinates.fromJson(final Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);

  /// The x coordinate.
  double x;

  /// The y coordinate.
  double y;

  /// The z coordinate.
  double z;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}
