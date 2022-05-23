import 'package:flutter/material.dart';

import '../../../json/levels/menus/menu_reference.dart';
import '../../../src/project_context.dart';
import '../../../validators.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/tabbed_scaffold.dart';
import '../../../widgets/text_list_tile.dart';
import '../../select_game_controller_button.dart';
import '../../select_scan_code.dart';

/// A widget for editing the given [menuReference].
class EditMenu extends StatefulWidget {
  /// Create an instance.
  const EditMenu({
    required this.projectContext,
    required this.menuReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The menu reference to edit.
  final MenuReference menuReference;

  /// Create state for this widget.
  @override
  EditMenuState createState() => EditMenuState();
}

/// State for [EditMenu].
class EditMenuState extends ProjectContextState<EditMenu> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Cancel(
        child: TabbedScaffold(
          tabs: [
            TabbedScaffoldTab(
              title: 'Settings',
              icon: const Icon(Icons.settings),
              builder: getSettingsListView,
            )
          ],
        ),
      );

  /// Get the settings list view.
  Widget getSettingsListView(final BuildContext context) {
    final menu = widget.menuReference;
    return ListView(
      children: [
        TextListTile(
          autofocus: true,
          value: menu.title,
          onChanged: (final value) {
            menu.title = value;
            save();
          },
          header: 'Title',
          validator: (final value) => validateNonEmptyValue(value: value),
        ),
        PushWidgetListTile(
          title: 'Move Up Scan Code',
          builder: (final context) => SelectScanCode(
            onDone: (final value) {
              menu.upScanCode = value;
              save();
            },
            value: menu.upScanCode,
          ),
          subtitle: menu.upScanCode.name,
        ),
        PushWidgetListTile(
          title: 'Move Up Button',
          builder: (final context) => SelectGameControllerButton(
            onDone: (final value) {
              menu.upButton = value;
              save();
            },
          ),
          subtitle: menu.upButton.name,
        ),
        PushWidgetListTile(
          title: 'Move Down Scan Code',
          builder: (final context) => SelectScanCode(
            onDone: (final value) {
              menu.downScanCode = value;
              save();
            },
          ),
          subtitle: menu.downScanCode.name,
        ),
        PushWidgetListTile(
          title: 'Move Down Button',
          builder: (final context) => SelectGameControllerButton(
            onDone: (final value) {
              menu.downButton = value;
              save();
            },
          ),
          subtitle: menu.downButton.name,
        ),
        PushWidgetListTile(
          title: 'Activate Scan Code',
          builder: (final context) => SelectScanCode(
            onDone: (final value) {
              menu.activateScanCode = value;
              save();
            },
          ),
          subtitle: menu.activateScanCode.name,
        ),
        PushWidgetListTile(
          title: 'Activate Button',
          builder: (final context) => SelectGameControllerButton(
            onDone: (final value) {
              menu.activateButton = value;
              save();
            },
          ),
          subtitle: menu.activateButton.name,
        ),
      ],
    );
  }
}
