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
import 'ambiances_tabbed_scaffold_tab.dart';

/// A widget that displays a list of [ambiances].
class AmbiancesList extends StatefulWidget {
  /// Create an instance.
  const AmbiancesList({
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
  AmbiancesListState createState() => AmbiancesListState();
}

/// State for [AmbiancesList].
class AmbiancesListState extends ProjectContextState<AmbiancesList> {
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
    final Widget child;
    if (ambiances.isEmpty) {
      child = const CenterText(text: 'There are no ambiances to show.');
    } else {
      final project = projectContext.project;
      child = ListView.builder(
        itemBuilder: (final context, final index) {
          final ambiance = ambiances[index];
          final assetReference = project.getPretendAssetReference(
            ambiance.sound,
          );
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
    return CallbackShortcuts(
      bindings: {
        newShortcut: () => createAmbiance(
              context: context,
              projectContext: projectContext,
              ambiances: ambiances,
              onDone: () => setState(() {}),
            )
      },
      child: child,
    );
  }
}

/// Delete the given [AmbianceReference] from the list of [ambiances].
Future<void> deleteAmbiance({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final List<AmbianceReference> ambiances,
  required final AmbianceReference ambianceReference,
  required final VoidCallback onYes,
}) =>
    confirm(
      context: context,
      message: 'Are you sure you want to delete this ambiance?',
      yesCallback: () {
        Navigator.pop(context);
        ambiances.removeWhere(
          (final element) => element.id == ambianceReference.id,
        );
        projectContext.save();
        onYes();
      },
      title: 'Delete Ambiance',
    );
