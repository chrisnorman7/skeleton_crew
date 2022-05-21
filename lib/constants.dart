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

/// The string to use when a value is not set.
const notSet = 'Not Set';

/// The directory where encrypted assets will be stored.
const assetsDirectory = 'assets';

/// The directory where asset store dart files will be stored.
///
/// This directory will be located beneath `Project.outputDirectory`.
const assetStoresDirectory = 'asset_stores';
