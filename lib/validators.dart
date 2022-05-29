/// Provides validators.
import 'dart:io';

import 'json/asset_stores/asset_store_reference.dart';
import 'json/project.dart';

const _emptyMessage = 'You must supply a value';
final _variableRegExp = RegExp(r'^[a-z][A-Za-z0-9]*$');
final _classNameRegExp = RegExp(r'^[A-Z][a-zA-Z0-9]*$');
final _dartFileRegExp = RegExp(r'^[a-z][a-z0-9_]*\.dart$');

/// Returns [message] if [value] is `null` or empty.
String? validateNonEmptyValue({
  required final String? value,
  final String message = _emptyMessage,
}) {
  if (value == null || value.isEmpty) {
    return message;
  }
  return null;
}

/// Ensure the given [value] is a path.
String? validatePath({
  required final String? value,
  final bool allowDirectories = true,
  final String emptyMessage = 'You must provide a file or folder to import',
  final String invalidPathMessage = 'Not a file or folder',
}) {
  if (value == null || value.isEmpty) {
    return emptyMessage;
  }
  final file = File(value);
  if (file.existsSync()) {
    return null;
  }
  if (allowDirectories) {
    final directory = Directory(value);
    if (directory.existsSync()) {
      return null;
    }
  }
  return invalidPathMessage;
}

/// Ensure the given [value] is an integer.
String? validateInt({
  required final String? value,
  final String emptyMessage = _emptyMessage,
  final String message = 'Invalid number',
}) {
  if (value == null || value.isEmpty) {
    return emptyMessage;
  } else if (int.tryParse(value) == null) {
    return message;
  }
  return null;
}

/// Validate the [value] is not contained in [values].
String? validateNonDuplicateValue({
  required final String? value,
  required final Iterable<String> values,
  required final String message,
}) {
  if (values.contains(value)) {
    return message;
  }
  return null;
}

/// Validate a variable name.
String? validateVariableName({
  required final String? value,
  required final Iterable<String> variableNames,
  final String emptyMessage = 'You must supply a value',
  final String invalidMessage = 'Invalid variable name',
  final String duplicateMessage = 'That variable name has already been used',
}) {
  if (value == null || value.isEmpty) {
    return emptyMessage;
  }
  if (_variableRegExp.firstMatch(value) == null) {
    return invalidMessage;
  }
  return validateNonDuplicateValue(
    value: value,
    values: variableNames,
    message: duplicateMessage,
  );
}

/// Validate a class name.
///
/// If [classNames] is not `null`, and [value] is found in it,
/// [duplicateMessage] will be returned.
String? validateClassName({
  required final String? value,
  required final Iterable<String> classNames,
  final String emptyMessage = _emptyMessage,
  final String invalidMessage = 'Invalid class name',
  final String duplicateMessage = 'That class name has already been used',
}) {
  if (value == null || value.isEmpty) {
    return emptyMessage;
  }
  if (_classNameRegExp.firstMatch(value) == null) {
    return invalidMessage;
  }
  return validateNonDuplicateValue(
    value: value,
    values: classNames,
    message: duplicateMessage,
  );
}

/// Validate a dart file name.
String? validateDartFilename({
  required final String? value,
  final String emptyMessage = _emptyMessage,
  final String message = 'Invalid dart filename',
}) {
  if (value == null || value.isEmpty) {
    return emptyMessage;
  } else if (_dartFileRegExp.firstMatch(value) == null) {
    return message;
  }
  return null;
}

/// Validate an asset store dart filename.
///
/// This validator ensures that [value] is not only a valid dart filename, but
/// also hasn't been used for any other asset stores in the given [project].
String? validateAssetStoreDartFilename({
  required final String? value,
  required final Project project,
  final String emptyMessage = _emptyMessage,
  final String duplicateMessage =
      'There is already an asset store with that name',
}) {
  final result = validateDartFilename(
    value: value,
    emptyMessage: emptyMessage,
  );
  if (result != null) {
    return result;
  }
  return validateNonDuplicateValue(
    value: value,
    values: project.assetStores.map<String>(
      (final e) => e.dartFilename,
    ),
    message: duplicateMessage,
  );
}

/// Validate [value] as a variable name in the context of [assetStoreReference].
String? validateAssetStoreVariableName({
  required final String? value,
  required final AssetStoreReference assetStoreReference,
  final String emptyMessage = _emptyMessage,
  final String duplicateMessage = 'That variable name has already been used',
}) =>
    validateVariableName(
      value: value,
      variableNames: assetStoreReference.assets.map<String>(
        (final e) => e.variableName,
      ),
      emptyMessage: emptyMessage,
      duplicateMessage: 'There is already an assets with that variable name',
    );
