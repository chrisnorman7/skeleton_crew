import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:ziggurat/ziggurat.dart';

import '../../constants.dart';
import '../../json/asset_stores/asset_store_reference.dart';
import '../../shortcuts.dart';
import '../../src/project_context.dart';
import '../../util.dart';
import '../../validators.dart';
import '../../widgets/cancel.dart';
import '../../widgets/center_text.dart';
import '../../widgets/project_context_state.dart';
import '../../widgets/push_widget_list_tile.dart';
import '../../widgets/searchable_list_view.dart';
import '../../widgets/sounds/play_sound_semantics.dart';
import '../../widgets/tabbed_scaffold.dart';
import '../../widgets/text_list_tile.dart';
import 'add_asset.dart';
import 'edit_asset.dart';

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
    final actions = [
      ElevatedButton(
        onPressed: () => deleteAssetStore(
          context: context,
          projectContext: projectContext,
          assetStore: widget.assetStoreReference,
          onYes: () => Navigator.pop(context),
        ),
        child: deleteIcon,
      )
    ];
    return Cancel(
      child: CallbackShortcuts(
        bindings: {newShortcut: () => newAsset(context)},
        child: TabbedScaffold(
          tabs: [
            TabbedScaffoldTab(
              actions: actions,
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
                    validator: (final value) => validateAssetStoreDartFilename(
                      value: value,
                      project: projectContext.project,
                    ),
                  )
                ],
              ),
            ),
            TabbedScaffoldTab(
              actions: actions,
              title: 'Assets',
              icon: filesIcon,
              builder: (final context) {
                final Widget child;
                final assets = widget.assetStoreReference.assets;
                if (assets.isEmpty) {
                  child = const CenterText(
                    text: 'There are no assets to show.',
                  );
                } else {
                  final children = <SearchableListTile>[];
                  for (var i = 0; i < assets.length; i++) {
                    final pretendAssetReference = assets[i];
                    final isAudio = pretendAssetReference.isAudio;
                    final assetReference =
                        pretendAssetReference.assetReferenceReference.reference;
                    final variableName = pretendAssetReference.variableName;
                    final comment = pretendAssetReference.comment;
                    final title = '$variableName: $comment';
                    final String assetSize;
                    final assetType = pretendAssetReference.assetType;
                    switch (assetType) {
                      case AssetType.file:
                        final file =
                            assetReference.getFile(projectContext.game.random);
                        assetSize = filesize(file.statSync().size);
                        break;
                      case AssetType.collection:
                        final directory = Directory(
                          path.join(
                            projectContext.directory.path,
                            assetsDirectory,
                          ),
                        );
                        final size = directory
                            .listSync()
                            .whereType<File>()
                            .map<int>(
                              (final e) => e.statSync().size,
                            )
                            .reduce(
                              (final value, final element) => value + element,
                            );
                        assetSize = filesize(size);
                        break;
                    }
                    final subtitle = '${assetType.name} ($assetSize)';
                    children.add(
                      SearchableListTile(
                        searchString: variableName,
                        child: CallbackShortcuts(
                          bindings: {
                            deleteShortcut: () => deleteAssetReference(
                                  context: context,
                                  projectContext: projectContext,
                                  assetReference: pretendAssetReference,
                                  onYes: () => setState(() {}),
                                )
                          },
                          child: PlaySoundSemantics(
                            game: projectContext.game,
                            assetReference: isAudio ? assetReference : null,
                            child: Builder(
                              builder: (final builderContext) =>
                                  PushWidgetListTile(
                                autofocus: i == 0,
                                title: title,
                                subtitle: subtitle,
                                builder: (final context) {
                                  PlaySoundSemantics.of(builderContext)?.stop();
                                  return EditAsset(
                                    projectContext: projectContext,
                                    assetStoreReference:
                                        widget.assetStoreReference,
                                    pretendAssetReference:
                                        pretendAssetReference,
                                  );
                                },
                                onSetState: () => setState(() {}),
                              ),
                            ),
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
  }

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
