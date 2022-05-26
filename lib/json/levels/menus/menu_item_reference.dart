import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/menus.dart';

import '../../../src/generated_code.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../function_reference.dart';
import '../sounds/sound_reference.dart';

part 'menu_item_reference.g.dart';

/// A reference to a [MenuItem].
@JsonSerializable()
class MenuItemReference {
  /// Create an instance.
  MenuItemReference({
    required this.id,
    this.title,
    this.soundReference,
    this.functionReference,
  });

  /// Create an instance from a JSON object.
  factory MenuItemReference.fromJson(final Map<String, dynamic> json) =>
      _$MenuItemReferenceFromJson(json);

  /// The ID of this menu.
  final String id;

  /// The title of this menu item.
  String? title;

  /// The sound that should play for this menu item.
  SoundReference? soundReference;

  /// The function to call when this menu item is is activated.
  ///
  /// If this value is `null`, then [menuItemLabel] will be used as the widget.
  FunctionReference? functionReference;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MenuItemReferenceToJson(this);

  /// Get the Dart code for this instance.
  GeneratedCode getCode(final ProjectContext projectContext) {
    final project = projectContext.project;
    final imports = <String>{'package:ziggurat/menus.dart'};
    final sound = soundReference;
    final text = title;
    final stringBuffer = StringBuffer();
    final constMenuItem = sound == null && text == null;
    if (constMenuItem) {
      stringBuffer.writeln('const MenuItem(');
    } else {
      stringBuffer.writeln('MenuItem(');
    }
    stringBuffer.writeln('${constMenuItem ? "" : "const "}Message(');
    if (sound != null) {
      final pretendAssetReference = project.getPretendAssetReference(sound);
      final code = pretendAssetReference.getCode(projectContext);
      imports.addAll(code.imports);
      stringBuffer
        ..writeln('gain: ${sound.gain},')
        ..writeln('keepAlive: true,')
        ..writeln('sound: ${code.code},');
    }
    if (text != null) {
      stringBuffer.writeln('text: ${getQuotedString(text)},');
    }
    stringBuffer.writeln('),');
    final function = functionReference;
    if (function == null) {
      stringBuffer.writeln('menuItemLabel,');
    } else {
      final code = function.getCode(projectContext);
      imports.addAll(code.imports);
      stringBuffer
        ..writeln('Button(')
        ..writeln('${code.code},')
        ..writeln('),');
    }
    stringBuffer.writeln(')');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
