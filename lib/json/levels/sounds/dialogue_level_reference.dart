import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/levels.dart';

import '../../../src/generated_code.dart';
import '../../../src/project_context.dart';
import '../../message_reference.dart';
import '../functions/function_reference.dart';
import '../level_command_reference.dart';
import '../level_reference.dart';
import 'ambiance_reference.dart';
import 'sound_reference.dart';

part 'dialogue_level_reference.g.dart';

/// A level that represents a [DialogueLevel] instance.
@JsonSerializable()
class DialogueLevelReference extends LevelReference {
  /// Create an instance.
  DialogueLevelReference({
    required super.id,
    required super.title,
    super.className = 'CustomDialogueLevelBase',
    super.ambiances,
    super.commands,
    super.comment = 'A dialogue level that needs a comment.',
    super.functions,
    super.music,
    final List<MessageReference>? messages,
  }) : messages = messages ?? [];

  /// Create an instance from a JSON object.
  factory DialogueLevelReference.fromJson(final Map<String, dynamic> json) =>
      _$DialogueLevelReferenceFromJson(json);

  /// The messages for this level.
  final List<MessageReference> messages;

  /// The message to show when calling the `onDone` function.
  MessageReference? onDoneMessage;

  /// Convert an instance to JSON.
  @override
  Map<String, dynamic> toJson() => _$DialogueLevelReferenceToJson(this);

  /// Generate code for this instance.
  @override
  GeneratedCode getCode(final ProjectContext projectContext) {
    final imports = <String>{
      'package:ziggurat/levels.dart',
      'package:ziggurat/ziggurat.dart'
    };
    final stringBuffer = StringBuffer()
      ..writeln('/// $comment')
      ..writeln('abstract class $className extends DialogueLevel {')
      ..writeln('/// Create an instance.')
      ..writeln('$className({required super.game,')
      ..writeln('required final TaskFunction onDone,')
      ..writeln('}) : super(')
      ..writeln('messages: [');
    for (final messageReference in messages) {
      final code = messageReference.getCode(
        projectContext: projectContext,
        keepAlive: true,
      );
      imports.addAll(code.imports);
      stringBuffer
        ..write('const ')
        ..write(code.code)
        ..writeln(',');
    }
    stringBuffer
      ..writeln('],')
      ..write('onDone: ');
    final message = onDoneMessage;
    if (message == null) {
      stringBuffer.write('onDone');
    } else {
      stringBuffer.writeln('() {');
      final code = message.getCode(
        projectContext: projectContext,
        keepAlive: false,
      );
      imports.addAll(code.imports);
      stringBuffer
        ..writeln('game.outputMessage(')
        ..writeln('const ${code.code},')
        ..writeln(');')
        ..writeln('onDone();')
        ..write('}');
    }
    stringBuffer.writeln(',');
    final code = getMusicAmbianceCode(projectContext);
    if (code != null) {
      imports.addAll(code.imports);
      stringBuffer.writeln(code.code);
    }
    stringBuffer.write(')');
    final commandsCode = getCommandsCode(projectContext);
    if (commandsCode == null) {
      stringBuffer.writeln(';');
    } else {
      imports.addAll(commandsCode.imports);
      stringBuffer
        ..writeln(' {')
        ..writeln(commandsCode.code)
        ..writeln('}');
    }
    for (final function in functions) {
      stringBuffer.writeln(function.header);
    }
    stringBuffer.writeln('}');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
