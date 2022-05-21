import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../json/asset_store_reference.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../../validators.dart';
import '../../widgets/cancel.dart';
import '../../widgets/center_text.dart';
import '../../widgets/project_context_state.dart';
import '../../widgets/searchable_list_view.dart';
import '../../widgets/tabbed_scaffold.dart';
import '../../widgets/text_list_tile.dart';
import 'add_asset.dart';

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
  Widget build(final BuildContext context) => Cancel(
        child: CallbackShortcuts(
          bindings: {newShortcut: () => newAsset(context)},
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
                      value: widget.assetStoreReference.comment,
                      onChanged: (final value) {
                        widget.assetStoreReference.comment = value;
                        save();
                      },
                      header: 'Comment',
                      validator: (final value) => validateNonEmptyValue(
                        value: value,
                      ),
                    ),
                    TextListTile(
                      value: widget.assetStoreReference.dartFilename,
                      onChanged: (final value) {
                        widget.assetStoreReference.dartFilename = value;
                        save();
                      },
                      header: 'Dart Filename',
                      validator: (final value) =>
                          validateAssetStoreDartFilename(
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
                  final Widget child;
                  final assets = widget.assetStoreReference.assets;
                  if (assets.isEmpty) {
                    child =
                        const CenterText(text: 'There are no assets to show.');
                  } else {
                    final children = <SearchableListTile>[];
                    for (var i = 0; i < assets.length; i++) {
                      final assetReferenceReference = assets[i];
                      children.add(
                        SearchableListTile(
                          searchString: assetReferenceReference.comment,
                          child: ListTile(
                            autofocus: i == 0,
                            title: Text(assetReferenceReference.comment),
                            subtitle:
                                Text(assetReferenceReference.variableName),
                            onTap: () => confirm(
                              context: context,
                              message:
                                  'Are you sure you want to delete this asset?',
                            ),
                          ),
                        ),
                      );
                    }
                    child = SearchableListView(children: children);
                  }
                  return CallbackShortcuts(
                    bindings: {newShortcut: () => addAsset(context)},
                    child: child,
                  );
                },
                floatingActionButton: FloatingActionButton(
                  autofocus: widget.assetStoreReference.assets.isEmpty,
                  child: addIcon,
                  onPressed: () => newAsset(context),
                  tooltip: 'Add New Asset',
                ),
              )
            ],
          ),
        ),
      );

  /// Import a new asset.
  Future<void> newAsset(final BuildContext context) async {
    await pushWidget(
      context: context,
      builder: (final context) => AddAsset(
        projectContext: projectContext,
        assetStoreReference: widget.assetStoreReference,
      ),
    );
    save();
  }

  /// Add a new asset.
  Future<void> addAsset(final BuildContext context) async {
    await pushWidget(
      context: context,
      builder: (final context) => AddAsset(
        projectContext: projectContext,
        assetStoreReference: widget.assetStoreReference,
      ),
    );
    setState(() {});
  }
}
