import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/ziggurat.dart';
import 'package:ziggurat_sounds/ziggurat_sounds.dart';

part 'pretend_asset_reference.g.dart';

/// A pretend [AssetReferenceReference].
@JsonSerializable()
class PretendAssetReference {
  /// Create an instance.
  PretendAssetReference({
    required this.id,
    required this.variableName,
    required this.comment,
    required this.assetType,
    required this.name,
  });

  /// Create an instance from a JSON object.
  factory PretendAssetReference.fromJson(final Map<String, dynamic> json) =>
      _$PretendAssetReferenceFromJson(json);

  /// The ID of this reference.
  final String id;

  /// The variable name for this reference.
  String variableName;

  /// The comment for this reference.
  String comment;

  /// The type of this reference.
  final AssetType assetType;

  /// The name of the encrypted file that holds the data of this reference.
  final String name;

  /// Return an asset reference reference for this instance.
  AssetReferenceReference get assetReferenceReference =>
      AssetReferenceReference(
        variableName: variableName,
        reference: AssetReference(name, assetType),
        comment: comment,
      );

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$PretendAssetReferenceToJson(this);
}
