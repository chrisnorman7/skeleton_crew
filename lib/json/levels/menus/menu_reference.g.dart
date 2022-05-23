// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuReference _$MenuReferenceFromJson(Map<String, dynamic> json) =>
    MenuReference(
      id: json['id'] as String,
      title: json['title'] as String,
      menuItems: (json['menuItems'] as List<dynamic>)
          .map((e) => MenuItemReference.fromJson(e as Map<String, dynamic>))
          .toList(),
      upScanCode: $enumDecodeNullable(_$ScanCodeEnumMap, json['upScanCode']) ??
          ScanCode.up,
      upButton: $enumDecodeNullable(
              _$GameControllerButtonEnumMap, json['upButton']) ??
          GameControllerButton.dpadUp,
      downScanCode:
          $enumDecodeNullable(_$ScanCodeEnumMap, json['downScanCode']) ??
              ScanCode.down,
      downButton: $enumDecodeNullable(
              _$GameControllerButtonEnumMap, json['downButton']) ??
          GameControllerButton.dpadDown,
      activateScanCode:
          $enumDecodeNullable(_$ScanCodeEnumMap, json['activateScanCode']) ??
              ScanCode.space,
      activateButton: $enumDecodeNullable(
              _$GameControllerButtonEnumMap, json['activateButton']) ??
          GameControllerButton.dpadRight,
      cancelScanCode:
          $enumDecodeNullable(_$ScanCodeEnumMap, json['cancelScanCode']) ??
              ScanCode.escape,
      cancelButton: $enumDecodeNullable(
              _$GameControllerButtonEnumMap, json['cancelButton']) ??
          GameControllerButton.dpadLeft,
      movementAxis: $enumDecodeNullable(
              _$GameControllerAxisEnumMap, json['movementAxis']) ??
          GameControllerAxis.lefty,
      activateAxis: $enumDecodeNullable(
              _$GameControllerAxisEnumMap, json['activateAxis']) ??
          GameControllerAxis.triggerright,
      cancelAxis: $enumDecodeNullable(
              _$GameControllerAxisEnumMap, json['cancelAxis']) ??
          GameControllerAxis.triggerleft,
      controllerMovementSpeed: json['controllerMovementSpeed'] as int? ?? 500,
      controllerAxisSensitivity:
          (json['controllerAxisSensitivity'] as num?)?.toDouble() ?? 0.5,
      searchEnabled: json['searchEnabled'] as bool? ?? true,
      searchInterval: json['searchInterval'] as int? ?? 500,
      music: json['music'] == null
          ? null
          : SoundReference.fromJson(json['music'] as Map<String, dynamic>),
      ambiances: (json['ambiances'] as List<dynamic>?)
          ?.map((e) => AmbianceReference.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuReferenceToJson(MenuReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'menuItems': instance.menuItems,
      'upScanCode': _$ScanCodeEnumMap[instance.upScanCode],
      'upButton': _$GameControllerButtonEnumMap[instance.upButton],
      'downScanCode': _$ScanCodeEnumMap[instance.downScanCode],
      'downButton': _$GameControllerButtonEnumMap[instance.downButton],
      'activateScanCode': _$ScanCodeEnumMap[instance.activateScanCode],
      'activateButton': _$GameControllerButtonEnumMap[instance.activateButton],
      'cancelScanCode': _$ScanCodeEnumMap[instance.cancelScanCode],
      'cancelButton': _$GameControllerButtonEnumMap[instance.cancelButton],
      'movementAxis': _$GameControllerAxisEnumMap[instance.movementAxis],
      'activateAxis': _$GameControllerAxisEnumMap[instance.activateAxis],
      'cancelAxis': _$GameControllerAxisEnumMap[instance.cancelAxis],
      'controllerMovementSpeed': instance.controllerMovementSpeed,
      'controllerAxisSensitivity': instance.controllerAxisSensitivity,
      'searchEnabled': instance.searchEnabled,
      'searchInterval': instance.searchInterval,
      'music': instance.music,
      'ambiances': instance.ambiances,
    };

const _$ScanCodeEnumMap = {
  ScanCode.unknown: 'unknown',
  ScanCode.a: 'a',
  ScanCode.b: 'b',
  ScanCode.c: 'c',
  ScanCode.d: 'd',
  ScanCode.e: 'e',
  ScanCode.f: 'f',
  ScanCode.g: 'g',
  ScanCode.h: 'h',
  ScanCode.i: 'i',
  ScanCode.j: 'j',
  ScanCode.k: 'k',
  ScanCode.l: 'l',
  ScanCode.m: 'm',
  ScanCode.n: 'n',
  ScanCode.o: 'o',
  ScanCode.p: 'p',
  ScanCode.q: 'q',
  ScanCode.r: 'r',
  ScanCode.s: 's',
  ScanCode.t: 't',
  ScanCode.u: 'u',
  ScanCode.v: 'v',
  ScanCode.w: 'w',
  ScanCode.x: 'x',
  ScanCode.y: 'y',
  ScanCode.z: 'z',
  ScanCode.digit1: 'digit1',
  ScanCode.digit2: 'digit2',
  ScanCode.digit3: 'digit3',
  ScanCode.digit4: 'digit4',
  ScanCode.digit5: 'digit5',
  ScanCode.digit6: 'digit6',
  ScanCode.digit7: 'digit7',
  ScanCode.digit8: 'digit8',
  ScanCode.digit9: 'digit9',
  ScanCode.digit0: 'digit0',
  ScanCode.return_: 'return_',
  ScanCode.escape: 'escape',
  ScanCode.backspace: 'backspace',
  ScanCode.tab: 'tab',
  ScanCode.space: 'space',
  ScanCode.minus: 'minus',
  ScanCode.equals: 'equals',
  ScanCode.leftbracket: 'leftbracket',
  ScanCode.rightbracket: 'rightbracket',
  ScanCode.backslash: 'backslash',
  ScanCode.nonushash: 'nonushash',
  ScanCode.semicolon: 'semicolon',
  ScanCode.apostrophe: 'apostrophe',
  ScanCode.grave: 'grave',
  ScanCode.comma: 'comma',
  ScanCode.period: 'period',
  ScanCode.slash: 'slash',
  ScanCode.capslock: 'capslock',
  ScanCode.f1: 'f1',
  ScanCode.f2: 'f2',
  ScanCode.f3: 'f3',
  ScanCode.f4: 'f4',
  ScanCode.f5: 'f5',
  ScanCode.f6: 'f6',
  ScanCode.f7: 'f7',
  ScanCode.f8: 'f8',
  ScanCode.f9: 'f9',
  ScanCode.f10: 'f10',
  ScanCode.f11: 'f11',
  ScanCode.f12: 'f12',
  ScanCode.printscreen: 'printscreen',
  ScanCode.scrolllock: 'scrolllock',
  ScanCode.pause: 'pause',
  ScanCode.insert: 'insert',
  ScanCode.home: 'home',
  ScanCode.pageup: 'pageup',
  ScanCode.delete: 'delete',
  ScanCode.end: 'end',
  ScanCode.pagedown: 'pagedown',
  ScanCode.right: 'right',
  ScanCode.left: 'left',
  ScanCode.down: 'down',
  ScanCode.up: 'up',
  ScanCode.numlockclear: 'numlockclear',
  ScanCode.kp_divide: 'kp_divide',
  ScanCode.kp_multiply: 'kp_multiply',
  ScanCode.kp_minus: 'kp_minus',
  ScanCode.kp_plus: 'kp_plus',
  ScanCode.kp_enter: 'kp_enter',
  ScanCode.kp_1: 'kp_1',
  ScanCode.kp_2: 'kp_2',
  ScanCode.kp_3: 'kp_3',
  ScanCode.kp_4: 'kp_4',
  ScanCode.kp_5: 'kp_5',
  ScanCode.kp_6: 'kp_6',
  ScanCode.kp_7: 'kp_7',
  ScanCode.kp_8: 'kp_8',
  ScanCode.kp_9: 'kp_9',
  ScanCode.kp_0: 'kp_0',
  ScanCode.kp_period: 'kp_period',
  ScanCode.nonusbackslash: 'nonusbackslash',
  ScanCode.application: 'application',
  ScanCode.power: 'power',
  ScanCode.kp_equals: 'kp_equals',
  ScanCode.f13: 'f13',
  ScanCode.f14: 'f14',
  ScanCode.f15: 'f15',
  ScanCode.f16: 'f16',
  ScanCode.f17: 'f17',
  ScanCode.f18: 'f18',
  ScanCode.f19: 'f19',
  ScanCode.f20: 'f20',
  ScanCode.f21: 'f21',
  ScanCode.f22: 'f22',
  ScanCode.f23: 'f23',
  ScanCode.f24: 'f24',
  ScanCode.execute: 'execute',
  ScanCode.help: 'help',
  ScanCode.menu: 'menu',
  ScanCode.select: 'select',
  ScanCode.stop: 'stop',
  ScanCode.again: 'again',
  ScanCode.undo: 'undo',
  ScanCode.cut: 'cut',
  ScanCode.copy: 'copy',
  ScanCode.paste: 'paste',
  ScanCode.find: 'find',
  ScanCode.mute: 'mute',
  ScanCode.volumeup: 'volumeup',
  ScanCode.volumedown: 'volumedown',
  ScanCode.kp_comma: 'kp_comma',
  ScanCode.kp_equalsas400: 'kp_equalsas400',
  ScanCode.international1: 'international1',
  ScanCode.international2: 'international2',
  ScanCode.international3: 'international3',
  ScanCode.international4: 'international4',
  ScanCode.international5: 'international5',
  ScanCode.international6: 'international6',
  ScanCode.international7: 'international7',
  ScanCode.international8: 'international8',
  ScanCode.international9: 'international9',
  ScanCode.lang1: 'lang1',
  ScanCode.lang2: 'lang2',
  ScanCode.lang3: 'lang3',
  ScanCode.lang4: 'lang4',
  ScanCode.lang5: 'lang5',
  ScanCode.lang6: 'lang6',
  ScanCode.lang7: 'lang7',
  ScanCode.lang8: 'lang8',
  ScanCode.lang9: 'lang9',
  ScanCode.alterase: 'alterase',
  ScanCode.sysreq: 'sysreq',
  ScanCode.cancel: 'cancel',
  ScanCode.clear: 'clear',
  ScanCode.prior: 'prior',
  ScanCode.return2: 'return2',
  ScanCode.separator: 'separator',
  ScanCode.out: 'out',
  ScanCode.oper: 'oper',
  ScanCode.clearagain: 'clearagain',
  ScanCode.crsel: 'crsel',
  ScanCode.exsel: 'exsel',
  ScanCode.kp_00: 'kp_00',
  ScanCode.kp_000: 'kp_000',
  ScanCode.thousandsseparator: 'thousandsseparator',
  ScanCode.decimalseparator: 'decimalseparator',
  ScanCode.currencyunit: 'currencyunit',
  ScanCode.currencysubunit: 'currencysubunit',
  ScanCode.kp_leftparen: 'kp_leftparen',
  ScanCode.kp_rightparen: 'kp_rightparen',
  ScanCode.kp_leftbrace: 'kp_leftbrace',
  ScanCode.kp_rightbrace: 'kp_rightbrace',
  ScanCode.kp_tab: 'kp_tab',
  ScanCode.kp_backspace: 'kp_backspace',
  ScanCode.kp_a: 'kp_a',
  ScanCode.kp_b: 'kp_b',
  ScanCode.kp_c: 'kp_c',
  ScanCode.kp_d: 'kp_d',
  ScanCode.kp_e: 'kp_e',
  ScanCode.kp_f: 'kp_f',
  ScanCode.kp_xor: 'kp_xor',
  ScanCode.kp_power: 'kp_power',
  ScanCode.kp_percent: 'kp_percent',
  ScanCode.kp_less: 'kp_less',
  ScanCode.kp_greater: 'kp_greater',
  ScanCode.kp_ampersand: 'kp_ampersand',
  ScanCode.kp_dblampersand: 'kp_dblampersand',
  ScanCode.kp_verticalbar: 'kp_verticalbar',
  ScanCode.kp_dblverticalbar: 'kp_dblverticalbar',
  ScanCode.kp_colon: 'kp_colon',
  ScanCode.kp_hash: 'kp_hash',
  ScanCode.kp_space: 'kp_space',
  ScanCode.kp_at: 'kp_at',
  ScanCode.kp_exclam: 'kp_exclam',
  ScanCode.kp_memstore: 'kp_memstore',
  ScanCode.kp_memrecall: 'kp_memrecall',
  ScanCode.kp_memclear: 'kp_memclear',
  ScanCode.kp_memadd: 'kp_memadd',
  ScanCode.kp_memsubtract: 'kp_memsubtract',
  ScanCode.kp_memmultiply: 'kp_memmultiply',
  ScanCode.kp_memdivide: 'kp_memdivide',
  ScanCode.kp_plusminus: 'kp_plusminus',
  ScanCode.kp_clear: 'kp_clear',
  ScanCode.kp_clearentry: 'kp_clearentry',
  ScanCode.kp_binary: 'kp_binary',
  ScanCode.kp_octal: 'kp_octal',
  ScanCode.kp_decimal: 'kp_decimal',
  ScanCode.kp_hexadecimal: 'kp_hexadecimal',
  ScanCode.lctrl: 'lctrl',
  ScanCode.lshift: 'lshift',
  ScanCode.lalt: 'lalt',
  ScanCode.lgui: 'lgui',
  ScanCode.rctrl: 'rctrl',
  ScanCode.rshift: 'rshift',
  ScanCode.ralt: 'ralt',
  ScanCode.rgui: 'rgui',
  ScanCode.mode: 'mode',
  ScanCode.audionext: 'audionext',
  ScanCode.audioprev: 'audioprev',
  ScanCode.audiostop: 'audiostop',
  ScanCode.audioplay: 'audioplay',
  ScanCode.audiomute: 'audiomute',
  ScanCode.mediaselect: 'mediaselect',
  ScanCode.www: 'www',
  ScanCode.mail: 'mail',
  ScanCode.calculator: 'calculator',
  ScanCode.computer: 'computer',
  ScanCode.ac_search: 'ac_search',
  ScanCode.ac_home: 'ac_home',
  ScanCode.ac_back: 'ac_back',
  ScanCode.ac_forward: 'ac_forward',
  ScanCode.ac_stop: 'ac_stop',
  ScanCode.ac_refresh: 'ac_refresh',
  ScanCode.ac_bookmarks: 'ac_bookmarks',
  ScanCode.brightnessdown: 'brightnessdown',
  ScanCode.brightnessup: 'brightnessup',
  ScanCode.displayswitch: 'displayswitch',
  ScanCode.kbdillumtoggle: 'kbdillumtoggle',
  ScanCode.kbdillumdown: 'kbdillumdown',
  ScanCode.kbdillumup: 'kbdillumup',
  ScanCode.eject: 'eject',
  ScanCode.sleep: 'sleep',
  ScanCode.app1: 'app1',
  ScanCode.app2: 'app2',
  ScanCode.audiorewind: 'audiorewind',
  ScanCode.audiofastforward: 'audiofastforward',
  ScanCode.num_scancodes: 'num_scancodes',
};

const _$GameControllerButtonEnumMap = {
  GameControllerButton.invalid: 'invalid',
  GameControllerButton.a: 'a',
  GameControllerButton.b: 'b',
  GameControllerButton.x: 'x',
  GameControllerButton.y: 'y',
  GameControllerButton.back: 'back',
  GameControllerButton.guide: 'guide',
  GameControllerButton.start: 'start',
  GameControllerButton.leftstick: 'leftstick',
  GameControllerButton.rightstick: 'rightstick',
  GameControllerButton.leftshoulder: 'leftshoulder',
  GameControllerButton.rightshoulder: 'rightshoulder',
  GameControllerButton.dpadUp: 'dpadUp',
  GameControllerButton.dpadDown: 'dpadDown',
  GameControllerButton.dpadLeft: 'dpadLeft',
  GameControllerButton.dpadRight: 'dpadRight',
  GameControllerButton.misc1: 'misc1',
  GameControllerButton.paddle1: 'paddle1',
  GameControllerButton.paddle2: 'paddle2',
  GameControllerButton.paddle3: 'paddle3',
  GameControllerButton.paddle4: 'paddle4',
  GameControllerButton.touchpad: 'touchpad',
  GameControllerButton.max: 'max',
};

const _$GameControllerAxisEnumMap = {
  GameControllerAxis.invalid: 'invalid',
  GameControllerAxis.leftx: 'leftx',
  GameControllerAxis.lefty: 'lefty',
  GameControllerAxis.rightx: 'rightx',
  GameControllerAxis.righty: 'righty',
  GameControllerAxis.triggerleft: 'triggerleft',
  GameControllerAxis.triggerright: 'triggerright',
  GameControllerAxis.max: 'max',
};
