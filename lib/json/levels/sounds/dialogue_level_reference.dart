import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/levels.dart';

import '../../message_reference.dart';
import '../level_reference.dart';
import 'sound_reference.dart';

part 'dialogue_level_reference.g.dart';

/// A level that represents a [DialogueLevel] instance.
@JsonSerializable()
class DialogueLevelReference extends LevelReference {
  /// Create an instance.
  DialogueLevelReference({
    required super.id,
    required super.title,
    super.className = 'CustomDialogueLevelBase',
    super.ambiances,
    super.commands,
    super.comment = 'A dialogue level that needs a comment.',
    super.functions,
    super.music,
    final List<MessageReference>? messages,
  }) : messages = messages ?? [];

  /// Create an instance from a JSON object.
  factory DialogueLevelReference.fromJson(final Map<String, dynamic> json) =>
      _$DialogueLevelReferenceFromJson(json);

  /// The messages for this level.
  final List<MessageReference> messages;

  /// Convert an instance to JSON.
  @override
  Map<String, dynamic> toJson() => _$DialogueLevelReferenceToJson(this);
}
