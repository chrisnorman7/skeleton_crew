import 'package:flutter/material.dart';

import '../../../src/project_context.dart';
import '../../../widgets/center_text.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/searchable_list_view.dart';
import '../../../widgets/simple_scaffold.dart';
import 'edit_menu.dart';

/// A list of menus.
class MenusList extends StatefulWidget {
  /// Create an instance.
  const MenusList({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  MenusListState createState() => MenusListState();
}

/// State for [MenusList].
class MenusListState extends State<MenusList> {
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
            child: PushWidgetListTile(
              title: menu.title,
              builder: (final context) => EditMenu(
                projectContext: widget.projectContext,
                menuReference: menu,
              ),
              autofocus: i == 0,
              onSetState: () => setState(() {}),
              subtitle: '${menu.menuItems.length}',
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return SimpleScaffold(
      title: 'Menus',
      body: child,
    );
  }
}
