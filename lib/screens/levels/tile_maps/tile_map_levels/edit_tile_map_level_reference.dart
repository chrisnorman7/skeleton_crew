import 'package:flutter/material.dart';

import '../../../../json/levels/tile_maps/tile_map_level_reference.dart';
import '../../../../src/project_context.dart';
import '../../../../widgets/simple_scaffold.dart';
import '../../../../widgets/text_list_tile.dart';

/// A widget for editing the given [tileMapLevelReference].
class EditTileMapLevelReference extends StatefulWidget {
  /// Create an instance.
  const EditTileMapLevelReference({
    required this.projectContext,
    required this.tileMapLevelReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The level to edit.
  final TileMapLevelReference tileMapLevelReference;

  /// Create state for this widget.
  @override
  EditTileMapLevelReferenceState createState() =>
      EditTileMapLevelReferenceState();
}

/// State for [EditTileMapLevelReference].
class EditTileMapLevelReferenceState extends State<EditTileMapLevelReference> {
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
