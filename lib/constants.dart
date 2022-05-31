import 'package:dart_style/dart_style.dart';
import 'package:flutter/material.dart';
import 'package:short_uuids/short_uuids.dart';

/// The UUID generator to use.
const shortUuid = ShortUuid();

/// The dart formatter to use.
final dartFormatter = DartFormatter();

/// The new icon to use.
const addIcon = Icon(
  Icons.add,
  semanticLabel: 'Add',
);

/// The close icon to use.
const closeIcon = Icon(
  Icons.close,
  semanticLabel: 'Close',
);

/// The save icon to use.
const saveIcon = Icon(
  Icons.save,
  semanticLabel: 'Save',
);

/// The delete icon to use.
const deleteIcon = Icon(
  Icons.delete,
  semanticLabel: 'Delete',
);

/// The icon to use to denote a series of files.
const filesIcon = Icon(Icons.storage);

/// The icon to use for ambiances.
const ambiancesIcon = Icon(Icons.architecture);

/// The string to use when a value is not set.
const notSet = 'Not Set';

/// The directory where encrypted assets will be stored.
const assetsDirectory = 'assets';

/// The directory where asset store dart files will be stored.
///
/// This directory will be located beneath `Project.outputDirectory`.
const assetStoresDirectory = 'asset_stores';

/// The filename where command triggers will be written.
///
/// This file will be located inside the output directory.
const commandTriggersFilename = 'command_triggers.dart';

/// The filename where menus will be stored.
///
/// This file will be located under the output directory.
const menuFilename = 'menus.dart';

/// The file where levels will be stored.
///
/// This file will be located under the output directory.
const levelFilename = 'levels.dart';

/// The file where the game code will be written.
///
/// This file will be located under the output directory.
const gameFilename = 'game.dart';

/// The icon to use for command triggers.
const commandTriggersIcon = Icon(
  Icons.mouse,
  semanticLabel: 'Command Triggers',
);

/// The icon to use for functions.
const functionsIcon = Icon(Icons.functions);

/// The file where flags will be stored.
///
/// This file will be located under the output directory.
const flagsFilename = 'flags.dart';

/// The file where tile maps where will be written.
///
/// This file will be located under the output directory.
const tileMapsFile = 'tile_maps.dart';
