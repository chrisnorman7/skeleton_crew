import 'package:flutter/material.dart';

import '../json/message_reference.dart';
import '../src/project_context.dart';
import '../widgets/cancel.dart';
import '../widgets/project_context_state.dart';
import '../widgets/simple_scaffold.dart';
import '../widgets/sounds/sound_list_tile.dart';
import '../widgets/text_list_tile.dart';

/// Edit the given [messageReference].
class EditMessageReference extends StatefulWidget {
  /// Create an instance.
  const EditMessageReference({
    required this.projectContext,
    required this.messageReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The message to edit.
  final MessageReference messageReference;

  /// Create state for this widget.
  @override
  EditMessageReferenceState createState() => EditMessageReferenceState();
}

/// State for [EditMessageReference].
class EditMessageReferenceState
    extends ProjectContextState<EditMessageReference> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final message = widget.messageReference;
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Message',
        body: ListView(
          children: [
            TextListTile(
              value: message.text ?? '',
              onChanged: (final value) {
                message.text = value.isEmpty ? null : value;
                save();
              },
              header: 'Text',
              autofocus: true,
            ),
            SoundListTile(
              projectContext: projectContext,
              value: message.soundReference,
              onChanged: (final value) {
                message.soundReference = value;
                save();
              },
            )
          ],
        ),
      ),
    );
  }
}
