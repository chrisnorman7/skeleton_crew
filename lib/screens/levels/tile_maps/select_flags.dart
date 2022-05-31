import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/tile_maps/tile_flag.dart';
import '../../../widgets/cancel.dart';
import '../../../widgets/simple_scaffold.dart';

/// A widget for selecting multiple tile map flags.
class SelectFlags extends StatefulWidget {
  /// Create an instance.
  const SelectFlags({
    required this.flags,
    required this.value,
    required this.onChanged,
    required this.nullable,
    super.key,
  });

  /// The flags to choose from.
  final List<TileMapFlag> flags;

  /// The current flags.
  final List<TileMapFlag> value;

  /// The function to call when [value] changes.
  final ValueChanged<List<TileMapFlag>?> onChanged;

  /// Whether or not [value] can be cleared.
  final bool nullable;

  /// Create state for this widget.
  @override
  SelectFlagsState createState() => SelectFlagsState();
}

/// State for [SelectFlags].
class SelectFlagsState extends State<SelectFlags> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final currentFlags = widget.value;
    final flags = widget.flags;
    final flagIds = currentFlags.map<String>(
      (final e) => e.id,
    );
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
        title: 'Select Flags',
        body: ListView.builder(
          itemBuilder: (final context, final index) {
            final flag = flags[index];
            final active = flagIds.contains(flag.id);
            return ListTile(
              onTap: () {
                if (active) {
                  currentFlags.removeWhere(
                    (final element) => element.id == flag.id,
                  );
                } else {
                  currentFlags.add(flag);
                }
                widget.onChanged(currentFlags);
                setState(() {});
              },
              autofocus: index == 0,
              title: Text(active ? 'Remove' : 'Add'),
              subtitle: Text(flag.variableName),
              selected: active,
            );
          },
          itemCount: flags.length,
        ),
      ),
    );
  }
}
