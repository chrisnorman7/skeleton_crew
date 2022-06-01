import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/tile_maps/tile_map_reference.dart';
import '../../../src/project_context.dart';
import '../../../validators.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/int_list_tile.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/tabbed_scaffold.dart';
import '../../../widgets/text_list_tile.dart';
import 'edit_tile_map_reference_tiles.dart';
import 'select_flags.dart';
import 'tile_map_references_list.dart';

/// A widget for editing the given [tileMapReference].
class EditTileMapReference extends StatefulWidget {
  /// Create an instance.
  const EditTileMapReference({
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
  EditTileMapReferenceState createState() => EditTileMapReferenceState();
}

/// State for [EditTileMapReference].
class EditTileMapReferenceState
    extends ProjectContextState<EditTileMapReference> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = projectContext.project;
    final tileMap = widget.tileMapReference;
    final defaultFlagIds = tileMap.defaultFlagIds;
    return Cancel(
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            title: 'Settings',
            icon: const Icon(Icons.settings),
            builder: (final context) => ListView(
              children: [
                TextListTile(
                  value: tileMap.name,
                  onChanged: (final value) {
                    tileMap.name = value;
                    save();
                  },
                  header: 'Name',
                  autofocus: true,
                  validator: (final value) => validateNonEmptyValue(
                    value: value,
                  ),
                ),
                TextListTile(
                  value: tileMap.variableName,
                  onChanged: (final value) {
                    tileMap.variableName = value;
                    save();
                  },
                  header: 'Variable Name',
                  validator: (final value) => validateVariableName(
                    value: value,
                    variableNames: projectContext.project.tileMaps.map<String>(
                      (final e) => e.variableName,
                    ),
                  ),
                ),
                PushWidgetListTile(
                  title: 'Default Flags',
                  builder: (final context) => SelectFlags(
                    flags: project.tileMapFlags,
                    value: project.getFlags(
                      tileMap.defaultFlagIds,
                    ),
                    onChanged: (final value) {
                      tileMap.defaultFlagIds
                        ..clear()
                        ..addAll(
                          value!.map<String>(
                            (final e) => e.id,
                          ),
                        )
                        ..sort(
                          (final a, final b) =>
                              project.getFlag(a).name.toLowerCase().compareTo(
                                    project.getFlag(b).name.toLowerCase(),
                                  ),
                        );
                      save();
                    },
                    nullable: false,
                  ),
                  onSetState: () => setState(() {}),
                  subtitle: defaultFlagIds.isEmpty
                      ? notSet
                      : defaultFlagIds
                          .map((final e) => project.getFlag(e).name)
                          .join(', '),
                ),
                IntListTile(
                  value: tileMap.width,
                  onChanged: (final value) {
                    tileMap.width = value;
                    save();
                  },
                  title: 'Width',
                  min: 1,
                  modifier: 10,
                ),
                IntListTile(
                  value: tileMap.height,
                  onChanged: (final value) {
                    tileMap.height = value;
                    save();
                  },
                  title: 'Height',
                  min: 1,
                  modifier: 10,
                )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => deleteTileMapReference(
                  context: context,
                  projectContext: projectContext,
                  tileMapReference: tileMap,
                  onYes: () => Navigator.pop(context),
                ),
                child: deleteIcon,
              )
            ],
          ),
          TabbedScaffoldTab(
            title: 'Tiles',
            icon: const Icon(Icons.grid_3x3),
            builder: (final context) => EditTileMapReferenceTiles(
              projectContext: projectContext,
              tileMapReference: tileMap,
            ),
          )
        ],
      ),
    );
  }
}
