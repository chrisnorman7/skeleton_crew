import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../json/levels/tile_maps/tile_flag.dart';
import '../../../json/levels/tile_maps/tile_map_reference.dart';
import '../../../shortcuts.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/project_context_state.dart';
import 'select_flags.dart';

/// The message that will be shown when trying to change the flags for an
/// unselected tile while other tiles are selected.
const cannotChangeFlagsMessage =
    'Cannot set flags for an unselected tile while other tiles are selected.';

/// A widget for editing the tiles of a [tileMapReference].
class EditTileMapReferenceTiles extends StatefulWidget {
  /// Create an instance.
  const EditTileMapReferenceTiles({
    required this.projectContext,
    required this.tileMapReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The tile map to edit.
  final TileMapReference tileMapReference;

  /// Create state for this widget.
  @override
  EditTileMapReferenceTilesState createState() =>
      EditTileMapReferenceTilesState();
}

/// State for [EditTileMapReferenceTiles].
class EditTileMapReferenceTilesState
    extends ProjectContextState<EditTileMapReferenceTiles> {
  /// The indices of tiles which have been selected.
  late final List<int> selectedIndices;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
    selectedIndices = [];
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final tileMap = widget.tileMapReference;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (selectedIndices.isEmpty) {
            Navigator.pop(context);
          } else {
            selectedIndices.clear();
            setState(() {});
          }
        },
        selectAllShortcut: () {
          selectedIndices.clear();
          for (var i = 0; i < tileMap.width * tileMap.height; i++) {
            selectedIndices.add(i);
          }
          setState(() {});
        }
      },
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: tileMap.width,
        ),
        itemBuilder: getGridTile,
        itemCount: tileMap.width * tileMap.height,
        reverse: true,
      ),
    );
  }

  /// Convert the given [index] to coordinates.
  Point<int> getCoordinates(final int index) {
    final x = index % widget.tileMapReference.width;
    final y = (index / widget.tileMapReference.height).floor();
    return Point(x, y);
  }

  /// Get the flags for the tile at the given [coordinates].
  ///
  /// If not tile exists at those coordinates, then default flags will be
  /// returned.
  List<TileMapFlag> getTileFlags(final Point<int> coordinates) {
    final tileMap = widget.tileMapReference;
    final flagIds =
        tileMap.tiles[coordinates.x]?[coordinates.y] ?? tileMap.defaultFlagIds;
    return projectContext.project.getFlags(flagIds);
  }

  /// Set the flags for the given [coordinates].
  void setTileFlags({
    required final Point<int> coordinates,
    required final Iterable<TileMapFlag> flags,
  }) {
    final tiles = widget.tileMapReference.tiles;
    final column = tiles.putIfAbsent(coordinates.x, () => {});
    final tile = column.putIfAbsent(coordinates.y, () => []);
    // ignore: cascade_invocations
    tile.clear();
    for (final flag in flags) {
      tile.add(flag.id);
    }
    final project = projectContext.project;
    tile.sort(
      (final a, final b) => project
          .getFlag(a)
          .name
          .toLowerCase()
          .compareTo(project.getFlag(b).name.toLowerCase()),
    );
    save();
  }

  /// Clear the flags for the given [coordinates].
  void clearTileFlags(final Point<int> coordinates) {
    final tiles = widget.tileMapReference.tiles;
    final column = tiles[coordinates.x];
    if (column != null) {
      column.remove(coordinates.y);
      if (column.isEmpty) {
        tiles.remove(coordinates.x);
      }
    }
    save();
  }

  /// Get the grid tile for the given [index].
  Widget getGridTile(final BuildContext context, final int index) {
    final project = projectContext.project;

    final coordinates = getCoordinates(index);
    final x = coordinates.x;
    final y = coordinates.y;
    final tileFlags = getTileFlags(coordinates);
    final selected = selectedIndices.contains(index);
    return CallbackShortcuts(
      bindings: {
        selectTileShortcut: () {
          if (selected) {
            selectedIndices.remove(index);
          } else {
            selectedIndices.add(index);
          }
          setState(() {});
        },
        deleteShortcut: () {
          if (!selected || selectedIndices.isEmpty) {
            clearTileFlags(coordinates);
          } else {
            for (final i in selectedIndices) {
              clearTileFlags(
                getCoordinates(i),
              );
            }
            selectedIndices.clear();
          }
        }
      },
      child: GridTile(
        child: ListTile(
          autofocus: index == 0,
          onTap: () async {
            if (selectedIndices.isEmpty) {
              await pushWidget(
                context: context,
                builder: (final context) => SelectFlags(
                  flags: project.tileMapFlags,
                  value: tileFlags,
                  onChanged: (final value) {
                    if (value == null) {
                      clearTileFlags(coordinates);
                    } else {
                      setTileFlags(
                        coordinates: coordinates,
                        flags: value,
                      );
                    }
                  },
                  nullable: true,
                ),
              );
            } else if (!selected) {
              await showMessage(
                context: context,
                message: cannotChangeFlagsMessage,
              );
            } else {
              final set = <TileMapFlag>{};
              for (final i in selectedIndices) {
                set.addAll(
                  getTileFlags(
                    getCoordinates(i),
                  ),
                );
              }
              final currentTileFlags = set.toList();
              await pushWidget(
                context: context,
                builder: (final context) => SelectFlags(
                  flags: project.tileMapFlags,
                  value: currentTileFlags,
                  onChanged: (final value) {
                    while (selectedIndices.isNotEmpty) {
                      final i = selectedIndices.removeLast();
                      final selectedCoordinates = getCoordinates(i);
                      if (value == null) {
                        clearTileFlags(selectedCoordinates);
                      } else {
                        setTileFlags(
                          coordinates: selectedCoordinates,
                          flags: value,
                        );
                      }
                    }
                  },
                  nullable: true,
                ),
              );
            }
          },
          selected: selected,
          title: Text('$x, $y'),
          subtitle: Text(tileFlags.map<String>((final e) => e.name).join(', ')),
        ),
      ),
    );
  }
}
