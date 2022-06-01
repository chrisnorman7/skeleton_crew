import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/ziggurat.dart';

import 'levels/sounds/sound_reference.dart';

part 'message_reference.g.dart';

/// A reference to a [Message] instance.
@JsonSerializable()
class MessageReference {
  /// Create an instance.
  MessageReference({
    this.text,
    this.soundReference,
  });

  /// Create an instance from a JSON object.
  factory MessageReference.fromJson(final Map<String, dynamic> json) =>
      _$MessageReferenceFromJson(json);

  /// The text of this message.
  String? text;

  /// The sound that will play for this message.
  SoundReference? soundReference;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MessageReferenceToJson(this);
}
