import 'package:flutter/material.dart';

import '../../json/levels/sounds/sound_reference.dart';
import '../../screens/sounds/edit_sound.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../play_sound_semantics.dart';

/// A list tile that shows a pretend asset reference [value].
class SoundListTile extends StatelessWidget {
  /// Create an instance.
  const SoundListTile({
    required this.projectContext,
    required this.value,
    required this.onChanged,
    this.title = 'Sound',
    this.autofocus = false,
    this.nullable = true,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The sound to use.
  final SoundReference? value;

  /// The function to call when [value] changes.
  final ValueChanged<SoundReference?> onChanged;

  /// The title for the resulting [ListTile].
  final String title;

  /// Whether the resulting [ListTile] should be autofocused.
  final bool autofocus;

  /// Whether or not [value] should be nullable.
  final bool nullable;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = projectContext.project;
    final sound = value;
    final assetStore =
        sound == null ? null : project.getAssetStore(sound.assetStoreId);
    final assetReference =
        assetStore?.getAssetReference(sound!.assetReferenceId);
    return PlaySoundSemantics(
      soundChannel: projectContext.game.interfaceSounds,
      assetReference: assetReference?.assetReferenceReference.reference,
      gain: sound?.gain ?? 1.0,
      child: Builder(
        builder: (final builderContext) => CallbackShortcuts(
          bindings: {
            deleteShortcut: () {
              PlaySoundSemantics.of(builderContext)?.stop();
              onChanged(null);
            }
          },
          child: ListTile(
            autofocus: autofocus,
            title: Text(title),
            subtitle: Text(
              assetStore == null || assetReference == null
                  ? 'Not Set '
                  : '${assetStore.name}/${assetReference.variableName} (${sound?.gain.toStringAsFixed(2)})',
            ),
            onTap: () {
              PlaySoundSemantics.of(builderContext)?.stop();
              if (sound == null) {
                selectAsset(
                  context: context,
                  projectContext: projectContext,
                  onDone: (final value) => onChanged(
                    value == null
                        ? null
                        : SoundReference(
                            assetStoreId: value.assetStoreId,
                            assetReferenceId: value.id,
                          ),
                  ),
                  assetStoreReference: assetStore,
                  pretendAssetReference: assetReference,
                );
              } else {
                pushWidget(
                  context: context,
                  builder: (final context) => EditSound(
                    projectContext: projectContext,
                    value: sound,
                    onChanged: onChanged,
                  ),
                );
              }
            },
            onLongPress: () => onChanged(null),
          ),
        ),
      ),
    );
  }
}
