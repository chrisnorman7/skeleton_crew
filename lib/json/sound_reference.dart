import 'package:json_annotation/json_annotation.dart';

part 'sound_reference.g.dart';

/// A reference to a sound.
@JsonSerializable()
class SoundReference {
  /// Create an instance.
  SoundReference({
    required this.assetStoreId,
    required this.assetReferenceId,
    this.gain = 0.7,
  });

  /// Create an instance from a JSON object.
  factory SoundReference.fromJson(final Map<String, dynamic> json) =>
      _$SoundReferenceFromJson(json);

  /// The ID of the asset store which provides [assetReferenceId].
  String assetStoreId;

  /// The ID of the asset reference in the store with the given [assetStoreId].
  String assetReferenceId;

  /// The gain for this sound.
  double gain;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$SoundReferenceToJson(this);
}
