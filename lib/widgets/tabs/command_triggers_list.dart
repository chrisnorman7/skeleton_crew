import 'package:flutter/material.dart';
import 'package:ziggurat/ziggurat.dart';

import '../../json/command_trigger_reference.dart';
import '../../json/levels/menus/menu_reference.dart';
import '../../screens/command_triggers/edit_command_trigger.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../center_text.dart';
import '../project_context_state.dart';
import '../push_widget_list_tile.dart';
import '../searchable_list_view.dart';

/// A widget for displaying command triggers.
class CommandTriggersList extends StatefulWidget {
  /// Create an instance.
  const CommandTriggersList({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  CommandTriggersListState createState() => CommandTriggersListState();
}

/// State for [CommandTriggersList].
class CommandTriggersListState
    extends ProjectContextState<CommandTriggersList> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = projectContext.project;
    final commandTriggers = project.commandTriggers;
    final Widget child;
    if (commandTriggers.isEmpty) {
      child = const CenterText(
        text: 'There are no command triggers yet.',
      );
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < commandTriggers.length; i++) {
        final commandTriggerReference = commandTriggers[i];
        final commandTrigger = commandTriggerReference.commandTrigger;
        final title =
            '${commandTrigger.name} (${commandTriggerReference.variableName})';
        children.add(
          SearchableListTile(
            searchString: commandTrigger.name,
            child: CallbackShortcuts(
              bindings: {
                deleteShortcut: () => deleteCommandTrigger(
                      context: context,
                      projectContext: projectContext,
                      commandTriggerReference: commandTriggerReference,
                      onDone: () => setState(() {}),
                    )
              },
              child: PushWidgetListTile(
                builder: (final context) => EditCommandTrigger(
                  projectContext: projectContext,
                  commandTriggerReference: commandTriggerReference,
                ),
                autofocus: i == 0,
                onSetState: () => setState(() {}),
                title: title,
                subtitle: commandTrigger.description,
              ),
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return CallbackShortcuts(
      bindings: {
        newShortcut: () => createCommandTrigger(
              context: context,
              projectContext: widget.projectContext,
              onDone: () => setState(() {}),
            ),
      },
      child: child,
    );
  }
}

/// Create a new command trigger.
Future<void> createCommandTrigger({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final VoidCallback onDone,
}) async {
  final project = projectContext.project;
  final commandTriggerNumber = project.commandTriggers.length + 1;
  final commandTrigger = CommandTrigger(
    name: 'command_trigger_$commandTriggerNumber',
    description: 'Do something fun',
  );
  final commandTriggerReference = CommandTriggerReference(
    id: newId(),
    variableName: 'commandTrigger$commandTriggerNumber',
    commandTrigger: commandTrigger,
  );
  project.commandTriggers.add(commandTriggerReference);
  projectContext.save();
  await pushWidget(
    context: context,
    builder: (final context) => EditCommandTrigger(
      projectContext: projectContext,
      commandTriggerReference: commandTriggerReference,
    ),
  );
  onDone();
}

/// Delete the given [commandTriggerReference].
Future<void> deleteCommandTrigger({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final CommandTriggerReference commandTriggerReference,
  required final VoidCallback onDone,
}) {
  final project = projectContext.project;
  for (final level in [...project.levels, ...project.menus]) {
    final type = level is MenuReference ? 'menu' : 'level';
    for (final commandReference in level.commands) {
      if (commandReference.commandTriggerId == commandTriggerReference.id) {
        return showMessage(
          context: context,
          message: 'That trigger is used by a command on ${level.title} $type.',
        );
      }
    }
  }
  return confirm(
    context: context,
    message: 'Are you sure you want to delete this command trigger?',
    yesCallback: () {
      project.commandTriggers.removeWhere(
        (final element) => element.id == commandTriggerReference.id,
      );
      Navigator.pop(context);
      onDone();
    },
  );
}
