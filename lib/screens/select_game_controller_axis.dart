import 'package:dart_sdl/dart_sdl.dart';
import 'package:flutter/material.dart';

import 'select_enum.dart';

/// A widget for selecting a game controller axis.
class SelectGameControllerAxis extends StatelessWidget {
  /// Create an instance.
  const SelectGameControllerAxis({
    required this.onDone,
    required this.value,
    this.actions = const [],
    super.key,
  });

  /// The function to call when [value] changes.
  final ValueChanged<GameControllerAxis> onDone;

  /// The current value.
  final GameControllerAxis? value;

  /// The actions to use for the resulting [SelectEnum].
  final List<Widget> actions;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SelectEnum<GameControllerAxis>(
        onDone: (final value) {
          Navigator.pop(context);
          onDone(value);
        },
        values: GameControllerAxis.values,
        actions: actions,
        value: value,
      );
}
