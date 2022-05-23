import 'package:json_annotation/json_annotation.dart';

import 'asset_stores/asset_store_reference.dart';
import 'asset_stores/pretend_asset_reference.dart';
import 'command_trigger_reference.dart';
import 'levels/menus/menu_reference.dart';
import 'levels/sounds/sound_reference.dart';

part 'project.g.dart';

/// The type definition for  a list of commands.
typedef CommandTriggers = List<CommandTriggerReference>;

/// The type definition for a list of asset stores.
typedef AssetStores = List<AssetStoreReference>;

/// The type definition for a list of menus.
typedef Menus = List<MenuReference>;

/// The top-level project class.
@JsonSerializable()
class Project {
  /// Create an instance.
  Project({
    required this.title,
    final CommandTriggers? commandTriggers,
    final AssetStores? assetStores,
    this.orgName = 'com.example',
    this.appName = 'untitled_game',
    this.version = '0.0.0',
    this.outputDirectory = 'lib/generated',
    final Menus? menus,
  })  : commandTriggers = commandTriggers ?? [],
        assetStores = assetStores ?? [],
        menus = menus ?? [];

  /// Create an instance from a JSON object.
  factory Project.fromJson(final Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// The name of the project.
  ///
  /// This will be used as the title for the game.
  String title;

  /// The org name for this game.
  String orgName;

  /// The app name.
  String appName;

  /// The version string for the game.
  String version;

  /// The output directory for files.
  String outputDirectory;

  /// The command triggers to use.
  final CommandTriggers commandTriggers;

  /// The asset stores that have been defined.
  final AssetStores assetStores;

  /// Get the first asset store with the given [id].
  AssetStoreReference getAssetStore(final String id) =>
      assetStores.firstWhere((final element) => element.id == id);

  /// Get an asset reference from the given [soundReference].
  PretendAssetReference getPretendAssetReference(
    final SoundReference soundReference,
  ) =>
      getAssetStore(soundReference.assetStoreId)
          .getAssetReference(soundReference.assetReferenceId);

  /// The menus that have been defined.
  final Menus menus;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
