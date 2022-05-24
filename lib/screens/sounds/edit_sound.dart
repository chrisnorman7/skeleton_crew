import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/levels/sounds/sound_reference.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../../widgets/cancel.dart';
import '../../widgets/simple_scaffold.dart';
import '../../widgets/sounds/gain_list_tile.dart';

/// A widget to edit the given sound [value].
class EditSound extends StatefulWidget {
  /// Create an instance.
  const EditSound({
    required this.projectContext,
    required this.value,
    required this.onChanged,
    this.nullable = true,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The sound to edit.
  final SoundReference value;

  /// The function to call when [value] changes.
  final ValueChanged<SoundReference?> onChanged;

  /// Whether or not [value] can be set to `null`.
  final bool nullable;

  /// Create state for this widget.
  @override
  EditSoundState createState() => EditSoundState();
}

/// State for [EditSound].
class EditSoundState extends State<EditSound> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final sound = widget.value;
    final assetStore =
        widget.projectContext.project.getAssetStore(sound.assetStoreId);
    final assetReference = assetStore.getAssetReference(sound.assetReferenceId);
    return Cancel(
      child: SimpleScaffold(
        actions: [
          if (widget.nullable)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onChanged(null);
              },
              child: deleteIcon,
            )
        ],
        title: 'Edit Sound',
        body: ListView(
          children: [
            ListTile(
              autofocus: true,
              title: const Text('Asset'),
              subtitle:
                  Text('${assetStore.name}/${assetReference.variableName}'),
              onTap: () => selectAsset(
                context: context,
                projectContext: widget.projectContext,
                onDone: (final value) {
                  if (value == null) {
                    widget.onChanged(null);
                  } else {
                    sound
                      ..assetStoreId = value.assetStoreId
                      ..assetReferenceId = value.id;
                    widget.onChanged(sound);
                  }
                  setState(() {});
                },
              ),
            ),
            GainListTile(
              value: sound.gain,
              onChanged: (final value) {
                sound.gain = value;
                save();
              },
            )
          ],
        ),
      ),
    );
  }

  /// Save the sound.
  void save() {
    widget.onChanged(widget.value);
    setState(() {});
  }
}
