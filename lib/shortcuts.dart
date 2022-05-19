import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Whether we're running on Mac OS.
final macOs = Platform.isMacOS;

/// The "New" shortcut.
final newShortcut = SingleActivator(
  LogicalKeyboardKey.keyN,
  control: !macOs,
  meta: macOs,
);

/// The "Open" shortcut.
final openShortcut = SingleActivator(
  LogicalKeyboardKey.keyO,
  control: !macOs,
  meta: macOs,
);
