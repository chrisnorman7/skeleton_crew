import 'package:flutter/material.dart';

import '../constants.dart';
import '../json/coordinates.dart';
import '../screens/edit_coordinates.dart';
import '../shortcuts.dart';
import 'push_widget_list_tile.dart';

/// A list tile that shows the given coordinates [value].
class CoordinatesListTile extends StatelessWidget {
  /// Create an instance.
  const CoordinatesListTile({
    required this.value,
    required this.onChanged,
    this.title = 'Coordinates',
    this.autofocus = false,
    this.nullable = true,
    this.includeZ = false,
    super.key,
  });

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

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final coordinates = value;
    final String subtitle;
    if (coordinates == null) {
      subtitle = notSet;
    } else {
      final stringBuffer = StringBuffer()
        ..write('${coordinates.x}, ${coordinates.y}');
      if (includeZ) {
        stringBuffer.write(', ${coordinates.z}');
      }
      subtitle = stringBuffer.toString();
    }
    return CallbackShortcuts(
      bindings: {
        deleteShortcut: () {
          if (nullable) {
            onChanged(null);
          }
        }
      },
      child: PushWidgetListTile(
        autofocus: autofocus,
        title: title,
        subtitle: subtitle,
        builder: (final context) => EditCoordinates(
          value: coordinates ?? Coordinates(0, 0, 0),
          onChanged: onChanged,
          nullable: nullable,
        ),
      ),
    );
  }
}
