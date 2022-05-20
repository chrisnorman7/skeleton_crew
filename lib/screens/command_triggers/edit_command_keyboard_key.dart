import 'package:dart_sdl/dart_sdl.dart';
import 'package:flutter/material.dart';
import 'package:ziggurat/ziggurat.dart';

import '../../constants.dart';
import '../../widgets/cancel.dart';
import '../../widgets/push_widget_list_tile.dart';
import '../../widgets/simple_scaffold.dart';
import '../lists/select_item.dart';

/// A widget for editing the given [commandKeyboardKey].
class EditCommandKeyboardKey extends StatefulWidget {
  /// Create an instance.
  const EditCommandKeyboardKey({
    required this.commandKeyboardKey,
    required this.onChanged,
    super.key,
  });

  /// The command keyboard key to edit.
  final CommandKeyboardKey commandKeyboardKey;

  /// The function to call when [commandKeyboardKey] changes.
  final ValueChanged<CommandKeyboardKey?> onChanged;

  /// Create state for this widget.
  @override
  EditCommandKeyboardKeyState createState() => EditCommandKeyboardKeyState();
}

/// State for [EditCommandKeyboardKey].
class EditCommandKeyboardKeyState extends State<EditCommandKeyboardKey> {
  /// The instance to work on.
  late CommandKeyboardKey commandKeyboardKey;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    commandKeyboardKey = widget.commandKeyboardKey;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Cancel(
        child: SimpleScaffold(
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onChanged(null);
              },
              child: deleteIcon,
            )
          ],
          title: 'Edit Command Keyboard Key',
          body: ListView(
            children: [
              PushWidgetListTile(
                autofocus: true,
                title: 'Scan Code',
                builder: (final context) => SelectItem<ScanCode>(
                  values: ScanCode.values,
                  onDone: (final value) => save(scanCode: value),
                  getSearchString: (final value) => value.name,
                  getWidget: (final value) => Text(value.name),
                  title: 'Select Scan Code',
                  value: commandKeyboardKey.scanCode,
                ),
                subtitle: commandKeyboardKey.scanCode.name,
              ),
              CheckboxListTile(
                value: commandKeyboardKey.controlKey,
                onChanged: (final value) => save(controlKey: value ?? false),
                title: const Text('Control Key'),
                subtitle: Text(
                  commandKeyboardKey.controlKey ? 'Enabled' : 'Disabled',
                ),
              ),
              CheckboxListTile(
                value: commandKeyboardKey.altKey,
                onChanged: (final value) => save(altKey: value ?? false),
                title: const Text('Alt Key'),
                subtitle: Text(
                  commandKeyboardKey.altKey ? 'Enabled' : 'Disabled',
                ),
              ),
              CheckboxListTile(
                value: commandKeyboardKey.shiftKey,
                onChanged: (final value) => save(shiftKey: value ?? false),
                title: const Text('Shift Key'),
                subtitle: Text(
                  commandKeyboardKey.shiftKey ? 'Enabled' : 'Disabled',
                ),
              )
            ],
          ),
        ),
      );

  /// Save the [commandKeyboardKey].
  void save({
    final ScanCode? scanCode,
    final bool? altKey,
    final bool? controlKey,
    final bool? shiftKey,
  }) {
    commandKeyboardKey = CommandKeyboardKey(
      scanCode ?? commandKeyboardKey.scanCode,
      altKey: altKey ?? commandKeyboardKey.altKey,
      controlKey: controlKey ?? commandKeyboardKey.controlKey,
      shiftKey: shiftKey ?? commandKeyboardKey.shiftKey,
    );
    widget.onChanged(commandKeyboardKey);
    setState(() {});
  }
}
