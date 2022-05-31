import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/tile_maps/tile_map_flag.dart';
import '../../../src/project_context.dart';
import '../../../validators.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/simple_scaffold.dart';
import '../../../widgets/text_list_tile.dart';
import 'tile_map_flags_list.dart';

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
    final flags = projectContext.project.tileMapFlags;
    return Cancel(
      child: SimpleScaffold(
        actions: [
          ElevatedButton(
            onPressed: () => deleteTileMapFlag(
              context: context,
              projectContext: projectContext,
              tileMapFlag: flag,
              onYes: () => Navigator.pop(context),
            ),
            child: deleteIcon,
          )
        ],
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
                values: flags.map<String>((final e) => e.name),
                message: 'There is already a flag with that name.',
              ),
            ),
            TextListTile(
              value: flag.variableName,
              onChanged: (final value) {
                flag.variableName = value;
                save();
              },
              header: 'Variable Name',
              validator: (final value) => validateVariableName(
                value: value,
                variableNames: flags.map<String>(
                  (final e) => e.variableName,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
