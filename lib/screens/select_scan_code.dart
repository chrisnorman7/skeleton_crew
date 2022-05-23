import 'package:dart_sdl/dart_sdl.dart';
import 'package:flutter/material.dart';

import 'lists/select_item.dart';

/// A widget for selecting a new [value].
class SelectScanCode extends StatelessWidget {
  /// Create an instance.
  const SelectScanCode({
    required this.onDone,
    this.value,
    this.actions = const [],
    super.key,
  });

  /// The function to call with the new value.
  final ValueChanged<ScanCode> onDone;

  /// The current scan code.
  final ScanCode? value;

  /// The actions to pass to the resulting [SelectItem].
  final List<Widget> actions;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SelectItem<ScanCode>(
        onDone: (final value) {
          Navigator.pop(context);
          onDone(value);
        },
        values: ScanCode.values,
        actions: actions,
        getSearchString: (final value) => value.name,
        getWidget: (final value) => Text(value.name),
        title: 'Select Scan Code',
        value: value,
      );
}
