import 'package:flutter/material.dart';

import '../src/project_context.dart';

/// A state with a [save] method.
abstract class ProjectContextState<T extends StatefulWidget> extends State<T> {
  /// The project context to [save].
  late final ProjectContext projectContext;

  /// Save the [projectContext].
  void save() {
    projectContext.save();
    setState(() {});
  }
}
