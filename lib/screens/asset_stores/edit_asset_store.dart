import 'package:flutter/material.dart';
import 'package:ziggurat_sounds/ziggurat_sounds.dart';

import '../../constants.dart';
import '../../json/asset_store_reference.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../../validators.dart';
import '../../widgets/cancel.dart';
import '../../widgets/project_context_state.dart';
import '../../widgets/searchable_list_view.dart';
import '../../widgets/tabbed_scaffold.dart';
import '../../widgets/text_list_tile.dart';

/// A widget to edit the given [assetStoreReference].
class EditAssetStore extends StatefulWidget {
  /// Create an instance.
  const EditAssetStore({
    required this.projectContext,
    required this.assetStoreReference,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The asset store reference to edit.
  final AssetStoreReference assetStoreReference;

  /// Create state for this widget.
  @override
  EditAssetStoreState createState() => EditAssetStoreState();
}

/// State for [EditAssetStore].
class EditAssetStoreState extends ProjectContextState<EditAssetStore> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final assetStore = widget.assetStoreReference.assetStore;
    return Cancel(
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            title: 'Store Settings',
            icon: const Icon(Icons.settings),
            builder: (final context) => ListView(
              children: [
                TextListTile(
                  autofocus: true,
                  value: widget.assetStoreReference.name,
                  onChanged: (final value) {
                    widget.assetStoreReference.name = value;
                    save();
                  },
                  header: 'Name',
                  validator: (final value) => validateNonEmptyValue(
                    value: value,
                  ),
                ),
                TextListTile(
                  value: assetStore.comment ?? '',
                  onChanged: (final value) {
                    widget.assetStoreReference.assetStore = AssetStore(
                      filename: assetStore.filename,
                      destination: assetStore.destination,
                      assets: assetStore.assets,
                      comment: value,
                    );
                    save();
                  },
                  header: 'Comment',
                  validator: (final value) => validateNonEmptyValue(
                    value: value,
                  ),
                ),
                TextListTile(
                  value: assetStore.filename,
                  onChanged: (final value) {
                    widget.assetStoreReference.assetStore = AssetStore(
                      filename: value,
                      destination: assetStore.destination,
                      assets: assetStore.assets,
                      comment: assetStore.comment,
                    );
                    save();
                  },
                  header: 'Dart Filename',
                  validator: (final value) => validateAssetStoreDartFilename(
                    value: value,
                    project: projectContext.project,
                  ),
                )
              ],
            ),
          ),
          TabbedScaffoldTab(
            title: 'Assets',
            icon: filesIcon,
            builder: (final context) {
              final children = <SearchableListTile>[];
              for (var i = 0; i < assetStore.assets.length; i++) {
                final assetReferenceReference = assetStore.assets[i];
                children.add(
                  SearchableListTile(
                    searchString: assetReferenceReference.comment ??
                        assetReferenceReference.variableName,
                    child: ListTile(
                      autofocus: i == 0,
                      title: Text('${assetReferenceReference.comment}'),
                      subtitle: Text(assetReferenceReference.variableName),
                      onTap: () => confirm(
                        context: context,
                        message: 'Are you sure you want to delete this asset?',
                      ),
                    ),
                  ),
                );
              }
              return SearchableListView(children: children);
            },
          )
        ],
      ),
    );
  }
}
