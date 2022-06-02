import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/sounds/dialogue_level_reference.dart';
import '../../../shortcuts.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/center_text.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/searchable_list_view.dart';
import '../../../widgets/simple_scaffold.dart';
import 'edit_dialogue_level_reference.dart';

/// A widget for editing dialogue levels.
class DialogueLevelReferencesList extends StatefulWidget {
  /// Create an instance.
  const DialogueLevelReferencesList({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  DialogueLevelReferencesListState createState() =>
      DialogueLevelReferencesListState();
}

/// State for [DialogueLevelReferencesList].
class DialogueLevelReferencesListState
    extends State<DialogueLevelReferencesList> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final Widget child;
    final projectContext = widget.projectContext;
    final dialogueLevels = projectContext.project.dialogueLevels;
    if (dialogueLevels.isEmpty) {
      child = const CenterText(text: 'There are no dialogue levels to show.');
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < dialogueLevels.length; i++) {
        final dialogueLevel = dialogueLevels[i];
        children.add(
          SearchableListTile(
            searchString: dialogueLevel.title,
            child: CallbackShortcuts(
              bindings: {
                deleteShortcut: () => deleteDialogueLevelReference(
                      context: context,
                      projectContext: projectContext,
                      dialogueLevelReference: dialogueLevel,
                      onYes: () => setState(() {}),
                    )
              },
              child: PushWidgetListTile(
                autofocus: i == 0,
                builder: (final context) => EditDialogueLevelReference(
                  projectContext: projectContext,
                  dialogueLevelReference: dialogueLevel,
                ),
                title: dialogueLevel.title,
                subtitle: dialogueLevel.className,
                onSetState: () => setState(() {}),
              ),
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return Cancel(
      child: CallbackShortcuts(
        bindings: {
          newShortcut: () => createDialogueLevelReference(
                context: context,
                projectContext: projectContext,
                onDone: () => setState(() {}),
              )
        },
        child: SimpleScaffold(
          title: 'Dialogue Levels',
          body: child,
          floatingActionButton: FloatingActionButton(
            autofocus: dialogueLevels.isEmpty,
            child: addIcon,
            onPressed: () => createDialogueLevelReference(
              context: context,
              projectContext: projectContext,
              onDone: () => setState(() {}),
            ),
            tooltip: 'Add Dialogue Level',
          ),
        ),
      ),
    );
  }
}

/// Create a dialogue level reference.
Future<void> createDialogueLevelReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final VoidCallback onDone,
}) async {
  final level = DialogueLevelReference(
    id: newId(),
    title: 'Untitled Dialogue Level',
  );
  projectContext.project.dialogueLevels.add(level);
  projectContext.save();
  await pushWidget(
    context: context,
    builder: (final context) => EditDialogueLevelReference(
      projectContext: projectContext,
      dialogueLevelReference: level,
    ),
  );
  onDone();
}

/// Delete the given [dialogueLevelReference].
Future<void> deleteDialogueLevelReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final DialogueLevelReference dialogueLevelReference,
  required final VoidCallback onYes,
}) =>
    confirm(
      context: context,
      message: 'Are you sure you want to delete this dialogue level?',
      title: 'Delete Dialogue Level',
      yesCallback: () {
        Navigator.pop(context);
        projectContext.project.dialogueLevels.removeWhere(
          (final element) => element.id == dialogueLevelReference.id,
        );
        onYes();
      },
    );
