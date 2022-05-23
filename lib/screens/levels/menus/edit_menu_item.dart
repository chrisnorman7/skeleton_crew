import 'package:flutter/material.dart';

import '../../../json/levels/menus/menu_item_reference.dart';
import '../../../src/project_context.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/simple_scaffold.dart';
import '../../../widgets/text_list_tile.dart';

/// A widget for editing a menu item [value].
class EditMenuItem extends StatefulWidget {
  /// Create an instance.
  const EditMenuItem({
    required this.projectContext,
    required this.value,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

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
    final menu = widget.value;
    return SimpleScaffold(
      title: 'Edit Menu Item',
      body: ListView(
        children: [
          TextListTile(
            value: menu.title ?? '<Untitled>',
            onChanged: (final value) {
              menu.title = value.isEmpty ? null : value;
            },
            header: 'Title',
          )
        ],
      ),
    );
  }
}
