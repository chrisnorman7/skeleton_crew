import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/keyboard_shortcuts_list.dart';

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

/// The "Close Project" shortcut.
final closeProjectShortcut = SingleActivator(
  LogicalKeyboardKey.keyW,
  control: !macOs,
  meta: macOs,
);

/// The short to build the project.
final buildProjectShortcut = SingleActivator(
  LogicalKeyboardKey.keyB,
  control: !macOs,
  meta: macOs,
);

/// The search shortcut.
const searchShortcut = SingleActivator(LogicalKeyboardKey.slash);

/// The intent to get help from a [WithKeyboardShortcuts] widget.
final helpShortcut = SingleActivator(
  LogicalKeyboardKey.slash,
  control: !macOs,
  meta: macOs,
  shift: true,
);

/// The import file shortcut.
final importFileShortcut = SingleActivator(
  LogicalKeyboardKey.keyF,
  control: !macOs,
  meta: macOs,
);

/// The import directory shortcut.
final importDirectoryShortcut = SingleActivator(
  LogicalKeyboardKey.keyD,
  control: !macOs,
  meta: macOs,
);

/// The delete shortcut.
const deleteShortcut = SingleActivator(LogicalKeyboardKey.delete);

/// A shortcut to move items up.
final moveUpShortcut = SingleActivator(
  LogicalKeyboardKey.arrowUp,
  control: !macOs,
  meta: macOs,
);

/// A shortcut to move items down.
final moveDownShortcut = SingleActivator(
  LogicalKeyboardKey.arrowDown,
  control: !macOs,
  meta: macOs,
);
