import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/tile_maps/tile_map_reference.dart';
import '../../../shortcuts.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/center_text.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/searchable_list_view.dart';
import '../../../widgets/simple_scaffold.dart';
import 'edit_tile_map_reference.dart';

/// A widget for viewing and editing tile maps.
class TileMapsList extends StatefulWidget {
  /// Create an instance.
  const TileMapsList({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  TileMapsListState createState() => TileMapsListState();
}

/// State for [TileMapsList].
class TileMapsListState extends State<TileMapsList> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = widget.projectContext;
    final project = projectContext.project;
    final tileMaps = project.tileMaps;
    final Widget child;
    if (tileMaps.isEmpty) {
      child = const CenterText(text: 'There are no tile maps to show.');
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < tileMaps.length; i++) {
        final tileMap = tileMaps[i];
        children.add(
          SearchableListTile(
            searchString: tileMap.name,
            child: CallbackShortcuts(
              bindings: {
                deleteShortcut: () => deleteTileMapReference(
                      context: context,
                      projectContext: projectContext,
                      tileMapReference: tileMap,
                      onYes: () => setState(() {}),
                    )
              },
              child: PushWidgetListTile(
                title: tileMap.name,
                builder: (final context) => EditTileMapReference(
                  projectContext: widget.projectContext,
                  tileMapReference: tileMap,
                ),
                autofocus: i == 0,
                onSetState: () => setState(() {}),
                subtitle: tileMap.variableName,
              ),
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return Cancel(
      child: CallbackShortcuts(
        bindings: {
          newShortcut: () => createTileMapReference(
                context: context,
                projectContext: projectContext,
                onDone: () => setState(() {}),
              )
        },
        child: SimpleScaffold(
          title: 'Tile Maps',
          body: child,
          floatingActionButton: FloatingActionButton(
            autofocus: tileMaps.isEmpty,
            child: addIcon,
            onPressed: () => createTileMapReference(
              context: context,
              projectContext: projectContext,
              onDone: () => setState(() {}),
            ),
            tooltip: 'Add Tile Map',
          ),
        ),
      ),
    );
  }
}

/// Create a new tile map.
Future<void> createTileMapReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final VoidCallback onDone,
}) async {
  final tileMaps = projectContext.project.tileMaps;
  final tileMap = TileMapReference(
    id: newId(),
    name: 'New Tile Map',
    variableName: 'tileMap${tileMaps.length + 1}',
    tiles: {},
  );
  tileMaps.add(tileMap);
  projectContext.save();
  await pushWidget(
    context: context,
    builder: (final context) => EditTileMapReference(
      projectContext: projectContext,
      tileMapReference: tileMap,
    ),
  );
  onDone();
}

/// Delete the given [tileMapReference].
Future<void> deleteTileMapReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final TileMapReference tileMapReference,
  required final VoidCallback onYes,
}) {
  final tileMaps = projectContext.project.tileMaps;
  return confirm(
    context: context,
    message: 'Are you sure you want to delete this tile map?',
    title: 'Delete Tile Map',
    yesCallback: () {
      Navigator.pop(context);
      tileMaps.removeWhere(
        (final element) => element.id == tileMapReference.id,
      );
      projectContext.save();
      onYes();
    },
  );
}
