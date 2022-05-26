import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/ziggurat.dart';

import '../src/generated_code.dart';
import '../src/project_context.dart';
import '../util.dart';

part 'command_trigger_reference.g.dart';

/// A reference to a [commandTrigger].
@JsonSerializable()
class CommandTriggerReference {
  /// Create an instance.
  CommandTriggerReference({
    required this.id,
    required this.variableName,
    required this.commandTrigger,
    this.comment,
  });

  /// Create an instance from a JSON object.
  factory CommandTriggerReference.fromJson(final Map<String, dynamic> json) =>
      _$CommandTriggerReferenceFromJson(json);

  /// The ID to use.
  final String id;

  /// The variable name to use.
  String variableName;

  /// The comment to use.
  ///
  /// If this value is `null`, then the `description` from the [commandTrigger]
  /// will be used.
  String? comment;

  /// The command trigger this reference references.
  CommandTrigger commandTrigger;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$CommandTriggerReferenceToJson(this);

  /// Get code for this instance.
  GeneratedCode getCode(final ProjectContext projectContext) {
    final imports = {
      'package:dart_sdl/dart_sdl.dart',
      'package:ziggurat/ziggurat.dart'
    };
    final button = commandTrigger.button;
    final keyboardKey = commandTrigger.keyboardKey;
    final stringBuffer = StringBuffer()
      ..writeln('/// ${comment ?? commandTrigger.description}')
      ..writeln('const $variableName = CommandTrigger(')
      ..writeln('name: ${getQuotedString(commandTrigger.name)},')
      ..writeln(
        'description: ${getQuotedString(commandTrigger.description)},',
      );
    if (button != null) {
      stringBuffer.writeln('button: $button,');
    }
    if (keyboardKey != null) {
      stringBuffer.writeln(
        'keyboardKey: CommandKeyboardKey(${keyboardKey.scanCode},',
      );
      if (keyboardKey.altKey) {
        stringBuffer.writeln('altKey: ${keyboardKey.altKey},');
      }
      if (keyboardKey.controlKey) {
        stringBuffer.writeln('controlKey: ${keyboardKey.controlKey},');
      }
      if (keyboardKey.shiftKey) {
        stringBuffer.writeln('shiftKey: ${keyboardKey.shiftKey},');
      }
      stringBuffer.writeln('),');
    }
    stringBuffer.writeln(');');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
