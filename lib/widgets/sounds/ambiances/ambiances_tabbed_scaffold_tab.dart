import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/sounds/ambiance_reference.dart';
import '../../../json/levels/sounds/sound_reference.dart';
import '../../../screens/sounds/ambiances/edit_ambiance.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../tabbed_scaffold.dart';
import 'ambiances_list.dart';

/// A tab that allows the editing of ambiances.
class AmbiancesTabbedScaffoldTab extends TabbedScaffoldTab {
  /// Create an instance.
  AmbiancesTabbedScaffoldTab({
    required final BuildContext context,
    required final ProjectContext projectContext,
    required final List<AmbianceReference> ambiances,
    required final VoidCallback onDone,
  }) : super(
          title: 'Ambiances',
          icon: ambiancesIcon,
          builder: (final context) => AmbiancesList(
            projectContext: projectContext,
            ambiances: ambiances,
          ),
          floatingActionButton: FloatingActionButton(
            autofocus: ambiances.isEmpty,
            child: addIcon,
            onPressed: () => createAmbiance(
              context: context,
              projectContext: projectContext,
              ambiances: ambiances,
              onDone: onDone,
            ),
            tooltip: 'Add Ambiance',
          ),
        );
}

/// Add a new ambiance.
Future<void> createAmbiance({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final List<AmbianceReference> ambiances,
  required final VoidCallback onDone,
}) =>
    selectAsset(
      context: context,
      projectContext: projectContext,
      onDone: (final value) async {
        if (value == null) {
          return;
        }
        final ambiance = AmbianceReference(
          id: newId(),
          sound: SoundReference(
            assetStoreId: value.assetStoreId,
            assetReferenceId: value.id,
          ),
        );
        ambiances.add(ambiance);
        projectContext.save();
        await pushWidget(
          context: context,
          builder: (final context) => EditAmbiance(
            projectContext: projectContext,
            ambiances: ambiances,
            value: ambiance,
          ),
        );
        onDone();
      },
    );
