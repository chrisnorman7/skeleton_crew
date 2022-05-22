import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/ziggurat.dart';
import 'package:ziggurat_sounds/ziggurat_sounds.dart';

part 'pretend_asset_reference.g.dart';

/// A pretend [AssetReferenceReference].
@JsonSerializable()
class PretendAssetReference {
  /// Create an instance.
  PretendAssetReference({
    required this.assetStoreId,
    required this.id,
    required this.variableName,
    required this.comment,
    required this.name,
    required this.assetType,
    required this.encryptionKey,
    this.isAudio = false,
  });

  /// Create an instance from a JSON object.
  factory PretendAssetReference.fromJson(final Map<String, dynamic> json) =>
      _$PretendAssetReferenceFromJson(json);

  /// The ID of the asset store this asset belongs to.
  final String assetStoreId;

  /// The ID of this reference.
  final String id;

  /// The variable name for this reference.
  String variableName;

  /// The comment for this reference.
  String comment;

  /// The name of the encrypted file that holds the data of this reference.
  final String name;

  /// The type of this reference.
  final AssetType assetType;

  /// The encryption key for this asset reference.
  final String? encryptionKey;

  /// Whether this asset is an audio asset.
  ///
  /// If it is, it will be played as such when viewed in the list of assets.
  bool isAudio;

  /// Return an asset reference reference for this instance.
  AssetReferenceReference get assetReferenceReference =>
      AssetReferenceReference(
        variableName: variableName,
        reference: AssetReference(
          name,
          assetType,
          encryptionKey: encryptionKey,
        ),
        comment: comment,
      );

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$PretendAssetReferenceToJson(this);
}
