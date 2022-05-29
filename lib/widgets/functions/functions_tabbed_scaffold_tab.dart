import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/levels/level_reference.dart';
import '../../src/project_context.dart';
import '../tabbed_scaffold.dart';
import 'functions_list.dart';

/// A tab which allows the editing of level functions.
class FunctionsTabbedScaffoldTab extends TabbedScaffoldTab {
  /// Create an instance.
  FunctionsTabbedScaffoldTab({
    required final BuildContext context,
    required final ProjectContext projectContext,
    required final LevelReference levelReference,
    required final VoidCallback onDone,
  }) : super(
          icon: functionsIcon,
          title: 'Functions',
          builder: (final context) => FunctionsList(
            projectContext: projectContext,
            levelReference: levelReference,
          ),
          floatingActionButton: FloatingActionButton(
            autofocus: levelReference.functions.isEmpty,
            child: addIcon,
            onPressed: () => createFunctionReference(
              context: context,
              projectContext: projectContext,
              levelReference: levelReference,
              onDone: onDone,
            ),
            tooltip: 'Add Function',
          ),
        );
}
