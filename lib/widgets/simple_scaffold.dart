// ignore_for_file: prefer_final_parameters

import 'package:flutter/material.dart';

/// A quicker way to create scaffolds.
class SimpleScaffold extends StatelessWidget {
  /// Create an instance.
  const SimpleScaffold({
    required this.title,
    required this.body,
    this.actions = const [],
    this.floatingActionButton,
    super.key,
  });

  /// App bar actions.
  final List<Widget> actions;

  /// The title of the scaffold.
  final String title;

  /// The body of the scaffold.
  final Widget body;

  /// The floating action button to use.
  final Widget? floatingActionButton;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: actions,
          title: Text(title),
        ),
        body: body,
        floatingActionButton: floatingActionButton,
      );
}
