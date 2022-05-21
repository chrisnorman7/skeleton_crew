import 'package:json_annotation/json_annotation.dart';

import 'asset_store_reference.dart';
import 'command_trigger_reference.dart';

part 'project.g.dart';

/// The top-level project class.
@JsonSerializable()
class Project {
  /// Create an instance.
  Project({
    required this.title,
    required this.commandTriggers,
    required this.assetStores,
    this.orgName = 'com.example',
    this.appName = 'untitled_game',
    this.version = '0.0.0',
    this.outputDirectory = 'lib/generated',
    this.commandTriggersFilename = 'command_triggers.dart',
    this.assetStoreDartFilesDirectory = 'assets',
    this.assetsDirectory = 'assets',
  });

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

  /// The directory where encrypted assets will be stored.
  final String assetsDirectory;

  /// The command triggers to use.
  final List<CommandTriggerReference> commandTriggers;

  /// The asset stores that have been defined.
  final List<AssetStoreReference> assetStores;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
