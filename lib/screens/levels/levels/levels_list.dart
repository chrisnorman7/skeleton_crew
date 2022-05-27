import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/level_reference.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/center_text.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/searchable_list_view.dart';
import '../../../widgets/simple_scaffold.dart';
import 'edit_level.dart';

/// A widget for editing levels.
class EditLevels extends StatefulWidget {
  /// Create an instance.
  const EditLevels({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  EditLevelsState createState() => EditLevelsState();
}

/// State for [EditLevels].
class EditLevelsState extends ProjectContextState<EditLevels> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final Widget child;
    final levels = projectContext.project.levels;
    if (levels.isEmpty) {
      child = const CenterText(text: 'There are no levels to show.');
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < levels.length; i++) {
        final level = levels[i];
        children.add(
          SearchableListTile(
            searchString: level.title,
            child: PushWidgetListTile(
              title: level.title,
              builder: (final context) => EditLevel(
                projectContext: projectContext,
                levelReference: level,
              ),
              autofocus: i == 0,
              onSetState: () => setState(() {}),
              subtitle: '${level.className}: ${level.comment}',
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return Cancel(
      child: SimpleScaffold(
        title: 'Levels',
        body: child,
        floatingActionButton: FloatingActionButton(
          autofocus: levels.isEmpty,
          child: addIcon,
          onPressed: () => addLevel(context),
          tooltip: 'Add Level',
        ),
      ),
    );
  }

  /// Add a new level.
  Future<void> addLevel(final BuildContext context) async {
    final level = LevelReference(
      id: newId(),
      title: 'Untitled Level',
    );
    projectContext.project.levels.add(level);
    projectContext.save();
    await pushWidget(
      context: context,
      builder: (final context) =>
          EditLevel(projectContext: projectContext, levelReference: level),
    );
    setState(() {});
  }
}
