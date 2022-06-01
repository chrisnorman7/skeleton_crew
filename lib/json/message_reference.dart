import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/ziggurat.dart';

import '../src/generated_code.dart';
import '../src/project_context.dart';
import '../util.dart';
import 'levels/sounds/sound_reference.dart';

part 'message_reference.g.dart';

/// A reference to a [Message] instance.
@JsonSerializable()
class MessageReference {
  /// Create an instance.
  MessageReference({
    required this.id,
    this.text,
    this.soundReference,
  });

  /// Create an instance from a JSON object.
  factory MessageReference.fromJson(final Map<String, dynamic> json) =>
      _$MessageReferenceFromJson(json);

  /// The ID for this message.
  final String id;

  /// The text of this message.
  String? text;

  /// The sound that will play for this message.
  SoundReference? soundReference;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MessageReferenceToJson(this);

  /// Get the code for this instance.
  GeneratedCode getCode({
    required final ProjectContext projectContext,
    required final bool keepAlive,
  }) {
    final imports = <String>{};
    final stringBuffer = StringBuffer()..writeln('Message(');
    final sound = soundReference;
    if (sound != null) {
      final code = sound.getCode(projectContext);
      imports.addAll(code.imports);
      final gain = sound.gain;
      if (gain != 0.7) {
        stringBuffer.writeln('gain: $gain,');
      }
      if (keepAlive) {
        stringBuffer.writeln('keepAlive: true,');
      }
      stringBuffer.writeln('sound: ${code.code},');
    }
    final string = text;
    if (string != null) {
      stringBuffer.writeln('text: ${getQuotedString(string)},');
    }
    stringBuffer.writeln(')');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
