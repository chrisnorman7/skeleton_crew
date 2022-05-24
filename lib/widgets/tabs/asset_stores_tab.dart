import 'package:flutter/material.dart';

import '../../screens/asset_stores/edit_asset_store.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../center_text.dart';
import '../push_widget_list_tile.dart';
import '../searchable_list_view.dart';

/// The widget that displays the asset stores.
class AssetStoresTab extends StatefulWidget {
  /// Create an instance.
  const AssetStoresTab({
    required this.projectContext,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// Create state for this widget.
  @override
  AssetStoresTabState createState() => AssetStoresTabState();
}

/// State for [AssetStoresTab].
class AssetStoresTabState extends State<AssetStoresTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final assetStores = widget.projectContext.project.assetStores;
    final Widget child;
    if (assetStores.isEmpty) {
      child = const CenterText(text: 'There are no asset stores yet.');
    } else {
      final children = <SearchableListTile>[];
      for (var i = 0; i < assetStores.length; i++) {
        final assetStoreReference = assetStores[i];
        final numberOfAssets = assetStoreReference.assetStore.assets.length;
        children.add(
          SearchableListTile(
            searchString: assetStoreReference.name,
            child: CallbackShortcuts(
              bindings: {
                deleteShortcut: () => deleteAssetStore(
                      context: context,
                      projectContext: widget.projectContext,
                      assetStore: assetStoreReference,
                    ),
              },
              child: PushWidgetListTile(
                builder: (final context) => EditAssetStore(
                  projectContext: widget.projectContext,
                  assetStoreReference: assetStoreReference,
                ),
                onSetState: () => setState(() {}),
                autofocus: i == 0,
                title: '${assetStoreReference.name} ($numberOfAssets)',
                subtitle: assetStoreReference.comment,
              ),
            ),
          ),
        );
      }
      child = SearchableListView(children: children);
    }
    return CallbackShortcuts(
      bindings: {
        newShortcut: () => createAssetStore(
              context: context,
              projectContext: widget.projectContext,
            )
      },
      child: child,
    );
  }
}
