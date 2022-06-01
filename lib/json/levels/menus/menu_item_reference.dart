import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/menus.dart';

import '../../../src/generated_code.dart';
import '../../../src/project_context.dart';
import '../../message_reference.dart';
import '../functions/call_function.dart';
import '../level_reference.dart';

part 'menu_item_reference.g.dart';

/// A reference to a [MenuItem].
@JsonSerializable()
class MenuItemReference {
  /// Create an instance.
  MenuItemReference({
    required this.id,
    final MessageReference? message,
    this.callFunction,
  }) : message = message ?? MessageReference();

  /// Create an instance from a JSON object.
  factory MenuItemReference.fromJson(final Map<String, dynamic> json) =>
      _$MenuItemReferenceFromJson(json);

  /// The ID of this menu.
  final String id;

  /// The message for this menu item.
  final MessageReference message;

  /// The function to call when this menu item is is activated.
  ///
  /// If this value is `null`, then [menuItemLabel] will be used as the widget.
  CallFunction? callFunction;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MenuItemReferenceToJson(this);

  /// Get the Dart code for this instance.
  GeneratedCode getCode(
    final ProjectContext projectContext,
    final LevelReference levelReference,
  ) {
    final imports = <String>{'package:ziggurat/menus.dart'};
    final stringBuffer = StringBuffer();
    final constMenuItem = callFunction == null;
    if (constMenuItem) {
      stringBuffer.writeln('const ');
    }
    stringBuffer.writeln('MenuItem(');
    if (!constMenuItem) {
      stringBuffer.write('const ');
    }
    final messageCode = message.getCode(
      projectContext: projectContext,
      keepAlive: true,
    );
    imports.addAll(messageCode.imports);
    stringBuffer
      ..write(messageCode.code)
      ..writeln(',');
    final callFunctionCode =
        callFunction?.getCode(projectContext, levelReference);
    if (callFunctionCode == null) {
      stringBuffer.writeln('menuItemLabel,');
    } else {
      imports.addAll(callFunctionCode.imports);
      stringBuffer
        ..writeln('Button(')
        ..writeln('${callFunctionCode.code},')
        ..writeln('),');
    }
    stringBuffer.writeln(')');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
