import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/tile_maps/tile_flag.dart';
import '../../../shortcuts.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/center_text.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/searchable_list_view.dart';
import '../../../widgets/simple_scaffold.dart';
import 'edit_tile_flag.dart';

/// A widget for viewing and editing tile map flags.
class TileMapFlagsList extends StatefulWidget {
  /// Create an instance.
  const TileMapFlagsList({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  TileMapFlagsListState createState() => TileMapFlagsListState();
}

/// State for [TileMapFlagsList].
class TileMapFlagsListState extends State<TileMapFlagsList> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final projectContext = widget.projectContext;
    final flags = projectContext.project.tileMapFlags;
    final Widget child;
    if (flags.isEmpty) {
      child = const CenterText(text: 'There are no flags to show.');
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < flags.length; i++) {
        final flag = flags[i];
        children.add(
          SearchableListTile(
            searchString: flag.variableName,
            child: PushWidgetListTile(
              autofocus: i == 0,
              builder: (final context) => EditTileMapFlag(
                projectContext: projectContext,
                tileMapFlag: flag,
              ),
              title: flag.variableName,
              subtitle: flag.variableName,
              onSetState: () => setState(() {}),
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return CallbackShortcuts(
      bindings: {
        newShortcut: () => createTileMapFlag(
              context: context,
              projectContext: projectContext,
              onDone: () => setState(() {}),
            )
      },
      child: SimpleScaffold(
        title: 'Tile Flags',
        body: child,
        floatingActionButton: FloatingActionButton(
          autofocus: flags.isEmpty,
          child: addIcon,
          onPressed: () => createTileMapFlag(
            context: context,
            projectContext: projectContext,
            onDone: () => setState(() {}),
          ),
        ),
      ),
    );
  }
}

/// Create a new tile map flag.
Future<void> createTileMapFlag({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final VoidCallback onDone,
}) async {
  final flags = projectContext.project.tileMapFlags;
  final flag = TileMapFlag(
    id: newId(),
    name: 'New Flag',
    variableName: 'flag${flags.length + 1}',
  );
  flags.add(flag);
  projectContext.save();
  await pushWidget(
    context: context,
    builder: (final context) => EditTileMapFlag(
      projectContext: projectContext,
      tileMapFlag: flag,
    ),
  );
  onDone();
}
