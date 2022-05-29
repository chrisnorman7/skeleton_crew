import 'package:dart_sdl/dart_sdl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/menus.dart';

import '../../../src/generated_code.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../level_command_reference.dart';
import '../level_reference.dart';
import '../sounds/ambiance_reference.dart';
import '../sounds/sound_reference.dart';
import 'menu_item_reference.dart';

part 'menu_reference.g.dart';

/// The reference to a [Menu].
@JsonSerializable()
class MenuReference extends LevelReference {
  /// Create an instance.
  MenuReference({
    required super.id,
    required super.title,
    required this.menuItems,
    super.className = 'CustomLevel',
    super.comment = 'A menu which must be extended.',
    super.music,
    super.ambiances,
    super.commands,
    this.upScanCode = ScanCode.up,
    this.upButton = GameControllerButton.dpadUp,
    this.downScanCode = ScanCode.down,
    this.downButton = GameControllerButton.dpadDown,
    this.activateScanCode = ScanCode.space,
    this.activateButton = GameControllerButton.dpadRight,
    this.cancelScanCode = ScanCode.escape,
    this.cancelButton = GameControllerButton.dpadLeft,
    this.movementAxis = GameControllerAxis.lefty,
    this.activateAxis = GameControllerAxis.triggerright,
    this.cancelAxis = GameControllerAxis.triggerleft,
    this.controllerMovementSpeed = 500,
    this.controllerAxisSensitivity = 0.5,
    this.searchEnabled = true,
    this.searchInterval = 500,
  });

  /// Create an instance from a JSON object.
  factory MenuReference.fromJson(final Map<String, dynamic> json) =>
      _$MenuReferenceFromJson(json);

  /// A list of menu items to render.
  final List<MenuItemReference> menuItems;

  /// [Menu.upScanCode].
  ScanCode upScanCode;

  /// [Menu.upButton].
  GameControllerButton upButton;

  /// [Menu.downScanCode].
  ScanCode downScanCode;

  /// [Menu.downButton].
  GameControllerButton downButton;

  /// [Menu.activateScanCode].
  ScanCode activateScanCode;

  /// [Menu.activateButton]
  GameControllerButton activateButton;

  /// [Menu.cancelScanCode].
  ScanCode cancelScanCode;

  /// [Menu.cancelButton].
  GameControllerButton cancelButton;

  /// `Menu.movementAxis`.
  GameControllerAxis movementAxis;

  /// `Menu.activateAxis`.
  GameControllerAxis activateAxis;

  /// `Menu.cancelAxis`.
  GameControllerAxis cancelAxis;

  /// `Menu.controllerMovementSpeed`.
  int controllerMovementSpeed;

  /// `Menu.controllerAxisSensitivity`.
  double controllerAxisSensitivity;

  /// [Menu.searchEnabled].
  bool searchEnabled;

  /// [Menu.searchInterval].
  int searchInterval;

  /// Convert an instance to JSON.
  @override
  Map<String, dynamic> toJson() => _$MenuReferenceToJson(this);

  /// Get code for this instance.
  @override
  GeneratedCode getCode(final ProjectContext projectContext) {
    final imports = <String>{
      'package:ziggurat/ziggurat.dart',
      'package:ziggurat/sound.dart',
      'package:ziggurat/menus.dart',
      'package:dart_sdl/dart_sdl.dart'
    };
    final stringBuffer = StringBuffer()
      ..writeln('/// $comment')
      ..writeln('abstract class $className extends Menu {')
      ..writeln('/// Create an instance.')
      ..writeln('$className({')
      ..writeln('required super.game,')
      ..writeln('}) : super(')
      ..writeln('title: const Message(')
      ..writeln('text: ${getQuotedString(title)},')
      ..writeln('),')
      ..writeln('items: [],')
      ..writeln('upScanCode: $upScanCode,')
      ..writeln('upButton: $upButton,')
      ..writeln('downScanCode : $downScanCode,')
      ..writeln('downButton: $downButton,')
      ..writeln('activateScanCode: $activateScanCode,')
      ..writeln('activateButton: $activateButton,')
      ..writeln('cancelScanCode: $cancelScanCode,')
      ..writeln('cancelButton: $cancelButton,')
      ..writeln('movementAxis: $movementAxis,')
      ..writeln('activateAxis: $activateAxis,')
      ..writeln('cancelAxis: $cancelAxis,')
      ..writeln('controllerMovementSpeed: $controllerMovementSpeed,')
      ..writeln(
        'controllerAxisSensitivity: $controllerAxisSensitivity,',
      )
      ..writeln('searchEnabled: $searchEnabled,')
      ..writeln('searchInterval: $searchInterval,');
    final musicAmbiancesCode = getMusicAmbianceCode(projectContext);
    if (musicAmbiancesCode != null) {
      imports.addAll(musicAmbiancesCode.imports);
      stringBuffer.writeln(musicAmbiancesCode.code);
    }
    stringBuffer
      ..writeln(') {')
      ..writeln('menuItems.addAll([');
    for (final item in menuItems) {
      final code = item.getCode(projectContext);
      imports.addAll(code.imports);
      stringBuffer
        ..write(code.code)
        ..writeln(',');
    }
    stringBuffer.writeln('],);}');
    final functionHeadersCode = getFunctionHeaders(projectContext);
    imports.addAll(functionHeadersCode.imports);
    stringBuffer
      ..writeln(functionHeadersCode.code)
      ..writeln('}');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
