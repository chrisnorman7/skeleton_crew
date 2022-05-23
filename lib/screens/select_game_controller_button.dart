import 'package:dart_sdl/dart_sdl.dart';
import 'package:flutter/material.dart';

import 'lists/select_item.dart';
import 'select_enum.dart';

/// A widget for changing the given [value].
class SelectGameControllerButton extends StatelessWidget {
  /// Create an instance.
  const SelectGameControllerButton({
    required this.onDone,
    required this.value,
    this.actions = const [],
    super.key,
  });

  /// The value to call when [value] changes.
  final ValueChanged<GameControllerButton> onDone;

  /// The value to change.
  final GameControllerButton? value;

  /// The actions to pass to the resulting [SelectItem].
  final List<Widget> actions;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SelectEnum<GameControllerButton>(
        onDone: onDone,
        values: GameControllerButton.values,
        actions: actions,
        value: value,
      );
}
