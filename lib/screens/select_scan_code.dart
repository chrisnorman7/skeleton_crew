import 'package:dart_sdl/dart_sdl.dart';
import 'package:flutter/material.dart';

import 'lists/select_item.dart';
import 'select_enum.dart';

/// A widget for selecting a new [value].
class SelectScanCode extends StatelessWidget {
  /// Create an instance.
  const SelectScanCode({
    required this.onDone,
    required this.value,
    this.actions = const [],
    super.key,
  });

  /// The function to call when [value] has changed.
  final ValueChanged<ScanCode> onDone;

  /// The current scan code.
  final ScanCode? value;

  /// The actions to pass to the resulting [SelectItem].
  final List<Widget> actions;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SelectEnum<ScanCode>(
        onDone: onDone,
        values: ScanCode.values,
        actions: actions,
        value: value,
      );
}
