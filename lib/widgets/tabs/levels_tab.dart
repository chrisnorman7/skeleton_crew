import 'package:flutter/material.dart';

import '../../screens/levels/levels/level_references_list.dart';
import '../../screens/levels/menus/menu_references_list.dart';
import '../../screens/levels/tile_maps/tile_map_levels/tile_map_level_references_list.dart';
import '../../src/project_context.dart';
import '../push_widget_list_tile.dart';

/// A tab to show level types.
class LevelsTab extends StatefulWidget {
  /// Create an instance.
  const LevelsTab({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  LevelsTabState createState() => LevelsTabState();
}

/// State for [LevelsTab].
class LevelsTabState extends State<LevelsTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = widget.projectContext.project;
    final menus = project.menus;
    final levels = project.levels;
    return ListView(
      children: [
        PushWidgetListTile(
          title: 'Levels',
          builder: (final context) =>
              LevelReferencesList(projectContext: widget.projectContext),
          autofocus: true,
          onSetState: () => setState(() {}),
          subtitle: '${levels.length}',
        ),
        PushWidgetListTile(
          title: 'Tile Map Levels',
          builder: (final context) => TileMapLevelReferencesList(
            projectContext: widget.projectContext,
          ),
          onSetState: () => setState(() {}),
          subtitle: '${project.tileMapLevels.length}',
        ),
        PushWidgetListTile(
          title: 'Menus',
          builder: (final context) => MenuReferencesList(
            projectContext: widget.projectContext,
          ),
          onSetState: () => setState(() {}),
          subtitle: '${menus.length}',
        )
      ],
    );
  }
}
