import 'package:json_annotation/json_annotation.dart';

import '../../../src/generated_code.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../sounds/sound_reference.dart';
import 'function_reference.dart';

part 'call_function.g.dart';

/// A class that represents a function.
///
/// If [functionName] is not `null`, then a [FunctionReference] instance will be
/// called.
@JsonSerializable()
class CallFunction {
  /// Create an instance.
  CallFunction({
    required this.id,
    this.text,
    this.soundReference,
    this.functionName,
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

  /// The name of the function to call.
  String? functionName;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$CallFunctionToJson(this);

  /// Get code for this instance.
  GeneratedCode? getCode(final ProjectContext projectContext) {
    final message = text;
    final sound = soundReference;
    final name = functionName;
    if (message == null && sound == null && name == null) {
      return null;
    }
    final imports = <String>{'package:ziggurat/ziggurat.dart'};
    final stringBuffer = StringBuffer()..write('() ');
    if (sound == null && message == null) {
      stringBuffer.writeln('=> $name()');
    } else {
      stringBuffer
        ..writeln('{')
        ..writeln('game.outputMessage(')
        ..writeln('const Message(');
      if (sound != null) {
        final code = sound.getCode(projectContext);
        imports.addAll(code.imports);
        stringBuffer
          ..writeln('gain: ${sound.gain},')
          ..writeln('sound: ${code.code},');
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
