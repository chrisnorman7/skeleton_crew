import 'package:flutter/material.dart';

import '../constants.dart';
import '../json/levels/function_reference.dart';
import '../screens/levels/edit_function_reference.dart';
import 'push_widget_list_tile.dart';

/// A list tile that shows a function reference [value].
class FunctionReferenceListTile extends StatelessWidget {
  /// Create an instance.
  const FunctionReferenceListTile({
    required this.value,
    required this.onChanged,
    this.title = 'Function',
    this.autofocus = false,
    super.key,
  });

  /// The value to use.
  final FunctionReference? value;

  /// The function to call when [value] changes.
  final ValueChanged<FunctionReference?> onChanged;

  /// The title for the resulting [ListTile].
  final String title;

  /// Whether or not the resulting [ListTile] should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final functionReference = value;
    return PushWidgetListTile(
      title: title,
      builder: (final context) {
        if (functionReference == null) {
          final reference = FunctionReference(name: 'newFunction');
          return EditFunctionReference(
            value: reference,
            onChanged: onChanged,
          );
        } else {
          return EditFunctionReference(
            value: functionReference,
            onChanged: onChanged,
          );
        }
      },
      autofocus: autofocus,
      subtitle: functionReference == null
          ? notSet
          : '${functionReference.name}: ${functionReference.comment}',
    );
  }
}
