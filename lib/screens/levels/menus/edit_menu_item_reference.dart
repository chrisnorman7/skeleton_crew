import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/menus/menu_item_reference.dart';
import '../../../json/levels/menus/menu_reference.dart';
import '../../../json/message_reference.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/level_commands/call_function_list_tile.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/simple_scaffold.dart';
import '../../../widgets/sounds/sound_list_tile.dart';
import '../../../widgets/text_list_tile.dart';

/// A widget for editing a menu item [value].
class EditMenuItemReference extends StatefulWidget {
  /// Create an instance.
  const EditMenuItemReference({
    required this.projectContext,
    required this.menuReference,
    required this.value,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The menu that [value] belongs to.
  final MenuReference menuReference;

  /// The menu item to edit.
  final MenuItemReference value;

  /// Create state for this widget.
  @override
  EditMenuItemReferenceState createState() => EditMenuItemReferenceState();
}

/// State for [EditMenuItemReference].
class EditMenuItemReferenceState
    extends ProjectContextState<EditMenuItemReference> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final menuItem = widget.value;
    final message = menuItem.message;
    return Cancel(
      child: SimpleScaffold(
        actions: [
          ElevatedButton(
            onPressed: () => deleteMenuItemReference(
              context: context,
              projectContext: projectContext,
              menuReference: widget.menuReference,
              menuItemReference: menuItem,
              onYes: () => Navigator.pop(context),
            ),
            child: deleteIcon,
          )
        ],
        title: 'Edit Menu Item',
        body: ListView(
          children: [
            TextListTile(
              value: message.text ?? '',
              onChanged: (final value) {
                message.text = value.isEmpty ? null : value;
                save();
              },
              header: 'Title',
              autofocus: true,
            ),
            SoundListTile(
              projectContext: projectContext,
              value: message.soundReference,
              onChanged: (final value) {
                message.soundReference = value;
                save();
              },
            ),
            CallFunctionListTile(
              projectContext: widget.projectContext,
              levelReference: widget.menuReference,
              value: menuItem.callFunction,
              onChanged: (final value) {
                menuItem.callFunction = value;
                save();
              },
            )
          ],
        ),
      ),
    );
  }
}

/// Create a new menu item.
Future<void> createMenuItemReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final MenuReference menuReference,
  required final VoidCallback onDone,
}) async {
  final menuItem = MenuItemReference(
    id: newId(),
    message: MessageReference(id: newId()),
  );
  menuReference.menuItems.add(menuItem);
  projectContext.save();
  await pushWidget(
    context: context,
    builder: (final context) => EditMenuItemReference(
      projectContext: projectContext,
      menuReference: menuReference,
      value: menuItem,
    ),
  );
  onDone();
}

/// Delete the given [menuItemReference] from the given [menuReference].
Future<void> deleteMenuItemReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final MenuReference menuReference,
  required final MenuItemReference menuItemReference,
  required final VoidCallback onYes,
}) =>
    confirm(
      context: context,
      message: 'Are you sure you want to delete this menu item?',
      title: 'Delete Menu Item',
      yesCallback: () {
        Navigator.pop(context);
        menuReference.menuItems.removeWhere(
          (final element) => element.id == menuItemReference.id,
        );
        projectContext.save();
        onYes();
      },
    );
