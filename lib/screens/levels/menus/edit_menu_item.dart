import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/menus/menu_item_reference.dart';
import '../../../json/levels/menus/menu_reference.dart';
import '../../../src/project_context.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/function_reference_list_tile.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/simple_scaffold.dart';
import '../../../widgets/sound_list_tile.dart';
import '../../../widgets/text_list_tile.dart';

/// A widget for editing a menu item [value].
class EditMenuItem extends StatefulWidget {
  /// Create an instance.
  const EditMenuItem({
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
  EditMenuItemState createState() => EditMenuItemState();
}

/// State for [EditMenuItem].
class EditMenuItemState extends ProjectContextState<EditMenuItem> {
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
    return Cancel(
      child: SimpleScaffold(
        actions: [
          ElevatedButton(
            onPressed: () {
              widget.menuReference.menuItems.removeWhere(
                (final element) => element.id == widget.value.id,
              );
              Navigator.pop(context);
            },
            child: deleteIcon,
          )
        ],
        title: 'Edit Menu Item',
        body: ListView(
          children: [
            TextListTile(
              value: menuItem.title ?? '<Untitled>',
              onChanged: (final value) {
                menuItem.title = value.isEmpty ? null : value;
                save();
              },
              header: 'Title',
              autofocus: true,
            ),
            SoundListTile(
              projectContext: projectContext,
              value: menuItem.soundReference,
              onChanged: (final value) {
                menuItem.soundReference = value;
                save();
              },
            ),
            FunctionReferenceListTile(
              value: menuItem.functionReference,
              onChanged: (final value) {
                menuItem.functionReference = value;
                save();
              },
            )
          ],
        ),
      ),
    );
  }
}
