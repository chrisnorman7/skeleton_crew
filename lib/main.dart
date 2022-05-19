// ignore_for_file: prefer_final_parameters
import 'package:flutter/material.dart';

import 'screens/home_page.dart';

void main() => runApp(const MyApp());

/// The main app class.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => MaterialApp(
        title: 'Skeleton Crew',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      );
}
