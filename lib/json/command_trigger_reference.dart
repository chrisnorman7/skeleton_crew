import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/ziggurat.dart';

part 'command_trigger_reference.g.dart';

/// A reference to a [commandTrigger].
@JsonSerializable()
class CommandTriggerReference {
  /// Create an instance.
  CommandTriggerReference({
    required this.id,
    required this.variableName,
    required this.commandTrigger,
    this.comment,
  });

  /// Create an instance from a JSON object.
  factory CommandTriggerReference.fromJson(final Map<String, dynamic> json) =>
      _$CommandTriggerReferenceFromJson(json);

  /// The ID to use.
  final String id;

  /// The variable name to use.
  String variableName;

  /// The comment to use.
  ///
  /// If this value is `null`, then the `description` from the [commandTrigger]
  /// will be used.
  String? comment;

  /// The command trigger this reference references.
  CommandTrigger commandTrigger;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$CommandTriggerReferenceToJson(this);
}
