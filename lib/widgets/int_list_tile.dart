// ignore_for_file: prefer_final_parameters
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util.dart';
import 'get_text.dart';

/// A list tile to edit the given number [value].
class IntListTile extends StatelessWidget {
  /// Create an instance.
  const IntListTile({
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.min,
    this.max,
    this.modifier = 1,
    this.autofocus = false,
    this.labelText = 'Number',
    super.key,
  });

  /// The number to edit.
  final int value;

  /// The function to call when [value] changes.
  final ValueChanged<int> onChanged;

  /// The title of the resulting [ListTile].
  final String title;

  /// The subtitle for the resulting [ListTile].
  ///
  /// If this value is `null`, then [value] will be used.
  final String? subtitle;

  /// The minimum number for [value].
  final int? min;

  /// The maximum number for [value].
  final int? max;

  /// How much this value can be modified with hotkeys.
  final int modifier;

  /// Whether or not the resulting [ListTile] should be autofocused.
  final bool autofocus;

  /// The label text to use.
  final String labelText;

  @override
  Widget build(final BuildContext context) => CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.minus): () {
            final i = value - modifier;
            if (i >= (min ?? i)) {
              onChanged(i);
            }
          },
          const SingleActivator(
            LogicalKeyboardKey.equal,
          ): () {
            final i = value + modifier;
            if (i <= (max ?? i)) {
              onChanged(i);
            }
          }
        },
        child: ListTile(
          autofocus: autofocus,
          title: Text(title),
          subtitle: Text('${subtitle ?? value}'),
          onTap: () => pushWidget(
            context: context,
            builder: (context) => GetText(
              onDone: (value) {
                Navigator.pop(context);
                onChanged(int.parse(value));
              },
              labelText: labelText,
              text: value.toString(),
              title: title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'You must provide a value';
                }
                final i = int.tryParse(value);
                if (i == null) {
                  return 'Invalid number';
                }
                if (i < (min ?? i)) {
                  return 'You must use a number no less than $min';
                }
                if (i > (max ?? i)) {
                  return 'You must use a number no more than $max';
                }
                return null;
              },
            ),
          ),
        ),
      );
}
