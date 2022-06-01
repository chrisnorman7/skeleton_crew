import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../json/levels/tile_maps/tile_map_level_reference.dart';
import '../../../../shortcuts.dart';
import '../../../../src/project_context.dart';
import '../../../../util.dart';
import '../../../../widgets/cancel.dart';
import '../../../../widgets/center_text.dart';
import '../../../../widgets/push_widget_list_tile.dart';
import '../../../../widgets/searchable_list_view.dart';
import '../../../../widgets/simple_scaffold.dart';
import '../select_tile_map_reference.dart';
import 'edit_tile_map_level_reference.dart';

/// A widget for editing the tile map level references for the given
/// [projectContext].
class TileMapLevelReferencesList extends StatefulWidget {
  /// Create an instance.
  const TileMapLevelReferencesList({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  TileMapLevelReferencesListState createState() =>
      TileMapLevelReferencesListState();
}

/// State for [TileMapLevelReferencesList].
class TileMapLevelReferencesListState
    extends State<TileMapLevelReferencesList> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final Widget child;
    final tileMapLevels = widget.projectContext.project.tileMapLevels;
    if (tileMapLevels.isEmpty) {
      child = const CenterText(text: 'There are no tile map levels to show.');
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < tileMapLevels.length; i++) {
        final tileMapLevel = tileMapLevels[i];
        children.add(
          SearchableListTile(
            searchString: tileMapLevel.title,
            child: CallbackShortcuts(
              bindings: {
                deleteShortcut: () => deleteTileMapLevelReference(
                      context: context,
                      projectContext: widget.projectContext,
                      tileMapLevelReference: tileMapLevel,
                      onYes: () => setState(() {}),
                    )
              },
              child: PushWidgetListTile(
                title: tileMapLevel.title,
                builder: (final context) => EditTileMapLevelReference(
                  projectContext: widget.projectContext,
                  tileMapLevelReference: tileMapLevel,
                ),
                autofocus: i == 0,
                onSetState: () => setState(() {}),
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
          newShortcut: () => createTileMapLevelReference(
                context: context,
                projectContext: widget.projectContext,
                onDone: () => setState(() {}),
              )
        },
        child: SimpleScaffold(
          title: 'Tile Map Levels',
          body: child,
          floatingActionButton: FloatingActionButton(
            autofocus: tileMapLevels.isEmpty,
            child: addIcon,
            onPressed: () => createTileMapLevelReference(
              context: context,
              projectContext: widget.projectContext,
              onDone: () => setState(() {}),
            ),
            tooltip: 'Add Tile Map Level',
          ),
        ),
      ),
    );
  }
}

/// Create a new tile map level.
Future<void> createTileMapLevelReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final VoidCallback onDone,
}) {
  final project = projectContext.project;
  final tileMaps = project.tileMaps;
  if (tileMaps.isEmpty) {
    return showMessage(
      context: context,
      message: 'You must create a tile map first.',
    );
  } else {
    return pushWidget(
      context: context,
      builder: (final context) => SelectTileMapReference(
        projectContext: projectContext,
        onChanged: (final value) async {
          final level = TileMapLevelReference(
            id: newId(),
            tileMapId: value.id,
          );
          project.tileMapLevels.add(level);
          projectContext.save();
          await pushWidget(
            context: context,
            builder: (final context) => EditTileMapLevelReference(
              projectContext: projectContext,
              tileMapLevelReference: level,
            ),
          );
          onDone();
        },
      ),
    );
  }
}

/// Delete the given [tileMapLevelReference].
Future<void> deleteTileMapLevelReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final TileMapLevelReference tileMapLevelReference,
  required final VoidCallback onYes,
}) =>
    confirm(
      context: context,
      message: 'Are you sure you want to delete this tile map level?',
      title: 'Delete Tile Map Level',
      yesCallback: () {
        Navigator.pop(context);
        projectContext.project.tileMapLevels.removeWhere(
          (final element) => element.id == tileMapLevelReference.id,
        );
        projectContext.save();
        onYes();
      },
    );
