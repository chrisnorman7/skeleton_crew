import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat_sounds/ziggurat_sounds.dart';

part 'asset_store_reference.g.dart';

/// A reference to an [assetStore].
@JsonSerializable()
class AssetStoreReference {
  /// Create an instance.
  AssetStoreReference({
    required this.id,
    required this.name,
    required this.assetStore,
  });

  /// Create an instance from a JSON object.
  factory AssetStoreReference.fromJson(final Map<String, dynamic> json) =>
      _$AssetStoreReferenceFromJson(json);

  /// The ID of this asset store.
  final String id;

  /// The name of this asset store.
  String name;

  /// The asset store to reference.
  AssetStore assetStore;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$AssetStoreReferenceToJson(this);
}
