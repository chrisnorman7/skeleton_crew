import 'package:flutter/material.dart';

import '../../screens/levels/tile_maps/tile_map_flags_list.dart';
import '../../screens/levels/tile_maps/tile_map_references_list.dart';
import '../../src/project_context.dart';
import '../push_widget_list_tile.dart';

/// A widget to show tile map related stuff.
class TileMapTab extends StatefulWidget {
  /// Create an instance.
  const TileMapTab({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  TileMapTabState createState() => TileMapTabState();
}

/// State for [TileMapTab].
class TileMapTabState extends State<TileMapTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = widget.projectContext;
    final project = projectContext.project;
    final flags = project.tileMapFlags;
    return ListView(
      children: [
        PushWidgetListTile(
          title: 'Flags',
          builder: (final context) => TileMapFlagsList(
            projectContext: projectContext,
          ),
          autofocus: true,
          onSetState: () => setState(() {}),
          subtitle: '${flags.length}',
        ),
        PushWidgetListTile(
          title: 'Tile Maps',
          builder: (final context) => TileMapReferencesList(
            projectContext: projectContext,
          ),
          onSetState: () => setState(() {}),
          subtitle: '${project.tileMaps.length}',
        )
      ],
    );
  }
}
