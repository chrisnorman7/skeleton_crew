import 'package:json_annotation/json_annotation.dart';

import '../../src/generated_code.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import 'sounds/sound_reference.dart';

part 'function_reference.g.dart';

/// A reference to a function which should be automatically generated.
@JsonSerializable()
class FunctionReference {
  /// Create an instance.
  FunctionReference({
    required this.name,
    required this.comment,
    this.text,
    this.soundReference,
  });

  /// Create an instance from a JSON object.
  factory FunctionReference.fromJson(final Map<String, dynamic> json) =>
      _$FunctionReferenceFromJson(json);

  /// The name of the function.
  String name;

  /// The comment for the function.
  String comment;

  /// Text to output.
  String? text;

  /// A sound to play.
  SoundReference? soundReference;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$FunctionReferenceToJson(this);

  /// Get Dart code for this function.
  GeneratedCode getCode(final ProjectContext projectContext) {
    final imports = <String>{};
    final stringBuffer = StringBuffer();
    final message = text;
    final sound = soundReference;
    if (message == null && sound == null) {
      stringBuffer.writeln(name);
    } else {
      stringBuffer
        ..writeln('() {')
        ..writeln('game.outputMessage(const Message(');
      if (sound != null) {
        final project = projectContext.project;
        final assetStore = project.getAssetStore(sound.assetStoreId);
        final pretendAssetReference = project.getPretendAssetReference(sound);
        imports.add(assetStore.getDartFile());
        stringBuffer
          ..writeln('gain: ${sound.gain},')
          ..writeln('sound: ${pretendAssetReference.variableName},');
      }
      if (message != null) {
        stringBuffer.writeln('text: ${getQuotedString(message)},');
      }
      stringBuffer
        ..writeln('),);')
        ..writeln('$name();')
        ..writeln('}');
    }
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }

  /// Get the header for this function.
  String get header => '/// $comment\nvoid $name();';
}
