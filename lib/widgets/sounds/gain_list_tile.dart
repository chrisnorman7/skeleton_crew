import 'package:flutter/material.dart';

import '../double_list_tile.dart';

/// A list tile to show the provided gain [value].
class GainListTile extends StatelessWidget {
  /// Create an instance.
  const GainListTile({
    required this.value,
    required this.onChanged,
    this.autofocus = false,
    this.title = 'Gain',
    this.subtitle,
    super.key,
  });

  /// The current gain value.
  final double value;

  /// The function to call when [value] changes.
  final ValueChanged<double> onChanged;

  /// The title of the widget.
  final String title;

  /// The subtitle for the widget.
  ///
  /// If this value is `null`, then [value] will be used.
  final String? subtitle;

  /// Whether or not the resulting [ListTile] should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final gainPercent = value * 100;
    return DoubleListTile(
      value: value,
      onChanged: onChanged,
      title: title,
      autofocus: autofocus,
      max: 5.0,
      min: 0.0,
      modifier: 0.05,
      subtitle: subtitle ?? '${gainPercent.round()}%',
    );
  }
}
