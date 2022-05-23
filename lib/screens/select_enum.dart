import 'package:flutter/material.dart';

import 'lists/select_item.dart';

/// A widget for selecting a new [value].
class SelectEnum<T extends Enum> extends StatelessWidget {
  /// Create an instance.
  const SelectEnum({
    required this.values,
    required this.onDone,
    this.value,
    this.actions = const [],
    super.key,
  });

  /// The function to call when [value] has changed.
  final ValueChanged<T> onDone;

  /// The list of values to choose from.
  final List<T> values;

  /// The current scan code.
  final T? value;

  /// The actions to pass to the resulting [SelectItem].
  final List<Widget> actions;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SelectItem<T>(
        onDone: (final value) {
          Navigator.pop(context);
          onDone(value);
        },
        values: values,
        actions: actions,
        getSearchString: (final value) => value.name,
        getWidget: (final value) => Text(value.name),
        title: 'Select Scan Code',
        value: value,
      );
}
