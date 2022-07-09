import 'package:json_annotation/json_annotation.dart';

import '../../../src/generated_code.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../level_reference.dart';
import '../sounds/sound_reference.dart';
import 'function_reference.dart';

part 'call_function.g.dart';

/// A class that represents a function.
///
/// If [functionId] is not `null`, then a [FunctionReference] instance will be
/// called.
@JsonSerializable()
class CallFunction {
  /// Create an instance.
  CallFunction({
    required this.id,
    this.text,
    this.soundReference,
    this.functionId,
  });

  /// Create an instance from a JSON object.
  factory CallFunction.fromJson(final Map<String, dynamic> json) =>
      _$CallFunctionFromJson(json);

  /// The ID of this instance.
  final String id;

  /// Text to output.
  String? text;

  /// A sound to play.
  SoundReference? soundReference;

  /// The ID of the function to call.
  String? functionId;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$CallFunctionToJson(this);

  /// Get code for this instance.
  GeneratedCode getCode(
    final ProjectContext projectContext,
    final LevelReference levelReference,
  ) {
    final message = text;
    final sound = soundReference;
    final functionReferenceId = functionId;
    final function = functionReferenceId == null
        ? null
        : levelReference.getFunctionReference(functionReferenceId);
    final name = function?.name;
    final imports = <String>{'package:ziggurat/ziggurat.dart'};
    final stringBuffer = StringBuffer();
    if (sound == null && message == null) {
      stringBuffer.writeln('$name');
    } else {
      stringBuffer
        ..writeln('() {')
        ..writeln('game.outputMessage(')
        ..writeln('const Message(');
      if (sound != null) {
        stringBuffer.writeln('keepAlive: true,');
        final code = sound.getCode(projectContext);
        imports.addAll(code.imports);
        final gain = sound.gain;
        if (gain != 0.7) {
          stringBuffer.writeln('gain: $gain,');
        }
        stringBuffer.writeln('sound: ${code.code},');
      }
      if (message != null) {
        stringBuffer.writeln('text: ${getQuotedString(message)},');
      }
      stringBuffer
        ..writeln('),')
        ..writeln(');');
      if (name != null) {
        stringBuffer.writeln('$name();');
      }
      stringBuffer.write('}');
    }
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
