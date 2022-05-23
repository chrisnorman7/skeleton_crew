import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/menus.dart';

import '../../sound_reference.dart';
import '../function_reference.dart';

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
}
