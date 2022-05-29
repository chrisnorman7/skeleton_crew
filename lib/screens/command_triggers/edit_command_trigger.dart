import 'package:dart_sdl/dart_sdl.dart';
import 'package:flutter/material.dart';
import 'package:ziggurat/ziggurat.dart';

import '../../constants.dart';
import '../../json/command_trigger_reference.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../../validators.dart';
import '../../widgets/cancel.dart';
import '../../widgets/project_context_state.dart';
import '../../widgets/push_widget_list_tile.dart';
import '../../widgets/simple_scaffold.dart';
import '../../widgets/text_list_tile.dart';
import '../lists/select_item.dart';
import 'edit_command_keyboard_key.dart';

/// A widget for editing the given [commandTriggerReference].
class EditCommandTrigger extends StatefulWidget {
  /// Create an instance.
  const EditCommandTrigger({
    required this.projectContext,
    required this.commandTriggerReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The command trigger to edit.
  final CommandTriggerReference commandTriggerReference;

  /// Create state for this widget.
  @override
  EditCommandTriggerState createState() => EditCommandTriggerState();
}

/// State for [EditCommandTrigger].
class EditCommandTriggerState extends ProjectContextState<EditCommandTrigger> {
  /// The command trigger to work on.
  late CommandTrigger commandTrigger;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
    commandTrigger = widget.commandTriggerReference.commandTrigger;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = projectContext.project;
    final button = commandTrigger.button;
    final commandKeyboardKey = commandTrigger.keyboardKey;
    return Cancel(
      child: SimpleScaffold(
        actions: [
          ElevatedButton(
            onPressed: () => confirm(
              context: context,
              message: 'Are you sure you want to delete this command trigger?',
              yesCallback: () {
                project.commandTriggers.removeWhere(
                  (final element) =>
                      element.id == widget.commandTriggerReference.id,
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            child: deleteIcon,
          )
        ],
        title: 'Edit Command Trigger',
        body: ListView(
          children: [
            TextListTile(
              value: widget.commandTriggerReference.variableName,
              onChanged: (final value) {
                widget.commandTriggerReference.variableName = value;
                save();
              },
              header: 'Variable Name',
              validator: (final value) => validateVariableName(
                value: value,
                variableNames: project.commandTriggers.map<String>(
                  (final e) => e.variableName,
                ),
              ),
            ),
            TextListTile(
              value: widget.commandTriggerReference.comment ??
                  commandTrigger.description,
              onChanged: (final value) {
                widget.commandTriggerReference.comment =
                    value.isEmpty ? null : value;
                save();
              },
              header: 'Comment',
            ),
            TextListTile(
              value: commandTrigger.name,
              onChanged: (final value) => editCommandTrigger(
                name: value,
                description: commandTrigger.description,
                button: commandTrigger.button,
                keyboardKey: commandTrigger.keyboardKey,
              ),
              header: 'Name',
              autofocus: true,
              validator: (final value) => validateNonEmptyValue(value: value),
            ),
            TextListTile(
              value: commandTrigger.description,
              onChanged: (final value) => editCommandTrigger(
                name: commandTrigger.name,
                description: value,
                button: commandTrigger.button,
                keyboardKey: commandTrigger.keyboardKey,
              ),
              header: 'Description',
              validator: (final value) => validateNonEmptyValue(value: value),
            ),
            PushWidgetListTile(
              title: 'Game Controller Button',
              builder: (final context) => SelectItem<GameControllerButton?>(
                values: const [null, ...GameControllerButton.values],
                onDone: (final value) => editCommandTrigger(
                  name: commandTrigger.name,
                  description: commandTrigger.description,
                  button: value,
                  keyboardKey: commandTrigger.keyboardKey,
                ),
                getSearchString: (final value) =>
                    value == null ? '' : value.name,
                getWidget: (final value) =>
                    value == null ? const Text('Clear') : Text(value.name),
                title: 'Select Game Controller Button',
                value: button,
              ),
              subtitle: button == null ? notSet : button.name,
            ),
            PushWidgetListTile(
              title: 'Keyboard Key',
              builder: (final context) {
                if (commandKeyboardKey == null) {
                  return SelectItem<ScanCode>(
                    values: ScanCode.values,
                    onDone: (final value) => editCommandTrigger(
                      name: commandTrigger.name,
                      description: commandTrigger.description,
                      button: commandTrigger.button,
                      keyboardKey: CommandKeyboardKey(value),
                    ),
                    getSearchString: (final value) => value.name,
                    getWidget: (final value) => Text(value.name),
                    title: 'Select Scan Code',
                  );
                } else {
                  return EditCommandKeyboardKey(
                    commandKeyboardKey: commandKeyboardKey,
                    onChanged: (final value) => editCommandTrigger(
                      name: commandTrigger.name,
                      description: commandTrigger.description,
                      button: button,
                      keyboardKey: value,
                    ),
                  );
                }
              },
              subtitle: commandKeyboardKey?.toPrintableString() ?? notSet,
            )
          ],
        ),
      ),
    );
  }

  /// Change something about the command trigger.
  void editCommandTrigger({
    required final String name,
    required final String description,
    required final GameControllerButton? button,
    required final CommandKeyboardKey? keyboardKey,
  }) {
    commandTrigger = CommandTrigger(
      name: name,
      description: description,
      button: button,
      keyboardKey: keyboardKey,
    );
    widget.commandTriggerReference.commandTrigger = commandTrigger;
    save();
  }
}
