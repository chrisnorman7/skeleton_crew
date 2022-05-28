import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../json/levels/sounds/ambiance_reference.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../../tabbed_scaffold.dart';
import 'ambiances_tab.dart';

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
          builder: (final context) => AmbiancesTab(
            projectContext: projectContext,
            ambiances: ambiances,
          ),
          floatingActionButton: FloatingActionButton(
            autofocus: ambiances.isEmpty,
            child: addIcon,
            onPressed: () => addAmbiance(
              context: context,
              projectContext: projectContext,
              ambiances: ambiances,
              onDone: onDone,
            ),
            tooltip: 'Add Ambiance',
          ),
        );
}
