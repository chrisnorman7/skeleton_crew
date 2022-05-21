import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat_sounds/ziggurat_sounds.dart';

import '../constants.dart';
import 'pretend_asset_reference.dart';

part 'asset_store_reference.g.dart';

/// A reference to an [assetStore].
@JsonSerializable()
class AssetStoreReference {
  /// Create an instance.
  AssetStoreReference({
    required this.id,
    required this.name,
    required this.comment,
    required this.dartFilename,
    required this.assets,
  });

  /// Create an instance from a JSON object.
  factory AssetStoreReference.fromJson(final Map<String, dynamic> json) =>
      _$AssetStoreReferenceFromJson(json);

  /// The ID of this asset store.
  final String id;

  /// The name of this asset store.
  String name;

  /// The comment for this asset store.
  String comment;

  /// The dart filename for this asset store.
  String dartFilename;

  /// The assets this reference holds.
  final List<PretendAssetReference> assets;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$AssetStoreReferenceToJson(this);

  /// Get an asset store that represents this instance.
  AssetStore get assetStore => AssetStore(
        filename: dartFilename,
        destination: assetsDirectory,
        assets: assets
            .map<AssetReferenceReference>(
              (final e) => e.assetReferenceReference,
            )
            .toList(),
      );
}
