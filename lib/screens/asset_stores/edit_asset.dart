import 'package:flutter/material.dart';

import '../../json/asset_store_reference.dart';
import '../../json/pretend_asset_reference.dart';
import '../../src/project_context.dart';
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
  Widget build(final BuildContext context) => Cancel(
        child: SimpleScaffold(
          title: 'Edit Asset',
          body: ListView(
            children: [
              TextListTile(
                value: widget.pretendAssetReference.variableName,
                onChanged: (final value) {
                  widget.pretendAssetReference.variableName = value;
                  save();
                },
                header: 'Variable Name',
                autofocus: true,
              )
            ],
          ),
        ),
      );
}
