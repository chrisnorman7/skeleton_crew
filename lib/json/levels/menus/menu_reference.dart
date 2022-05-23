import 'package:dart_sdl/dart_sdl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/menus.dart';

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
}
