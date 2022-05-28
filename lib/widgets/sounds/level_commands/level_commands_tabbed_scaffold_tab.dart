import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/level_command_reference.dart';
import '../../tabbed_scaffold.dart';

/// A tab that allows the editing of level commands.
class LevelCommandsTabbedScaffoldTab extends TabbedScaffoldTab {
  /// Create an instance.
  LevelCommandsTabbedScaffoldTab({
    required final List<LevelCommandReference> commands,
  }) : super(
          title: 'Commands',
          icon: commandTriggersIcon,
          builder: (final context) => const Placeholder(),
          floatingActionButton: FloatingActionButton(
            autofocus: commands.isEmpty,
            child: addIcon,
            onPressed: () async {},
          ),
        );
}
