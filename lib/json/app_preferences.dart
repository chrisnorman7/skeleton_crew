import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences.g.dart';

const _preferencesKey = 'preferences';

/// Application preferences.
@JsonSerializable()
class AppPreferences {
  /// Create an instance.
  AppPreferences({this.lastLoadedFilename});

  /// Create an instance from a JSON object.
  factory AppPreferences.fromJson(final Map<String, dynamic> json) =>
      _$AppPreferencesFromJson(json);

  /// Load an instance from shared preferences.
  static Future<AppPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_preferencesKey);
    if (value == null) {
      return AppPreferences();
    } else {
      final json = jsonDecode(value) as Map<String, dynamic>;
      return AppPreferences.fromJson(json);
    }
  }

  /// The last loaded filename.
  String? lastLoadedFilename;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$AppPreferencesToJson(this);

  /// Save preferences.
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(toJson());
    await prefs.setString(_preferencesKey, json);
  }
}
