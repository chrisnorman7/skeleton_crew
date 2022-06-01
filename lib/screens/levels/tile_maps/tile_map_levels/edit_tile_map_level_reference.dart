import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../json/levels/tile_maps/tile_map_level_reference.dart';
import '../../../../src/project_context.dart';
import '../../../../widgets/cancel.dart';
import '../../../../widgets/coordinates_list_tile.dart';
import '../../../../widgets/functions/functions_tabbed_scaffold_tab.dart';
import '../../../../widgets/int_list_tile.dart';
import '../../../../widgets/level_commands/level_commands_tabbed_scaffold_tab.dart';
import '../../../../widgets/project_context_state.dart';
import '../../../../widgets/push_widget_list_tile.dart';
import '../../../../widgets/sounds/ambiances/ambiances_tabbed_scaffold_tab.dart';
import '../../../../widgets/tabbed_scaffold.dart';
import '../../levels/edit_level_reference.dart';
import '../select_tile_map_reference.dart';
import 'tile_map_level_references_list.dart';

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
class EditTileMapLevelReferenceState
    extends ProjectContextState<EditTileMapLevelReference> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final level = widget.tileMapLevelReference;
    final project = projectContext.project;
    final tileMap = project.getTileMap(level.tileMapId);
    return Cancel(
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            title: 'Settings',
            icon: const Icon(Icons.settings),
            builder: (final context) => ListView(
              children: [
                ...getLevelReferenceListTiles(
                  projectContext: projectContext,
                  levelReference: level,
                  levels: project.tileMapLevels,
                  onSave: () => setState(() {}),
                ),
                PushWidgetListTile(
                  title: 'Tile Map',
                  builder: (final context) => SelectTileMapReference(
                    projectContext: projectContext,
                    onChanged: (final value) {
                      level.tileMapId = value.id;
                      save();
                    },
                    value: tileMap,
                  ),
                  onSetState: () => setState(() {}),
                  subtitle: tileMap.name,
                ),
                CoordinatesListTile(
                  projectContext: projectContext,
                  value: level.initialCoordinates,
                  onChanged: (final value) {
                    level.initialCoordinates
                      ..x = value!.x
                      ..y = value.y;
                    save();
                  },
                  nullable: false,
                  title: 'Initial Coordinates',
                ),
                IntListTile(
                  value: level.initialHeading,
                  onChanged: (final value) {
                    level.initialHeading = value;
                    save();
                  },
                  title: 'Initial Heading',
                  min: 0,
                  max: 360,
                  modifier: 5,
                  subtitle: '${level.initialHeading}°',
                )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => deleteTileMapLevelReference(
                  context: context,
                  projectContext: projectContext,
                  tileMapLevelReference: level,
                  onYes: () => Navigator.pop(context),
                ),
                child: deleteIcon,
              )
            ],
          ),
          FunctionsTabbedScaffoldTab(
            context: context,
            projectContext: projectContext,
            levelReference: level,
            onDone: () => setState(() {}),
          ),
          LevelCommandsTabbedScaffoldTab(
            context: context,
            projectContext: projectContext,
            levelReference: level,
            onDone: () => setState(() {}),
          ),
          AmbiancesTabbedScaffoldTab(
            context: context,
            projectContext: projectContext,
            ambiances: level.ambiances,
            onDone: () => setState(() {}),
          ),
        ],
      ),
    );
  }
}
