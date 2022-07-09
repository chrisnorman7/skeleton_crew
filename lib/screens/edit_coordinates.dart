import 'package:flutter/material.dart';
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart';

import '../constants.dart';
import '../json/coordinates.dart';
import '../src/project_context.dart';
import '../widgets/cancel.dart';
import '../widgets/double_list_tile.dart';
import '../widgets/simple_scaffold.dart';

/// A widget for editing the given coordinates [value].
class EditCoordinates extends StatefulWidget {
  /// Create an instance.
  const EditCoordinates({
    required this.projectContext,
    required this.value,
    required this.onChanged,
    this.nullable = true,
    this.includeZ = false,
    this.assetReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The coordinates to edit.
  final Coordinates value;

  /// The function to call when [value] changes.
  final ValueChanged<Coordinates?> onChanged;

  /// Whether or not [value] can be set to `null`.
  final bool nullable;

  /// Whether or not to include the z coordinate.
  final bool includeZ;

  /// The asset reference to play when changing coordinates.
  final AssetReference? assetReference;

  /// Create state for this widget.
  @override
  EditCoordinatesState createState() => EditCoordinatesState();
}

/// State for [EditCoordinates].
class EditCoordinatesState extends State<EditCoordinates> {
  SoundChannel? _soundChannel;
  Sound? _sound;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final coordinates = widget.value;
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
        title: 'Edit Coordinates',
        body: ListView(
          children: [
            DoubleListTile(
              value: coordinates.x,
              onChanged: (final value) {
                coordinates.x = value;
                save();
              },
              title: 'X',
              autofocus: true,
            ),
            DoubleListTile(
              value: coordinates.y,
              onChanged: (final value) {
                coordinates.y = value;
                save();
              },
              title: 'Y',
            ),
            if (widget.includeZ)
              DoubleListTile(
                value: coordinates.z,
                onChanged: (final value) {
                  coordinates.z = value;
                  save();
                },
                title: 'Z',
              )
          ],
        ),
      ),
    );
  }

  /// Save the new value.
  void save() {
    widget.onChanged(widget.value);
    setState(() {});
    final assetReference = widget.assetReference;
    if (assetReference != null) {
      var soundChannel = _soundChannel;
      final position = SoundPosition3d(
        x: widget.value.x,
        y: widget.value.y,
        z: widget.value.z,
      );
      if (soundChannel == null) {
        soundChannel =
            widget.projectContext.game.createSoundChannel(position: position);
        _soundChannel = soundChannel;
      } else {
        soundChannel.position = position;
      }
      _sound?.destroy();
      _sound = soundChannel.playSound(
        assetReference: assetReference,
        keepAlive: true,
      );
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _soundChannel?.destroy();
    _soundChannel = null;
    _sound?.destroy();
    _sound = null;
  }
}
