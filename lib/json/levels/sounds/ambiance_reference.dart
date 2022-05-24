import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/sound.dart';

import '../../coordinates.dart';
import 'sound_reference.dart';

part 'ambiance_reference.g.dart';

/// A reference to an [Ambiance].
@JsonSerializable()
class AmbianceReference {
  /// Create an instance.
  AmbianceReference({
    required this.id,
    required this.sound,
    this.coordinates,
  });

  /// Create an instance from a JSON object.
  factory AmbianceReference.fromJson(final Map<String, dynamic> json) =>
      _$AmbianceReferenceFromJson(json);

  /// The ID for this ambiance.
  final String id;

  /// The sound to play.
  final SoundReference sound;

  /// The coordinates for this ambiance.
  Coordinates? coordinates;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$AmbianceReferenceToJson(this);
}
