import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/asset_stores/asset_store_reference.dart';
import '../../json/asset_stores/pretend_asset_reference.dart';
import '../../json/levels/menus/menu_reference.dart';
import '../../json/levels/tile_maps/tile_map_level_reference.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../../validators.dart';
import '../../widgets/cancel.dart';
import '../../widgets/project_context_state.dart';
import '../../widgets/simple_scaffold.dart';
import '../../widgets/text_list_tile.dart';

/// A widget for editing the given [pretendAssetReference].
class EditPretendAssetReference extends StatefulWidget {
  /// Create an instance.
  const EditPretendAssetReference({
    required this.projectContext,
    required this.assetStoreReference,
    required this.pretendAssetReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The asset store that [pretendAssetReference] is part of.
  final AssetStoreReference assetStoreReference;

  /// The asset reference to edit.
  final PretendAssetReference pretendAssetReference;

  /// Create state for this widget.
  @override
  EditPretendAssetReferenceState createState() =>
      EditPretendAssetReferenceState();
}

/// State for [EditPretendAssetReference].
class EditPretendAssetReferenceState
    extends ProjectContextState<EditPretendAssetReference> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final pretendAssetReference = widget.pretendAssetReference;
    return Cancel(
      child: SimpleScaffold(
        actions: [
          ElevatedButton(
            onPressed: () => deleteAssetReference(
              context: context,
              projectContext: projectContext,
              assetReference: widget.pretendAssetReference,
              onYes: () => Navigator.pop(context),
            ),
            child: deleteIcon,
          )
        ],
        title: 'Edit Asset',
        body: ListView(
          children: [
            TextListTile(
              value: pretendAssetReference.variableName,
              onChanged: (final value) {
                pretendAssetReference.variableName = value;
                save();
              },
              header: 'Variable Name',
              autofocus: true,
              validator: (final value) => validateAssetStoreVariableName(
                value: value,
                assetStoreReference: widget.assetStoreReference,
              ),
            ),
            TextListTile(
              value: pretendAssetReference.comment,
              onChanged: (final value) {
                pretendAssetReference.comment = value;
                save();
              },
              header: 'Comment',
              validator: (final value) => validateNonEmptyValue(value: value),
            ),
            CheckboxListTile(
              value: pretendAssetReference.isAudio,
              onChanged: (final value) {
                pretendAssetReference.isAudio = value ?? false;
                save();
              },
              title: const Text('Audio Asset'),
              subtitle: Text(pretendAssetReference.isAudio ? 'Yes' : 'No'),
            )
          ],
        ),
      ),
    );
  }
}

/// Delete the given [assetReference].
Future<void> deleteAssetReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final PretendAssetReference assetReference,
  final VoidCallback? onYes,
}) {
  final project = projectContext.project;
  const prefix = 'You cannot delete the';
  for (final level in [
    ...project.menus,
    ...project.levels,
    ...project.tileMapLevels
  ]) {
    final String type;
    if (level is MenuReference) {
      type = 'menu';
    } else if (level is TileMapLevelReference) {
      type = 'tile map level';
    } else {
      type = 'level';
    }
    if (level.music?.assetReferenceId == assetReference.id) {
      return showMessage(
        context: context,
        message: '$prefix music for ${level.title}.',
      );
    }
    if (level is MenuReference) {
      for (final menuItem in level.menuItems) {
        if (menuItem.message.soundReference?.assetReferenceId ==
            assetReference.id) {
          return showMessage(
            context: context,
            message:
                '$prefix sound for the "${menuItem.message.text}" item of the '
                '${level.title} menu.',
          );
        }
      }
    }
    for (final ambiance in level.ambiances) {
      final sound = ambiance.sound;
      if (sound.assetStoreId == assetReference.assetStoreId &&
          sound.assetReferenceId == assetReference.id) {
        return showMessage(
          context: context,
          message: '$prefix ${level.title} ambiance.',
        );
      }
    }
    for (final commandReference in level.commands) {
      for (final callFunction in [
        commandReference.startFunction,
        commandReference.stopFunction,
        commandReference.undoFunction
      ]) {
        if (callFunction == null) {
          continue;
        }
        final sound = callFunction.soundReference;
        if (sound?.assetStoreId == assetReference.assetStoreId &&
            sound?.assetReferenceId == assetReference.id) {
          final trigger = project
              .getCommandTrigger(commandReference.commandTriggerId)
              .commandTrigger;
          return showMessage(
            context: context,
            message: '$prefix sound for the ${trigger.name} command of the '
                '${level.title} $type.',
          );
        }
      }
    }
  }
  return confirm(
    context: context,
    message: 'Are you sure you want to delete this asset?',
    yesCallback: () {
      Navigator.pop(context);
      project.getAssetStore(assetReference.assetStoreId).assets.removeWhere(
            (final element) => element.id == assetReference.id,
          );
      if (onYes != null) {
        onYes();
      }
      projectContext.save();
    },
    title: 'Delete Asset',
  );
}
