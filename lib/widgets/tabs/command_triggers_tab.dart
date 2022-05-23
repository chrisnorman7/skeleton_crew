import 'package:flutter/material.dart';

import '../../screens/command_triggers/edit_command_trigger.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../center_text.dart';
import '../push_widget_list_tile.dart';
import '../searchable_list_view.dart';

/// A widget for displaying command triggers.
class CommandTriggersTab extends StatefulWidget {
  /// Create an instance.
  const CommandTriggersTab({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  CommandTriggersTabState createState() => CommandTriggersTabState();
}

/// State for [CommandTriggersTab].
class CommandTriggersTabState extends State<CommandTriggersTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = widget.projectContext.project;
    final commandTriggers = project.commandTriggers;
    final Widget child;
    if (commandTriggers.isEmpty) {
      child = const CenterText(
        text: 'There are no command triggers yet.',
      );
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < commandTriggers.length; i++) {
        final commandTrigger = commandTriggers[i];
        children.add(
          SearchableListTile(
            searchString: commandTrigger.commandTrigger.description,
            child: PushWidgetListTile(
              builder: (final context) => EditCommandTrigger(
                projectContext: widget.projectContext,
                commandTriggerReference: commandTrigger,
              ),
              autofocus: i == 0,
              onSetState: () => setState(() {}),
              title: commandTrigger.commandTrigger.description,
              subtitle: commandTrigger.variableName,
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return CallbackShortcuts(
      bindings: {
        newShortcut: () async {
          await createCommandTrigger(
            context: context,
            projectContext: widget.projectContext,
          );
          setState(() {});
        },
      },
      child: child,
    );
  }
}
