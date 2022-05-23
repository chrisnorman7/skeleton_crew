import 'package:flutter/material.dart';

import '../../screens/levels/menus/menus_list.dart';
import '../../src/project_context.dart';
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
class LevelsTabState extends State<LevelsTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = widget.projectContext.project;
    final menus = project.menus;
    return ListView(
      children: [
        PushWidgetListTile(
          title: 'Menus',
          builder: (final context) => MenusList(
            projectContext: widget.projectContext,
          ),
          autofocus: true,
          onSetState: () => setState(() {}),
          subtitle: '${menus.length}',
        )
      ],
    );
  }
}
