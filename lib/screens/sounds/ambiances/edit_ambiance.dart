import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/sounds/ambiance_reference.dart';
import '../../../src/project_context.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/coordinates_list_tile.dart';
import '../../../widgets/project_context_state.dart';
import '../../../widgets/simple_scaffold.dart';
import '../../../widgets/sounds/ambiances/ambiances_list.dart';
import '../../../widgets/sounds/sound_list_tile.dart';

/// a widget for editing the given ambiance [value].
class EditAmbiance extends StatefulWidget {
  /// Create an instance.
  const EditAmbiance({
    required this.projectContext,
    required this.ambiances,
    required this.value,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The ambiances that [value] comes from.
  final List<AmbianceReference> ambiances;

  /// The ambiance to edit.
  final AmbianceReference value;

  /// Create state for this widget.
  @override
  EditAmbianceState createState() => EditAmbianceState();
}

/// State for [EditAmbiance].
class EditAmbianceState extends ProjectContextState<EditAmbiance> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final ambiance = widget.value;
    final pretendAssetReference =
        widget.projectContext.project.getPretendAssetReference(
      ambiance.sound,
    );
    final assetReference =
        pretendAssetReference.assetReferenceReference.reference;
    return Cancel(
      child: SimpleScaffold(
        actions: [
          ElevatedButton(
            onPressed: () => deleteAmbiance(
              context: context,
              projectContext: projectContext,
              ambiances: widget.ambiances,
              ambianceReference: ambiance,
              onYes: () => setState(() {}),
            ),
            child: deleteIcon,
          )
        ],
        title: 'Edit Ambiance',
        body: ListView(
          children: [
            SoundListTile(
              projectContext: projectContext,
              value: ambiance.sound,
              onChanged: (final value) {
                widget.value.sound
                  ..assetStoreId = value!.assetStoreId
                  ..assetReferenceId = value.assetReferenceId
                  ..gain = value.gain;
                save();
              },
              autofocus: true,
              nullable: false,
            ),
            CoordinatesListTile(
              projectContext: projectContext,
              value: ambiance.coordinates,
              onChanged: (final value) {
                ambiance.coordinates = value;
                save();
              },
              assetReference: assetReference,
            )
          ],
        ),
      ),
    );
  }
}
