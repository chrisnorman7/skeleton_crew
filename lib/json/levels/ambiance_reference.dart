import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/sound.dart';

import '../sound_reference.dart';

part 'ambiance_reference.g.dart';

/// A reference to an [Ambiance].
@JsonSerializable()
class AmbianceReference {
  /// Create an instance.
  AmbianceReference({
    required this.sound,
    this.x,
    this.y,
  });

  /// Create an instance from a JSON object.
  factory AmbianceReference.fromJson(final Map<String, dynamic> json) =>
      _$AmbianceReferenceFromJson(json);

  /// The sound to play.
  final SoundReference sound;

  /// The x coordinate.
  double? x;

  /// The y coordinate.
  double? y;

  /// Get the coordinates for this instance.
  Point<double>? get coordinates {
    final dx = x;
    final dy = y;
    if (dx != null && dy != null) {
      return Point(dx, dy);
    }
    return null;
  }

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$AmbianceReferenceToJson(this);
}
