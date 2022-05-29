import 'package:flutter/material.dart';

import '../../json/levels/functions/function_reference.dart';
import '../../json/levels/level_reference.dart';
import '../../json/levels/menus/menu_reference.dart';
import '../../screens/levels/functions/edit_function_reference.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../center_text.dart';
import '../project_context_state.dart';
import '../searchable_list_view.dart';
import 'function_reference_list_tile.dart';

/// A widget that shows the functions for the given [levelReference].
class FunctionsList extends StatefulWidget {
  /// Create an instance.
  const FunctionsList({
    required this.projectContext,
    required this.levelReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The level to get functions from.
  final LevelReference levelReference;

  /// Create state for this widget.
  @override
  FunctionsListState createState() => FunctionsListState();
}

/// State for [FunctionsList].
class FunctionsListState extends ProjectContextState<FunctionsList> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final functions = widget.levelReference.functions;
    final Widget child;
    if (functions.isEmpty) {
      child = const CenterText(
        text: 'There are no functions to show.',
      );
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < functions.length; i++) {
        final functionReference = functions[i];
        children.add(
          SearchableListTile(
            searchString: functionReference.name,
            child: FunctionReferenceListTile(
              projectContext: projectContext,
              levelReference: widget.levelReference,
              value: functionReference,
              onDelete: () => setState(() {}),
              autofocus: i == 0,
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return CallbackShortcuts(
      bindings: {
        newShortcut: () => createFunctionReference(
              context: context,
              projectContext: projectContext,
              levelReference: widget.levelReference,
              onDone: () => setState(() {}),
            )
      },
      child: child,
    );
  }
}

/// Create a new function reference.
Future<void> createFunctionReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final LevelReference levelReference,
  required final VoidCallback onDone,
}) async {
  final functionReference = FunctionReference(
    name: 'function${levelReference.functions.length + 1}',
    comment: 'A new function which must be commented.',
  );
  levelReference.functions.add(functionReference);
  projectContext.save();
  await pushWidget(
    context: context,
    builder: (final context) => EditFunctionReference(
      projectContext: projectContext,
      levelReference: levelReference,
      value: functionReference,
    ),
  );
  onDone();
}

/// Delete the given [functionReference] from the given [LevelReference].
Future<void> deleteFunctionReference({
  required final BuildContext context,
  required final ProjectContext projectContext,
  required final LevelReference levelReference,
  required final FunctionReference functionReference,
  required final VoidCallback onYes,
}) {
  final functionName = functionReference.name;
  for (final commandReference in levelReference.commands) {
    for (final callFunction in [
      commandReference.startFunction,
      commandReference.stopFunction,
      commandReference.undoFunction
    ]) {
      if (callFunction?.functionName == functionName) {
        return showMessage(
          context: context,
          message: 'This function is used by 1 or more commands.',
        );
      }
    }
  }
  if (levelReference is MenuReference) {
    for (final menuItem in levelReference.menuItems) {
      if (menuItem.callFunction?.functionName == functionName) {
        return showMessage(
          context: context,
          message: 'This function is used by 1 or more menu items.',
        );
      }
    }
  }
  return confirm(
    context: context,
    message: 'Are you sure you want to delete this function?',
    title: 'Delete Function',
    yesCallback: () {
      Navigator.pop(context);
      levelReference.functions.removeWhere(
        (final element) => element.name == functionName,
      );
      onYes();
    },
  );
}
