import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/sounds/dialogue_level_reference.dart';
import '../../../json/message_reference.dart';
import '../../../shortcuts.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/center_text.dart';
import '../../../widgets/functions/functions_tabbed_scaffold_tab.dart';
import '../../../widgets/level_commands/call_function_list_tile.dart';
import '../../../widgets/level_commands/level_commands_tabbed_scaffold_tab.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/push_widget_list_tile.dart';
import '../../../widgets/sounds/ambiances/ambiances_tabbed_scaffold_tab.dart';
import '../../../widgets/sounds/play_sound_semantics.dart';
import '../../../widgets/tabbed_scaffold.dart';
import '../../edit_message_reference.dart';
import '../levels/edit_level_reference.dart';
import 'dialogue_level_references_list.dart';

/// A widget for editing the given [dialogueLevelReference].
class EditDialogueLevelReference extends StatefulWidget {
  /// Create an instance.
  const EditDialogueLevelReference({
    required this.projectContext,
    required this.dialogueLevelReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The dialogue level to edit.
  final DialogueLevelReference dialogueLevelReference;

  /// Create state for this widget.
  @override
  EditDialogueLevelReferenceState createState() =>
      EditDialogueLevelReferenceState();
}

/// State for [EditDialogueLevelReference].
class EditDialogueLevelReferenceState
    extends ProjectContextState<EditDialogueLevelReference> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final level = widget.dialogueLevelReference;
    final messages = level.messages;
    return Cancel(
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            actions: [
              ElevatedButton(
                onPressed: () => deleteDialogueLevelReference(
                  context: context,
                  projectContext: projectContext,
                  dialogueLevelReference: level,
                  onYes: () => Navigator.pop(context),
                ),
                child: deleteIcon,
              )
            ],
            title: 'Settings',
            icon: const Icon(Icons.settings),
            builder: (final context) => ListView(
              children: [
                ...getLevelReferenceListTiles(
                  projectContext: projectContext,
                  levelReference: level,
                  levels: projectContext.project.dialogueLevels,
                  onSave: () => setState(() {}),
                ),
                CallFunctionListTile(
                  projectContext: projectContext,
                  levelReference: level,
                  value: level.onDoneFunction,
                  onChanged: (final value) {
                    save();
                  },
                  title: 'On Done Function',
                )
              ],
            ),
          ),
          TabbedScaffoldTab(
            title: 'Messages',
            icon: const Icon(Icons.message),
            builder: (final context) {
              final Widget child;
              if (messages.isEmpty) {
                child = const CenterText(
                  text: 'There are no messages to show.',
                );
              } else {
                child = ListView.builder(
                  itemBuilder: (final context, final index) {
                    final message = messages[index];
                    final sound = message.soundReference;
                    final assetReference = sound == null
                        ? null
                        : projectContext.project
                            .getPretendAssetReference(sound)
                            .assetReferenceReference
                            .reference;
                    return CallbackShortcuts(
                      bindings: {
                        deleteShortcut: () => deleteMessageReference(
                              context: context,
                              projectContext: projectContext,
                              messages: messages,
                              messageReference: message,
                              onYes: () => setState(() {}),
                            ),
                        moveDownShortcut: () => moveMessageReference(
                              index,
                              index + 1,
                            ),
                        moveUpShortcut: () =>
                            moveMessageReference(index, index - 1)
                      },
                      child: PlaySoundSemantics(
                        child: PushWidgetListTile(
                          title: '${message.text}',
                          builder: (final context) => EditMessageReference(
                            projectContext: projectContext,
                            messageReference: message,
                          ),
                        ),
                        game: projectContext.game,
                        assetReference: assetReference,
                        gain: sound?.gain ?? 1.0,
                      ),
                    );
                  },
                  itemCount: messages.length,
                );
              }
              return CallbackShortcuts(
                bindings: {
                  newShortcut: () => createDialogueLevelReferenceMessage(
                        context: context,
                        projectContext: projectContext,
                        dialogueLevelReference: level,
                        onDone: () => setState(() {}),
                      )
                },
                child: child,
              );
            },
            floatingActionButton: FloatingActionButton(
              autofocus: messages.isEmpty,
              child: addIcon,
              onPressed: () => createDialogueLevelReferenceMessage(
                context: context,
                projectContext: projectContext,
                dialogueLevelReference: level,
                onDone: () => setState(() {}),
              ),
              tooltip: 'Add Message',
            ),
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

  /// Move the [MessageReference] from the [oldIndex] to the [newIndex].
  void moveMessageReference(final int oldIndex, final int newIndex) {
    if (newIndex < 0) {
      return;
    }
    final messages = widget.dialogueLevelReference.messages;
    final message = messages.removeAt(oldIndex);
    if (newIndex >= messages.length) {
      messages.add(message);
    } else {
      messages.insert(newIndex, message);
    }
    save();
  }
}

/// Create a new dialogue message.
Future<void> createDialogueLevelReferenceMessage({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final DialogueLevelReference dialogueLevelReference,
  required final VoidCallback onDone,
}) async {
  final message = MessageReference(id: newId());
  dialogueLevelReference.messages.add(message);
  projectContext.save();
  await pushWidget(
    context: context,
    builder: (final context) => EditMessageReference(
      projectContext: projectContext,
      messageReference: message,
    ),
  );
  onDone();
}

/// Delete the given [messageReference] from the given list of [messages].
Future<void> deleteMessageReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final List<MessageReference> messages,
  required final MessageReference messageReference,
  required final VoidCallback onYes,
}) =>
    confirm(
      context: context,
      message: 'Are you sure you want to delete this message?',
      title: 'Delete Message',
      yesCallback: () {
        Navigator.pop(context);
        messages.removeWhere(
          (final element) => element.id == messageReference.id,
        );
        projectContext.save();
        onYes();
      },
    );
