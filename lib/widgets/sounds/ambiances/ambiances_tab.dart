import 'package:flutter/material.dart';

import '../../../json/levels/sounds/ambiance_reference.dart';
import '../../../screens/sounds/ambiances/edit_ambiance.dart';
import '../../../src/project_context.dart';
import '../../center_text.dart';
import '../../push_widget_list_tile.dart';

/// A widget that displays a list of [ambiances].
class AmbiancesTab extends StatefulWidget {
  /// Create an instance.
  const AmbiancesTab({
    required this.projectContext,
    required this.ambiances,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The ambiances to display.
  final List<AmbianceReference> ambiances;

  /// Create state for this widget.
  @override
  AmbiancesTabState createState() => AmbiancesTabState();
}

/// State for [AmbiancesTab].
class AmbiancesTabState extends State<AmbiancesTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final ambiances = widget.ambiances;
    if (ambiances.isEmpty) {
      return const CenterText(text: 'There are no ambiances to show.');
    }
    final project = widget.projectContext.project;
    return ListView.builder(
      itemBuilder: (final context, final index) {
        final ambiance = ambiances[index];
        final assetReference = project.getPretendAssetReference(ambiance.sound);
        final coordinates = ambiance.coordinates;
        return PushWidgetListTile(
          title: project.getAssetString(assetReference),
          builder: (final context) => EditAmbiance(
            projectContext: widget.projectContext,
            ambiances: widget.ambiances,
            value: ambiance,
          ),
          autofocus: index == 0,
          onSetState: () => setState(() {}),
          subtitle: coordinates == null
              ? 'Centre'
              : '${coordinates.x}, ${coordinates.y}',
        );
      },
      itemCount: ambiances.length,
    );
  }
}
