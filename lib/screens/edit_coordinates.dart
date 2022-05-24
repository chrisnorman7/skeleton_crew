import 'package:flutter/material.dart';

import '../constants.dart';
import '../json/coordinates.dart';
import '../widgets/cancel.dart';
import '../widgets/double_list_tile.dart';
import '../widgets/simple_scaffold.dart';

/// A widget for editing the given coordinates [value].
class EditCoordinates extends StatefulWidget {
  /// Create an instance.
  const EditCoordinates({
    required this.value,
    required this.onChanged,
    this.nullable = true,
    this.includeZ = false,
    super.key,
  });

  /// The coordinates to edit.
  final Coordinates value;

  /// The function to call when [value] changes.
  final ValueChanged<Coordinates?> onChanged;

  /// Whether or not [value] can be set to `null`.
  final bool nullable;

  /// Whether or not to include the z coordinate.
  final bool includeZ;

  /// Create state for this widget.
  @override
  EditCoordinatesState createState() => EditCoordinatesState();
}

/// State for [EditCoordinates].
class EditCoordinatesState extends State<EditCoordinates> {
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
  }
}
