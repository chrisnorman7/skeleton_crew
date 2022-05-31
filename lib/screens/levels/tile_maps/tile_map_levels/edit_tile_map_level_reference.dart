import 'package:flutter/material.dart';

import '../../../../json/levels/tile_maps/tile_map_level_reference.dart';
import '../../../../widgets/simple_scaffold.dart';
import '../../../../widgets/text_list_tile.dart';

/// A widget for editing the given [tileMapLevelReference].
class EditTileMapeferenceLevel extends StatefulWidget {
  /// Create an instance.
  const EditTileMapeferenceLevel({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The level to edit.
  final TileMapLevelReference tileMapLevelReference;

  /// Create state for this widget.
  @override
  EditTileMapeferenceLevelState createState() =>
      EditTileMapeferenceLevelState();
}

/// State for [EditTileMapeferenceLevel].
class EditTileMapeferenceLevelState extends State<EditTileMapeferenceLevel> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final level = widget.tileMapLevelReference;
    return SimpleScaffold(
      title: 'Edit Tile Map Level',
      body: ListView(
        children: [
          TextListTile(
            value: level.title,
            onChanged: (final value) {
              level.title = value;
            },
            header: 'Name',
          )
        ],
      ),
    );
  }
}
