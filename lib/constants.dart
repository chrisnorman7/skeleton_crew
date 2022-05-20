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

/// The delete icon to use.
const deleteIcon = Icon(
  Icons.delete,
  semanticLabel: 'Delete',
);

/// The string to use when a value is not set.
const notSet = 'Not Set';
