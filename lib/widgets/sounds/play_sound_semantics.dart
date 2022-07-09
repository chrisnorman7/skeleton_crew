import 'package:flutter/material.dart';
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart';

/// A widget for playing a sound when selected.
class PlaySoundSemantics extends StatefulWidget {
  /// Create an instance.
  const PlaySoundSemantics({
    required this.game,
    required this.child,
    this.assetReference,
    this.gain = 0.7,
    this.looping = false,
    this.position = unpanned,
    super.key,
  });

  /// Find an instance by the given [context].
  static PlaySoundSemanticsState? of(final BuildContext context) =>
      context.findAncestorStateOfType<PlaySoundSemanticsState>();

  /// The game to use to create sound channels.
  final Game game;

  /// The widget below this one in the tree.
  final Widget child;

  /// The sound to play.
  ///
  /// If this value is `null`, no sound will play.
  final AssetReference? assetReference;

  /// The gain for the resulting sound.
  final double gain;

  /// Whether or not the resulting sound should loop.
  final bool looping;

  /// The position of the resulting sound.
  final SoundPosition position;

  /// Create state for this widget.
  @override
  PlaySoundSemanticsState createState() => PlaySoundSemanticsState();
}

/// State for [PlaySoundSemantics].
class PlaySoundSemanticsState extends State<PlaySoundSemantics> {
  Sound? _playSound;
  SoundChannel? _soundChannel;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Semantics(
        onDidGainAccessibilityFocus: play,
        onDidLoseAccessibilityFocus: stop,
        child: widget.child,
      );

  /// Dispose of the play sound instance.
  @override
  void dispose() {
    super.dispose();
    stop();
  }

  /// Play the sound.
  void play() {
    _playSound?.destroy();
    final assetReference = widget.assetReference;
    if (assetReference != null) {
      final soundChannel = widget.game.createSoundChannel(
        position: widget.position,
      );
      _soundChannel = soundChannel;
      _playSound = soundChannel.playSound(
        assetReference: assetReference,
        gain: widget.gain,
        keepAlive: true,
        looping: widget.looping,
      );
    }
  }

  /// Stop the current sound.
  void stop() {
    _playSound?.destroy();
    _playSound = null;
    _soundChannel?.destroy();

    _soundChannel = null;
  }
}
