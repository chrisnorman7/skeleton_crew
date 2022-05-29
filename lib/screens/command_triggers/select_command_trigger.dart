import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/command_trigger_reference.dart';
import '../../src/project_context.dart';
import '../lists/select_item.dart';

/// A widget for selecting a new command trigger.
class SelectCommandTrigger extends StatelessWidget {
  /// Create an instance.
  const SelectCommandTrigger({
    required this.projectContext,
    required this.onChanged,
    this.value,
    this.nullable = true,
    this.ignoredCommandTriggerNames = const [],
    super.key,
  });

  /// The project context to get commands from.
  final ProjectContext projectContext;

  /// The current command trigger.
  final CommandTriggerReference? value;

  /// The function to call with the new value.
  final ValueChanged<CommandTriggerReference?> onChanged;

  /// Whether or not [value] is nullable.
  final bool nullable;

  /// A list of command names which should be ignored.
  final List<String> ignoredCommandTriggerNames;

  /// Build The widget.
  @override
  Widget build(final BuildContext context) =>
      SelectItem<CommandTriggerReference>(
        onDone: onChanged,
        values: projectContext.project.commandTriggers
            .where(
              (final element) =>
                  ignoredCommandTriggerNames
                      .contains(element.commandTrigger.name) ==
                  false,
            )
            .toList(),
        getSearchString: (final value) => value.commandTrigger.description,
        getWidget: (final value) {
          final trigger = value.commandTrigger;
          return Text(
            '${trigger.name}: ${trigger.description}',
          );
        },
        title: 'Select Trigger',
        actions: [
          if (nullable)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onChanged(null);
              },
              child: deleteIcon,
            )
        ],
        value: value,
      );
}
