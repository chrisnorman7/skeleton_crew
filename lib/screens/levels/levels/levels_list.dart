import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/level_reference.dart';
import '../../../json/levels/menus/menu_reference.dart';
import '../../../shortcuts.dart';
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
            child: CallbackShortcuts(
              bindings: {
                deleteShortcut: () => deleteLevelReference(
                      context: context,
                      projectContext: projectContext,
                      levelReference: level,
                      onYes: () => setState(() {}),
                    )
              },
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
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return Cancel(
      child: CallbackShortcuts(
        bindings: {newShortcut: () => addLevel(context)},
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

/// Delete the given [levelReference].
Future<void> deleteLevelReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final LevelReference levelReference,
  required final VoidCallback onYes,
}) =>
    confirm(
      context: context,
      message: 'Are you sure you want to delete this level?',
      title: 'Delete Level',
      yesCallback: () {
        Navigator.pop(context);
        final project = projectContext.project;
        final List<LevelReference> levels;
        if (levelReference is MenuReference) {
          levels = project.menus;
        } else {
          levels = project.levels;
        }
        levels.removeWhere(
          (final element) => element.id == levelReference.id,
        );
        projectContext.save();
        onYes();
      },
    );
