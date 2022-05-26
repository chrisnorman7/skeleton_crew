import 'package:dart_sdl/dart_sdl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/menus.dart';

import '../../../src/generated_code.dart';
import '../../../src/project_context.dart';
import '../../../util.dart';
import '../function_reference.dart';
import '../sounds/ambiance_reference.dart';
import '../sounds/sound_reference.dart';
import 'menu_item_reference.dart';

part 'menu_reference.g.dart';

/// The reference to a [Menu].
@JsonSerializable()
class MenuReference {
  /// Create an instance.
  MenuReference({
    required this.id,
    required this.title,
    required this.menuItems,
    this.className = 'Menu',
    this.comment = 'A menu which must be extended.',
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
    this.music,
    final List<AmbianceReference>? ambiances,
  }) : ambiances = ambiances ?? [];

  /// Create an instance from a JSON object.
  factory MenuReference.fromJson(final Map<String, dynamic> json) =>
      _$MenuReferenceFromJson(json);

  /// The ID of this menu.
  final String id;

  /// The title of this menu.
  String title;

  /// A list of menu items to render.
  final List<MenuItemReference> menuItems;

  /// The class name for this menu.
  String className;

  /// The comment for this menu.
  String comment;

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

  /// `Menu.music`.
  SoundReference? music;

  /// `Menu.ambiances`.
  final List<AmbianceReference> ambiances;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$MenuReferenceToJson(this);

  /// Get code for this instance.
  GeneratedCode getCode(final ProjectContext projectContext) {
    final project = projectContext.project;
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
    final musicReference = music;
    if (musicReference != null) {
      final pretendAssetReference =
          project.getPretendAssetReference(musicReference);
      final code = pretendAssetReference.getCode(projectContext);
      imports.addAll(code.imports);
      stringBuffer
        ..writeln('music: const Music(')
        ..writeln('sound: ${code.code},')
        ..writeln('gain: ${musicReference.gain},')
        ..writeln('),');
    }
    stringBuffer
      ..writeln(') {')
      ..writeln('menuItems.addAll([');
    final functionReferences = <FunctionReference>{};
    for (final item in menuItems) {
      final code = item.getCode(projectContext);
      imports.addAll(code.imports);
      stringBuffer
        ..write(code.code)
        ..writeln(',');
      final functionReference = item.functionReference;
      if (functionReference != null) {
        functionReferences.add(functionReference);
      }
    }
    stringBuffer.writeln('],);}');
    for (final function in functionReferences) {
      stringBuffer.writeln(function.header);
    }
    stringBuffer.writeln('}');
    return GeneratedCode(code: stringBuffer.toString(), imports: imports);
  }
}
