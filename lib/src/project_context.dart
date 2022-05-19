import 'dart:convert';
import 'dart:io';

import '../json/project.dart';

const _jsonEncoder = JsonEncoder.withIndent('  ');

/// A reference to a project.
class ProjectContext {
  /// Create an instance.
  const ProjectContext({
    required this.project,
    required this.file,
  });

  /// Load a project from the given [file].
  ProjectContext.fromFile(this.file)
      : project = Project.fromJson(
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
        );

  /// The project that has been loaded.
  final Project project;

  /// The file where [project] resides.
  final File file;

  /// Save the [project] to its [file].
  void save() {
    final json = project.toJson();
    final data = _jsonEncoder.convert(json);
    file.writeAsStringSync(data);
  }
}
