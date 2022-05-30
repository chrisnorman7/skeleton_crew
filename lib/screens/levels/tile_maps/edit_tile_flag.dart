import 'package:flutter/material.dart';

import '../../../json/levels/tile_maps/tile_flag.dart';
import '../../../src/project_context.dart';
import '../../../validators.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/simple_scaffold.dart';
import '../../../widgets/text_list_tile.dart';

/// A widget to edit a [tileMapFlag].
class EditTileMapFlag extends StatefulWidget {
  /// Create an instance.
  const EditTileMapFlag({
    required this.projectContext,
    required this.tileMapFlag,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The flag to edit.
  final TileMapFlag tileMapFlag;

  /// Create state for this widget.
  @override
  EditTileMapFlagState createState() => EditTileMapFlagState();
}

/// State for [EditTileMapFlag].
class EditTileMapFlagState extends ProjectContextState<EditTileMapFlag> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final flag = widget.tileMapFlag;
    return SimpleScaffold(
      title: 'Edit Flag',
      body: ListView(
        children: [
          TextListTile(
            value: flag.name,
            onChanged: (final value) {
              flag.name = value;
              save();
            },
            header: 'Name',
            autofocus: true,
            validator: (final value) => validateNonDuplicateValue(
              value: value,
              values: projectContext.project.tileMapFlags
                  .map<String>((final e) => e.name),
              message: 'There is already a flag with that name.',
            ),
          )
        ],
      ),
    );
  }
}
