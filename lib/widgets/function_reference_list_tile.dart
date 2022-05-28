import 'package:flutter/material.dart';

import '../constants.dart';
import '../json/levels/function_reference.dart';
import '../screens/levels/edit_function_reference.dart';
import '../shortcuts.dart';
import '../src/project_context.dart';
import 'push_widget_list_tile.dart';

/// A list tile that shows a function reference [value].
class FunctionReferenceListTile extends StatelessWidget {
  /// Create an instance.
  const FunctionReferenceListTile({
    required this.projectContext,
    required this.value,
    required this.onChanged,
    this.title = 'Function',
    this.autofocus = false,
    this.nullable = true,
    this.defaultName = 'newFunction',
    this.defaultComment = 'TODO(Someone): Enter a sensible comment.',
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The value to use.
  final FunctionReference? value;

  /// The function to call when [value] changes.
  final ValueChanged<FunctionReference?> onChanged;

  /// The title for the resulting [ListTile].
  final String title;

  /// Whether or not the resulting [ListTile] should be autofocused.
  final bool autofocus;

  /// Whether or not [value] is nullable.
  final bool nullable;

  /// The default function name when [value] is `null`.
  final String defaultName;

  /// The default comment when [value] is `null`.
  final String defaultComment;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final functionReference = value;
    return CallbackShortcuts(
      bindings: {
        deleteShortcut: () {
          if (nullable) {
            onChanged(null);
          }
        }
      },
      child: PushWidgetListTile(
        title: title,
        builder: (final context) {
          if (functionReference == null) {
            final reference = FunctionReference(
              name: defaultName,
              comment: defaultComment,
            );
            return EditFunctionReference(
              projectContext: projectContext,
              value: reference,
              onChanged: onChanged,
            );
          } else {
            return EditFunctionReference(
              projectContext: projectContext,
              value: functionReference,
              onChanged: onChanged,
            );
          }
        },
        autofocus: autofocus,
        subtitle: functionReference == null
            ? notSet
            : '${functionReference.name}: ${functionReference.comment}',
      ),
    );
  }
}
