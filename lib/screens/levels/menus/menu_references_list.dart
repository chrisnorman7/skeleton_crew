import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/menus/menu_reference.dart';
import '../../../shortcuts.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/center_text.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/searchable_list_view.dart';
import '../../../widgets/simple_scaffold.dart';
import '../levels/level_references_list.dart';
import 'edit_menu_reference.dart';

/// A list of menus.
class MenuReferencesList extends StatefulWidget {
  /// Create an instance.
  const MenuReferencesList({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  MenuReferencesListState createState() => MenuReferencesListState();
}

/// State for [MenuReferencesList].
class MenuReferencesListState extends State<MenuReferencesList> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final Widget child;
    final project = widget.projectContext.project;
    final menus = project.menus;
    if (menus.isEmpty) {
      child = const CenterText(text: 'There are no menus to show.');
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < menus.length; i++) {
        final menu = menus[i];
        children.add(
          SearchableListTile(
            searchString: menu.title,
            child: CallbackShortcuts(
              bindings: {
                deleteShortcut: () => deleteLevelReference(
                      context: context,
                      projectContext: widget.projectContext,
                      levelReference: menu,
                      onYes: () => setState(() {}),
                    )
              },
              child: PushWidgetListTile(
                title: menu.title,
                builder: (final context) => EditMenuReference(
                  projectContext: widget.projectContext,
                  menuReference: menu,
                ),
                autofocus: i == 0,
                onSetState: () => setState(() {}),
                subtitle: '${menu.className}: ${menu.comment}',
              ),
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return Cancel(
      child: CallbackShortcuts(
        bindings: {newShortcut: () => addMenu(context)},
        child: SimpleScaffold(
          title: 'Menus',
          body: child,
          floatingActionButton: FloatingActionButton(
            autofocus: menus.isEmpty,
            child: addIcon,
            onPressed: () => addMenu(context),
            tooltip: 'Add Menu',
          ),
        ),
      ),
    );
  }

  /// Add a new menu.
  Future<void> addMenu(final BuildContext context) async {
    final menu = MenuReference(
      id: newId(),
      title: 'Untitled Menu',
      menuItems: [],
    );
    widget.projectContext.project.menus.add(menu);
    widget.projectContext.save();
    await pushWidget(
      context: context,
      builder: (final context) => EditMenuReference(
        projectContext: widget.projectContext,
        menuReference: menu,
      ),
    );
    setState(() {});
  }
}
