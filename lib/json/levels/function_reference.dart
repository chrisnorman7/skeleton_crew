import 'package:json_annotation/json_annotation.dart';

part 'function_reference.g.dart';

/// A reference to a function which should be automatically generated.
@JsonSerializable()
class FunctionReference {
  /// Create an instance.
  FunctionReference({
    required this.name,
    this.comment = 'TODO(Someone): Enter a sensible comment.',
  });

  /// Create an instance from a JSON object.
  factory FunctionReference.fromJson(final Map<String, dynamic> json) =>
      _$FunctionReferenceFromJson(json);

  /// The name of the function.
  String name;

  /// The comment for the function.
  String comment;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$FunctionReferenceToJson(this);
}
