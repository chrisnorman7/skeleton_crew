import 'package:flutter/material.dart';

import '../../../../src/project_context.dart';
import '../../../../widgets/center_text.dart';
import '../../../../widgets/searchable_list_view.dart';

/// A widget for editing the tile map level references for the given
/// [projectContext].
class TileMapReferencesList extends StatefulWidget {
  /// Create an instance.
  const TileMapReferencesList({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  TileMapReferencesListState createState() => TileMapReferencesListState();
}

/// State for [TileMapReferencesList].
class TileMapReferencesListState extends State<TileMapReferencesList> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final Widget child;
    final tileMapLevels = widget.projectContext.project.tileMapLevels;
    if (tileMapLevels.isEmpty) {
      child = const CenterText(text: 'There are no tile map levels to show.');
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < tileMapLevels.length; i++) {
        final tileMapLevel = tileMapLevels[i];
        children.add(
          SearchableListTile(searchString: tileMapLevel.title, child: ),
        )
      }
    }
  }
}
