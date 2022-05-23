import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/asset_stores/asset_store_reference.dart';
import '../../json/project.dart';
import '../../util.dart';
import '../../validators.dart';
import '../../widgets/cancel.dart';
import '../../widgets/simple_scaffold.dart';

/// A widget for creating a new asset store.
class CreateAssetStore extends StatefulWidget {
  /// Create an instance.
  const CreateAssetStore({
    required this.project,
    required this.onDone,
    super.key,
  });

  /// The directory where encrypted assets will be stored.
  final Project project;

  /// The function to call with the new asset store.
  final ValueChanged<AssetStoreReference> onDone;

  /// Create state for this widget.
  @override
  CreateAssetStoreState createState() => CreateAssetStoreState();
}

/// State for [CreateAssetStore].
class CreateAssetStoreState extends State<CreateAssetStore> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController;
  late final TextEditingController _dartFilenameController;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _nameController = TextEditingController(
      text: 'Untitled Asset Store',
    );
    _nameController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _nameController.text.length,
    );
    _dartFilenameController = TextEditingController(text: '.dart')
      ..selection = const TextSelection(baseOffset: 0, extentOffset: 0);
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Cancel(
        child: SimpleScaffold(
          title: 'Create Asset Store',
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Asset Store Name',
                  ),
                  validator: (final value) => validateNonEmptyValue(
                    value: value,
                  ),
                ),
                TextFormField(
                  controller: _dartFilenameController,
                  decoration: const InputDecoration(
                    labelText: 'The file where dart code will be generated',
                  ),
                  validator: (final value) => validateAssetStoreDartFilename(
                    value: value,
                    project: widget.project,
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? true) {
                final reference = AssetStoreReference(
                  id: newId(),
                  name: _nameController.text,
                  comment: 'This asset store has no comment.',
                  dartFilename: _dartFilenameController.text,
                  assets: [],
                );
                Navigator.pop(context);
                widget.onDone(reference);
              }
            },
            child: saveIcon,
            tooltip: 'Save Asset Store',
          ),
        ),
      );
}
