import 'package:flutter/material.dart';
import 'package:ziggurat/sound.dart';

import '../../../json/levels/sounds/ambiance_reference.dart';
import '../../../screens/sounds/ambiances/edit_ambiance.dart';
import '../../../shortcuts.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../center_text.dart';
import '../../project_context_state.dart';
import '../../push_widget_list_tile.dart';
import '../play_sound_semantics.dart';

/// A widget that displays a list of [ambiances].
class AmbiancesTab extends StatefulWidget {
  /// Create an instance.
  const AmbiancesTab({
    required this.projectContext,
    required this.ambiances,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The ambiances to display.
  final List<AmbianceReference> ambiances;

  /// Create state for this widget.
  @override
  AmbiancesTabState createState() => AmbiancesTabState();
}

/// State for [AmbiancesTab].
class AmbiancesTabState extends ProjectContextState<AmbiancesTab> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final ambiances = widget.ambiances;
    if (ambiances.isEmpty) {
      return const CenterText(text: 'There are no ambiances to show.');
    }
    final project = projectContext.project;
    return ListView.builder(
      itemBuilder: (final context, final index) {
        final ambiance = ambiances[index];
        final assetReference = project.getPretendAssetReference(ambiance.sound);
        final coordinates = ambiance.coordinates;
        final sound = ambiance.sound;
        final soundPosition = ambiance.coordinates;
        return CallbackShortcuts(
          bindings: {
            deleteShortcut: () => deleteAmbiance(
                  context: context,
                  projectContext: widget.projectContext,
                  ambiances: ambiances,
                  ambianceReference: ambiance,
                  onYes: () => setState(() {}),
                )
          },
          child: PlaySoundSemantics(
            game: projectContext.game,
            assetReference: project
                .getPretendAssetReference(sound)
                .assetReferenceReference
                .reference,
            gain: sound.gain,
            looping: true,
            position: soundPosition == null
                ? unpanned
                : SoundPosition3d(
                    x: soundPosition.x,
                    y: soundPosition.y,
                    z: soundPosition.z,
                  ),
            child: Builder(
              builder: (final builderContext) => PushWidgetListTile(
                title: project.getAssetString(assetReference),
                builder: (final context) {
                  PlaySoundSemantics.of(builderContext)?.stop();
                  return EditAmbiance(
                    projectContext: widget.projectContext,
                    ambiances: widget.ambiances,
                    value: ambiance,
                  );
                },
                autofocus: index == 0,
                onSetState: () => setState(() {}),
                subtitle: coordinates == null
                    ? 'Centre'
                    : '${coordinates.x}, ${coordinates.y}',
              ),
            ),
          ),
        );
      },
      itemCount: ambiances.length,
    );
  }
}
