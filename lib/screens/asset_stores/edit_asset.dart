import 'package:flutter/material.dart';

import '../../json/asset_stores/asset_store_reference.dart';
import '../../json/asset_stores/pretend_asset_reference.dart';
import '../../src/project_context.dart';
import '../../validators.dart';
import '../../widgets/cancel.dart';
import '../../widgets/project_context_state.dart';
import '../../widgets/simple_scaffold.dart';
import '../../widgets/text_list_tile.dart';

/// A widget for editing the given [pretendAssetReference].
class EditAsset extends StatefulWidget {
  /// Create an instance.
  const EditAsset({
    required this.projectContext,
    required this.assetStoreReference,
    required this.pretendAssetReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The asset store that [pretendAssetReference] is part of.
  final AssetStoreReference assetStoreReference;

  /// The asset reference to edit.
  final PretendAssetReference pretendAssetReference;

  /// Create state for this widget.
  @override
  EditAssetState createState() => EditAssetState();
}

/// State for [EditAsset].
class EditAssetState extends ProjectContextState<EditAsset> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final pretendAssetReference = widget.pretendAssetReference;
    return Cancel(
      child: SimpleScaffold(
        title: 'Edit Asset',
        body: ListView(
          children: [
            TextListTile(
              value: pretendAssetReference.variableName,
              onChanged: (final value) {
                pretendAssetReference.variableName = value;
                save();
              },
              header: 'Variable Name',
              autofocus: true,
              validator: (final value) => validateAssetStoreVariableName(
                value: value,
                assetStoreReference: widget.assetStoreReference,
              ),
            ),
            TextListTile(
              value: pretendAssetReference.comment,
              onChanged: (final value) {
                pretendAssetReference.comment = value;
                save();
              },
              header: 'Comment',
              validator: (final value) => validateNonEmptyValue(value: value),
            ),
            CheckboxListTile(
              value: pretendAssetReference.isAudio,
              onChanged: (final value) {
                pretendAssetReference.isAudio = value ?? false;
                save();
              },
              title: const Text('Audio Asset'),
              subtitle: Text(pretendAssetReference.isAudio ? 'Yes' : 'No'),
            )
          ],
        ),
      ),
    );
  }
}
