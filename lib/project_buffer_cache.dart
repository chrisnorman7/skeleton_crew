import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart';

/// A buffer cache with a [soundsDirectory].
class ProjectBufferCache extends BufferCache {
  /// Create an instance.
  ProjectBufferCache({
    required super.synthizer,
    required super.random,
    required this.soundsDirectory,
  }) : super(
          maxSize: 1.gb,
        );

  /// The directory to get sounds from.
  String soundsDirectory;

  /// Get a buffer.
  @override
  Buffer getBuffer(final AssetReference reference) => super.getBuffer(
        AssetReference(
          path.join(soundsDirectory, reference.name),
          reference.type,
          encryptionKey: reference.encryptionKey,
        ),
      );
}
