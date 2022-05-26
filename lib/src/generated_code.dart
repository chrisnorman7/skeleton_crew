import '../util.dart';

/// A class to represent generated code.
class GeneratedCode {
  /// Create an instance.
  const GeneratedCode({
    required this.code,
    this.imports = const {},
  });

  /// The list of packages to be imported at the top of the resulting file.
  final Set<String> imports;

  /// The code that has been generated.
  final String code;

  /// Return the imports as code.
  String getImports() {
    final dartImports = imports
        .where(
          (final element) => element.startsWith('dart:'),
        )
        .toList()
      ..sort();
    final packageImports = imports
        .where(
          (final element) => element.startsWith('package:'),
        )
        .toList()
      ..sort();
    final relativeImports = imports
        .where(
          (final element) =>
              dartImports.contains(element) == false &&
              packageImports.contains(element) == false,
        )
        .toList()
      ..sort();
    final importStrings =
        [...dartImports, ...packageImports, ...relativeImports].map<String>(
      (final e) => 'import ${getQuotedString(e)};',
    );
    return importStrings.join('\n');
  }
}
