import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../screens/levels/dialogue_levels/dialogue_level_references_list.dart';
import '../../screens/levels/levels/level_references_list.dart';
import '../../screens/levels/menus/menu_references_list.dart';
import '../../screens/levels/tile_maps/tile_map_levels/tile_map_level_references_list.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../keyboard_shortcuts_list.dart';
import '../push_widget_list_tile.dart';

/// A tab to show level types.
class LevelsTab extends StatefulWidget {
  /// Create an instance.
  const LevelsTab({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  LevelsTabState createState() => LevelsTabState();
}

/// State for [LevelsTab].
class LevelsTabState extends State<LevelsTab> with PushBuilderMixin {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = widget.projectContext.project;
    final menus = project.menus;
    final levels = project.levels;
    final levelsListTile = PushWidgetListTile(
      title: 'Levels',
      builder: (final context) =>
          LevelReferencesList(projectContext: widget.projectContext),
      autofocus: true,
      onSetState: () => setState(() {}),
      subtitle: '${levels.length}',
    );
    final tileMapLevelsListTile = PushWidgetListTile(
      title: 'Tile Map Levels',
      builder: (final context) => TileMapLevelReferencesList(
        projectContext: widget.projectContext,
      ),
      onSetState: () => setState(() {}),
      subtitle: '${project.tileMapLevels.length}',
    );
    final dialogueLevelsListTile = PushWidgetListTile(
      title: 'Dialogue Levels',
      builder: (final context) => DialogueLevelReferencesList(
        projectContext: widget.projectContext,
      ),
      onSetState: () => setState(() {}),
      subtitle: '${project.dialogueLevels.length}',
    );
    final menusListTile = PushWidgetListTile(
      title: 'Menus',
      builder: (final context) => MenuReferencesList(
        projectContext: widget.projectContext,
      ),
      onSetState: () => setState(() {}),
      subtitle: '${menus.length}',
    );
    return WithKeyboardShortcuts(
      keyboardShortcuts: const [
        KeyboardShortcut(
          description: 'Edit levels.',
          keyName: 'L',
          control: true,
        ),
        KeyboardShortcut(
          description: 'Edit tile map levels.',
          keyName: 'T',
          control: true,
        ),
        KeyboardShortcut(
          description: 'Edit dialogue levels.',
          keyName: 'D',
          control: true,
        ),
        KeyboardShortcut(
          description: 'Edit menus.',
          keyName: 'M',
          control: true,
        )
      ],
      child: CallbackShortcuts(
        bindings: {
          SingleActivator(
            LogicalKeyboardKey.keyL,
            control: !macOs,
            meta: macOs,
          ): () => pushBuilder(
                context: context,
                builder: levelsListTile.builder,
              ),
          SingleActivator(
            LogicalKeyboardKey.keyT,
            control: !macOs,
            meta: macOs,
          ): () => pushBuilder(
                context: context,
                builder: tileMapLevelsListTile.builder,
              ),
          SingleActivator(
            LogicalKeyboardKey.keyD,
            control: !macOs,
            meta: macOs,
          ): () => pushBuilder(
                context: context,
                builder: dialogueLevelsListTile.builder,
              ),
          SingleActivator(
            LogicalKeyboardKey.keyM,
            control: !macOs,
            meta: macOs,
          ): () =>
              pushBuilder(context: context, builder: menusListTile.builder),
        },
        child: ListView(
          children: [
            levelsListTile,
            tileMapLevelsListTile,
            dialogueLevelsListTile,
            menusListTile,
          ],
        ),
      ),
    );
  }
}
