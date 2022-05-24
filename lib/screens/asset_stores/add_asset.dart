// ignore_for_file: prefer_final_parameters
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../../constants.dart';
import '../../json/asset_stores/asset_store_reference.dart';
import '../../json/asset_stores/pretend_asset_reference.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../../validators.dart';
import '../../widgets/cancel.dart';
import '../../widgets/keyboard_shortcuts_list.dart';
import '../../widgets/simple_scaffold.dart';

/// A widget for adding a new asset.
class AddAsset extends StatefulWidget {
  /// Create an instance.
  const AddAsset({
    required this.projectContext,
    required this.assetStoreReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The asset store to import to.
  final AssetStoreReference assetStoreReference;

  /// Create state for this widget.
  @override
  AddAssetState createState() => AddAssetState();
}

/// State for [AddAsset].
class AddAssetState extends State<AddAsset> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _pathController;
  late final TextEditingController _commentController;
  late TextEditingController _variableNameController;

  /// Create stuff.
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>(debugLabel: 'Add Asset form');
    _pathController = TextEditingController();
    _commentController = TextEditingController();
    _variableNameController = TextEditingController();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => WithKeyboardShortcuts(
        keyboardShortcuts: const [
          KeyboardShortcut(
            description: 'Import a single file.',
            keyName: 'F',
            control: true,
          ),
          KeyboardShortcut(
            description: 'Import a directory.',
            keyName: 'D',
            control: true,
          )
        ],
        child: CallbackShortcuts(
          bindings: {
            importFileShortcut: () => importFile(context),
            importDirectoryShortcut: () => importDirectory(context)
          },
          child: Cancel(
            child: SimpleScaffold(
              actions: [
                ElevatedButton(
                  onPressed: () => importDirectory(context),
                  child: const Icon(
                    Icons.file_open_outlined,
                    semanticLabel: 'Import Directory',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => importFile(context),
                  child: const Icon(
                    Icons.file_open,
                    semanticLabel: 'Import File',
                  ),
                )
              ],
              title: 'Add Asset',
              body: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: _pathController,
                      decoration: const InputDecoration(
                        labelText: 'Path',
                        hintText: 'Enter the path to a file or folder',
                      ),
                      onChanged: (final value) => _commentController.text =
                          path.basenameWithoutExtension(
                        value,
                      ),
                      validator: (final value) => validatePath(value: value),
                    ),
                    TextFormField(
                      controller: _variableNameController,
                      decoration: const InputDecoration(
                        labelText: 'Variable Name',
                        hintText:
                            'The name of the dart variable that will represent '
                            'this asset in code',
                      ),
                      validator: (value) => validateAssetStoreVariableName(
                        value: value,
                        assetStoreReference: widget.assetStoreReference,
                      ),
                    ),
                    TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Comment',
                        hintText:
                            'Enter a human-readable description for this asset',
                      ),
                      validator: (final value) => validateNonEmptyValue(
                        value: value,
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: saveIcon,
                onPressed: () => submitForm(context),
              ),
            ),
          ),
        ),
      );

  /// Dispose of the controllers.
  @override
  void dispose() {
    super.dispose();
    _pathController.dispose();
    _commentController.dispose();
  }

  /// Submit the form.
  void submitForm(final BuildContext context) {
    if (_formKey.currentState?.validate() ?? true) {
      final filename = _pathController.text;
      final variableName = _variableNameController.text;
      final comment = _commentController.text;
      final file = File(filename);
      final directory = Directory(filename);
      final isAudio = filename.endsWith('.wav') || filename.endsWith('.mp3');
      if (file.existsSync()) {
        final reference = widget.assetStoreReference.assetStore.importFile(
          source: file,
          variableName: variableName,
          comment: comment,
          relativeTo: widget.projectContext.directory,
        );
        widget.assetStoreReference.assets.add(
          PretendAssetReference(
            assetStoreId: widget.assetStoreReference.id,
            id: newId(),
            variableName: variableName,
            comment: comment,
            name: reference.reference.name,
            assetType: reference.reference.type,
            encryptionKey: reference.reference.encryptionKey,
            isAudio: isAudio,
          ),
        );
      } else if (directory.existsSync()) {
        final reference = widget.assetStoreReference.assetStore.importDirectory(
          source: directory,
          variableName: variableName,
          comment: comment,
          relativeTo: widget.projectContext.directory,
        );
        widget.assetStoreReference.assets.add(
          PretendAssetReference(
            assetStoreId: widget.assetStoreReference.id,
            id: newId(),
            variableName: variableName,
            comment: comment,
            name: reference.reference.name,
            assetType: reference.reference.type,
            encryptionKey: reference.reference.encryptionKey,
            isAudio: isAudio,
          ),
        );
      } else {
        throw StateError('Cannot handle $filename.');
      }
      widget.projectContext.save();
      Navigator.pop(context);
    }
  }

  /// Import a file.
  Future<void> importFile(final BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Choose File',
    );
    if (result == null) {
      return;
    }
    final filename = result.paths.single;
    final file = File(filename!);
    if (file.existsSync() == false) {
      return showMessage(
        context: context,
        message: 'The file $filename does not exist.',
      );
    }
    setState(() {
      _pathController.text = filename;
      _commentController.text = path.basenameWithoutExtension(filename);
    });
  }

  /// Import a directory.
  Future<void> importDirectory(final BuildContext context) async {
    final directoryName = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Directory',
    );
    if (directoryName == null) {
      return;
    }
    if (Directory(directoryName).existsSync() == false) {
      return showMessage(
        context: context,
        message: 'The directory $directoryName does not exist.',
      );
    }
    setState(() {
      _pathController.text = directoryName;
      _commentController.text = path.basename(directoryName);
    });
  }
}
