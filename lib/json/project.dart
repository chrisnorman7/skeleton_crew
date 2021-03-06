import 'package:json_annotation/json_annotation.dart';

import 'asset_stores/asset_store_reference.dart';
import 'asset_stores/pretend_asset_reference.dart';
import 'command_trigger_reference.dart';
import 'levels/level_reference.dart';
import 'levels/menus/menu_reference.dart';
import 'levels/sounds/dialogue_level_reference.dart';
import 'levels/sounds/sound_reference.dart';
import 'levels/tile_maps/tile_map_flag.dart';
import 'levels/tile_maps/tile_map_level_reference.dart';
import 'levels/tile_maps/tile_map_reference.dart';

part 'project.g.dart';

/// The type definition for  a list of commands.
typedef CommandTriggers = List<CommandTriggerReference>;

/// The type definition for a list of asset stores.
typedef AssetStores = List<AssetStoreReference>;

/// The type definition for a list of menus.
typedef Menus = List<MenuReference>;

/// The type definition for a list of levels.
typedef Levels = List<LevelReference>;

/// The type definition for a list of tile flags.
typedef TileMapFlags = List<TileMapFlag>;

/// The type definition for a list of tile map references.
typedef TileMaps = List<TileMapReference>;

/// A type definition for a list of tile map level references.
typedef TileMapLevels = List<TileMapLevelReference>;

/// The type definition for a list of dialogue levels.
typedef DialogueLevels = List<DialogueLevelReference>;

/// The top-level project class.
@JsonSerializable()
class Project {
  /// Create an instance.
  Project({
    required this.title,
    this.gameClassName = 'CustomGame',
    this.gameClassComment = 'A custom game.',
    final CommandTriggers? commandTriggers,
    final AssetStores? assetStores,
    this.orgName = 'com.example',
    this.appName = 'untitled_game',
    this.outputDirectory = 'lib/generated',
    final Menus? menus,
    final Levels? levels,
    final TileMapFlags? tileMapFlags,
    final TileMaps? tileMaps,
    final TileMapLevels? tileMapLevels,
    final DialogueLevels? dialogueLevels,
  })  : commandTriggers = commandTriggers ?? [],
        assetStores = assetStores ?? [],
        menus = menus ?? [],
        levels = levels ?? [],
        tileMapFlags = tileMapFlags ?? [],
        tileMaps = tileMaps ?? [],
        tileMapLevels = tileMapLevels ?? [],
        dialogueLevels = dialogueLevels ?? [];

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

  /// The output directory for files.
  String outputDirectory;

  /// The name of the autogenerated game class.
  String gameClassName;

  /// The comment to use when generating the game class.
  String gameClassComment;

  /// The command triggers to use.
  final CommandTriggers commandTriggers;

  /// Get the command trigger with the given [id].
  CommandTriggerReference getCommandTrigger(final String id) =>
      commandTriggers.firstWhere((final element) => element.id == id);

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

  /// Get a string that describes the given [pretendAssetReference].
  String getAssetString(final PretendAssetReference pretendAssetReference) {
    final assetStore = getAssetStore(pretendAssetReference.assetStoreId);
    return '${assetStore.name}/${pretendAssetReference.variableName}';
  }

  /// The menus that have been defined.
  final Menus menus;

  /// The levels that have been defined.
  final Levels levels;

  /// The tile flags that have been defined.
  final TileMapFlags tileMapFlags;

  /// Get the flag with the given [id].
  TileMapFlag getFlag(final String id) =>
      tileMapFlags.firstWhere((final element) => element.id == id);

  /// Convert the given list of [flags] to a list of actual [TileMapFlag]
  /// instances.
  List<TileMapFlag> getFlags(final Iterable<String> flags) => flags
      .map<TileMapFlag>(
        getFlag,
      )
      .toList();

  /// The created tile maps.
  final TileMaps tileMaps;

  /// Get the tile map with the given [id].
  TileMapReference getTileMap(final String id) =>
      tileMaps.firstWhere((final element) => element.id == id);

  /// The tile map levels that have been created.
  final TileMapLevels tileMapLevels;

  /// The dialogue levels that have been created.
  final DialogueLevels dialogueLevels;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
