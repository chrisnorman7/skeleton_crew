import 'package:json_annotation/json_annotation.dart';

import '../../src/generated_code.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import 'functions/call_function.dart';
import 'level_reference.dart';

part 'level_command_reference.g.dart';

/// A command in a [LevelReference] instance.
@JsonSerializable()
class LevelCommandReference {
  /// Create an instance.
  LevelCommandReference({
    required this.id,
    required this.commandTriggerId,
    this.startFunction,
    this.stopFunction,
    this.undoFunction,
    this.interval,
  });

  /// Create an instance from a JSON object.
  factory LevelCommandReference.fromJson(final Map<String, dynamic> json) =>
      _$LevelCommandReferenceFromJson(json);

  /// The ID of this command.
  final String id;

  /// The ID of the trigger that will trigger this command.
  String commandTriggerId;

  /// The function to call when the command starts.
  CallFunction? startFunction;

  /// The function to call when the command stops.
  CallFunction? stopFunction;

  /// The function to call to undo the affects of this command.
  CallFunction? undoFunction;

  /// The interval for the resulting command.
  int? interval;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$LevelCommandReferenceToJson(this);

  /// Get the code for this instance.
  GeneratedCode getCode(
    final ProjectContext projectContext,
    final LevelReference levelReference,
  ) {
    final project = projectContext.project;
    final imports = <String>{'package:ziggurat/ziggurat.dart'};
    final commandTrigger = project.getCommandTrigger(commandTriggerId);
    final commandInterval = interval;
    final stringBuffer = StringBuffer()
      ..writeln('registerCommand(')
      ..writeln('${getQuotedString(commandTrigger.commandTrigger.name)},');

    void writeFunction(final CallFunction? func, final String prefix) {
      final code = func?.getCode(projectContext, levelReference);
      if (code != null) {
        imports.addAll(code.imports);
        stringBuffer.writeln('$prefix: ${code.code},');
      }
    }

    if (startFunction == null && stopFunction == null && undoFunction == null) {
      stringBuffer.writeln('const Command(');
    } else {
      stringBuffer.writeln('Command(');
      writeFunction(startFunction, 'onStart');
      writeFunction(stopFunction, 'onStop');
      writeFunction(undoFunction, 'onUndo');
    }
    if (commandInterval != null) {
      stringBuffer.writeln('interval: $commandInterval,');
    }
    stringBuffer.writeln('),);');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
