import 'package:flutter/material.dart';

import '../../../json/levels/tile_maps/tile_map_reference.dart';
import '../../../src/project_context.dart';
import '../../lists/select_item.dart';

/// A widget for selecting a tile map reference.
class SelectTileMapReference extends StatelessWidget {
  /// Create an instance.
  const SelectTileMapReference({
    required this.projectContext,
    required this.onChanged,
    this.value,
    super.key,
  });

  /// The project context to get the maps from.
  final ProjectContext projectContext;

  /// The function to call with the new [value].
  final ValueChanged<TileMapReference> onChanged;

  /// The current tile map level.
  final TileMapReference? value;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SelectItem<TileMapReference>(
        onDone: onChanged,
        values: projectContext.project.tileMaps,
        getSearchString: (final value) => value.name,
        getWidget: (final value) => Text(value.name),
        title: 'Select Tile Map',
        value: value,
      );
}
