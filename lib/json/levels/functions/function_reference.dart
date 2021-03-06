import 'package:json_annotation/json_annotation.dart';

part 'function_reference.g.dart';

/// A reference to a function which should be automatically generated.
@JsonSerializable()
class FunctionReference {
  /// Create an instance.
  FunctionReference({
    required this.id,
    required this.name,
    required this.comment,
  });

  /// Create an instance from a JSON object.
  factory FunctionReference.fromJson(final Map<String, dynamic> json) =>
      _$FunctionReferenceFromJson(json);

  /// The ID of this function.
  final String id;

  /// The name of the function.
  String name;

  /// The comment for the function.
  String comment;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$FunctionReferenceToJson(this);

  /// Get the header for this function.
  String get header => '/// $comment\nvoid $name();';
}
