import 'package:flutter/material.dart';
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../json/coordinates.dart';
import '../screens/edit_coordinates.dart';
import '../shortcuts.dart';
import '../src/project_context.dart';
import 'push_widget_list_tile.dart';

/// A list tile that shows the given coordinates [value].
class CoordinatesListTile extends StatefulWidget {
  /// Create an instance.
  const CoordinatesListTile({
    required this.projectContext,
    required this.value,
    required this.onChanged,
    this.title = 'Coordinates',
    this.autofocus = false,
    this.nullable = true,
    this.includeZ = false,
    this.assetReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The coordinates to edit.
  final Coordinates? value;

  /// The function to call when [value] changes.
  final ValueChanged<Coordinates?> onChanged;

  /// The title of the resulting [ListTile].
  final String title;

  /// Whether the resulting [ListTile] should be autofocused.
  final bool autofocus;

  /// Whether or not [value] can be set to `null`.
  final bool nullable;

  /// Whether or not to include the z coordinate.
  final bool includeZ;

  /// The asset reference to play.
  final AssetReference? assetReference;

  @override
  State<CoordinatesListTile> createState() => _CoordinatesListTileState();
}

class _CoordinatesListTileState extends State<CoordinatesListTile> {
  SoundChannel? _soundChannel;
  PlaySound? _playSound;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final coordinates = widget.value;
    final String subtitle;
    if (coordinates == null) {
      subtitle = notSet;
    } else {
      final stringBuffer = StringBuffer()
        ..write('${coordinates.x}, ${coordinates.y}');
      if (widget.includeZ) {
        stringBuffer.write(', ${coordinates.z}');
      }
      subtitle = stringBuffer.toString();
    }
    return Semantics(
      onDidGainAccessibilityFocus: () {
        final sound = widget.assetReference;
        if (coordinates != null && sound != null) {
          var soundChannel = _soundChannel;
          final position = SoundPosition3d(
            x: coordinates.x,
            y: coordinates.y,
            z: coordinates.z,
          );
          if (soundChannel == null) {
            soundChannel = widget.projectContext.game
                .createSoundChannel(position: position);
            _soundChannel = soundChannel;
          } else {
            soundChannel.position = position;
          }
          _playSound?.destroy();
          _playSound = soundChannel.playSound(sound, keepAlive: true);
        }
      },
      onDidLoseAccessibilityFocus: () {
        _playSound?.destroy();
        _playSound = null;
      },
      child: CallbackShortcuts(
        bindings: {
          deleteShortcut: () {
            if (widget.nullable) {
              widget.onChanged(null);
            }
          }
        },
        child: PushWidgetListTile(
          autofocus: widget.autofocus,
          title: widget.title,
          subtitle: subtitle,
          builder: (final context) => EditCoordinates(
            projectContext: widget.projectContext,
            value: coordinates ?? Coordinates(0, 0, 0),
            onChanged: widget.onChanged,
            nullable: widget.nullable,
            includeZ: widget.includeZ,
            assetReference: widget.assetReference,
          ),
        ),
      ),
    );
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _soundChannel?.destroy();
    _soundChannel = null;
    _playSound?.destroy();
    _playSound = null;
  }
}
