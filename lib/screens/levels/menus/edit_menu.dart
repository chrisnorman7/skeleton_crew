import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/menus/menu_item_reference.dart';
import '../../../json/levels/menus/menu_reference.dart';
import '../../../shortcuts.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../validators.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/center_text.dart';
import '../../../widgets/double_list_tile.dart';
import '../../../widgets/int_list_tile.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/tabbed_scaffold.dart';
import '../../../widgets/text_list_tile.dart';
import '../../select_game_controller_axis.dart';
import '../../select_game_controller_button.dart';
import '../../select_scan_code.dart';
import 'edit_menu_item.dart';

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
  Widget build(final BuildContext context) {
    final menu = widget.menuReference;
    return Cancel(
      child: CallbackShortcuts(
        bindings: {newShortcut: () => addMenuItem(context)},
        child: TabbedScaffold(
          tabs: [
            TabbedScaffoldTab(
              title: 'Settings',
              icon: const Icon(Icons.settings),
              builder: getSettingsListView,
            ),
            TabbedScaffoldTab(
              title: 'Menu Items',
              icon: const Icon(Icons.menu_book),
              builder: getMenuItemsListView,
              floatingActionButton: FloatingActionButton(
                autofocus: menu.menuItems.isEmpty,
                child: addIcon,
                onPressed: () => addMenuItem(context),
                tooltip: 'Add Menu Item',
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Add a new menu item.
  Future<void> addMenuItem(final BuildContext context) async {
    final menuItem = MenuItemReference(id: newId());
    widget.menuReference.menuItems.add(menuItem);
    projectContext.save();
    await pushWidget(
      context: context,
      builder: (final context) => EditMenuItem(
        projectContext: projectContext,
        value: menuItem,
      ),
    );
    setState(() {});
  }

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
            value: menu.upButton,
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
            value: menu.downScanCode,
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
            value: menu.downButton,
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
            value: menu.activateScanCode,
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
            value: menu.activateButton,
          ),
          subtitle: menu.activateButton.name,
        ),
        PushWidgetListTile(
          title: 'Activate Axis',
          builder: (final context) => SelectGameControllerAxis(
            onDone: (final value) {
              menu.activateAxis = value;
              save();
            },
            value: menu.activateAxis,
          ),
          subtitle: menu.activateAxis.name,
        ),
        PushWidgetListTile(
          title: 'Cancel Scan Code',
          builder: (final context) => SelectScanCode(
            onDone: (final value) {
              menu.cancelScanCode = value;
              save();
            },
            value: menu.cancelScanCode,
          ),
          subtitle: menu.cancelScanCode.name,
        ),
        PushWidgetListTile(
          title: 'Cancel Button',
          builder: (final context) => SelectGameControllerButton(
            onDone: (final value) {
              menu.cancelButton = value;
              save();
            },
            value: menu.cancelButton,
          ),
          subtitle: menu.cancelButton.name,
        ),
        PushWidgetListTile(
          title: 'Cancel Axis',
          builder: (final context) => SelectGameControllerAxis(
            onDone: (final value) {
              menu.cancelAxis = value;
              save();
            },
            value: menu.cancelAxis,
          ),
          subtitle: menu.cancelAxis.name,
        ),
        PushWidgetListTile(
          title: 'Movement Axis',
          builder: (final context) => SelectGameControllerAxis(
            onDone: (final value) {
              menu.movementAxis = value;
              save();
            },
            value: menu.movementAxis,
          ),
          subtitle: menu.movementAxis.name,
        ),
        IntListTile(
          value: menu.controllerMovementSpeed,
          onChanged: (final value) {
            menu.controllerMovementSpeed = value;
            save();
          },
          title: 'Movement Timeout',
          min: 10,
          modifier: 100,
          subtitle: '${menu.controllerMovementSpeed} ms',
        ),
        DoubleListTile(
          value: menu.controllerAxisSensitivity,
          onChanged: (final value) {
            menu.controllerAxisSensitivity = value;
            save();
          },
          title: 'Axis Sensitivity',
          min: 0.01,
          max: 1.0,
          modifier: 0.1,
        ),
        CheckboxListTile(
          value: menu.searchEnabled,
          onChanged: (final value) {
            menu.searchEnabled = value ?? true;
            save();
          },
          title: const Text('Menu Is Searchable'),
          subtitle: Text(menu.searchEnabled ? 'Yes' : 'No'),
        ),
        IntListTile(
          value: menu.searchInterval,
          onChanged: (final value) {
            menu.searchInterval = value;
            save();
          },
          min: 10,
          modifier: 100,
          title: 'Search Timeout',
          subtitle: '${menu.searchInterval} ms',
        )
      ],
    );
  }

  /// Get the list view for the menu items.
  Widget getMenuItemsListView(final BuildContext context) {
    final menu = widget.menuReference;
    final menuItems = menu.menuItems;
    if (menuItems.isEmpty) {
      return const CenterText(text: 'There are no items to show.');
    }
    return ListView.builder(
      itemBuilder: (final context, final index) {
        final menuItem = menuItems[index];
        return PushWidgetListTile(
          title: menuItem.title ?? 'Untitled Menu Item',
          builder: (final context) => EditMenuItem(
            projectContext: projectContext,
            value: menuItem,
          ),
          autofocus: index == 0,
        );
      },
      itemCount: menuItems.length,
    );
  }
}
