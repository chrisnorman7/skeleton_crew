import 'package:json_annotation/json_annotation.dart';

import 'asset_stores/asset_store_reference.dart';
import 'command_trigger_reference.dart';

part 'project.g.dart';

/// The type definition for  a list of commands.
typedef CommandTriggers = List<CommandTriggerReference>;

/// The type definition for a list of asset stores.
typedef AssetStores = List<AssetStoreReference>;

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
    this.commandTriggersFilename = 'command_triggers.dart',
    this.assetStoreDartFilesDirectory = 'assets',
  })  : commandTriggers = commandTriggers ?? [],
        assetStores = assetStores ?? [];

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

  /// The file where command triggers will be stored.
  ///
  /// This value will be joined to the [outputDirectory] to get the full path.
  String commandTriggersFilename;

  /// The directory where asset store dart files will be stored.
  ///
  /// This directory will be located under [outputDirectory].
  String assetStoreDartFilesDirectory;

  /// The command triggers to use.
  final CommandTriggers commandTriggers;

  /// The asset stores that have been defined.
  final AssetStores assetStores;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
