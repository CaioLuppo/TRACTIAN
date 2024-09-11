import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tractian/data/dio/dio_client.dart';
import 'package:tractian/data/repository/company_asset_repository.dart';
import 'package:tractian/data/repository/location_repository.dart';
import 'package:tractian/model/asset.model.dart';
import 'package:tractian/model/company_asset.model.dart';
import 'package:tractian/model/location.model.dart';
import 'package:tractian/screens/assets_screen/model/store/assets_screen_store.dart';
import 'package:tractian/screens/assets_screen/model/store/search_store.dart';
import 'package:tractian/screens/assets_screen/view/assets_screen.view.dart';

class AssetsScreenViewModel {
  final String companyId;
  final BuildContext context;
  List<AssetBase>? tree;
  List<TreeNodeWidget>? searchTree;
  String searchText = '';

  final searchResponsePort = ReceivePort();
  final searchResultPort = ReceivePort();
  Isolate? _searchIsolate;
  SendPort? _sendPort;
  static bool alreadySpawned = false;

  AssetsScreenViewModel(this.companyId, this.context) {
    searchResultPort.listen(
      (message) {
        debugPrint('Search result: $message');
        searchTree = message as List<TreeNodeWidget>;
        _store.setIsLoading(false);
      },
    );
  }

  final CompanyAssetRepository _companyAssetRepository =
      CompanyAssetRepository(DioClient());
  final LocationRepository _locationRepository =
      LocationRepository(DioClient());

  // AssetsScreenStore

  AssetsScreenStore get _store {
    return Provider.of<AssetsScreenStore>(context, listen: false);
  }

  bool? get isLoading => _store.isLoading;

  List<CompanyAsset> get assets => _store.companyAssets;

  List<Location> get locations => _store.locations;

  bool get canInteract => _store.canInteract;

  // SearchStore

  SearchStore get _searchStore {
    return Provider.of<SearchStore>(context, listen: false);
  }

  bool get energyFilterEnabled => _searchStore.energyFilterEnabled;

  bool get alertFilterEnabled => _searchStore.alertFilterEnabled;

  /// Load the assets and locations data.
  void loadData() async {
    _store.reset();
    _searchStore.reset();

    _store.setIsLoading(true);

    final locations = await _locationRepository.getLocations(companyId);
    final assets = await _companyAssetRepository.getAssets(companyId);

    if (locations == null && assets == null) {
      _store.setIsLoading(false);
      return;
    }

    if (locations != null) _store.setLocations(locations);
    if (assets != null) _store.setCompanyAssets(assets);

    final rawTree = await getAssetsTree();
    tree = await sortChildrenWithIsolate(rawTree);
    await searchAssetsInTreeInIsolate();

    _store.setCanInteract(true);
    _store.setIsLoading(false);
  }

  /// Sort the assets tree by the following criteria:
  /// - If the asset has children and the other doesn't, the one with children comes first.
  /// - If both have children or don't have children, sort by name.
  static List<AssetBase> sortChildren(List<AssetBase> children) {
    children.sort((a, b) {
      if (a.children.isNotEmpty && b.children.isEmpty) {
        return -1;
      } else if (a.children.isEmpty && b.children.isNotEmpty) {
        return 1;
      } else {
        return a.name.compareTo(b.name);
      }
    });

    for (var child in children) {
      child.children = sortChildren(child.children);
    }

    return children;
  }

  /// Isolate entry point to sort the assets tree.
  static void _sortTreeIsolate(List<dynamic> args) {
    final SendPort sendPort = args[0];
    final List<AssetBase> children = args[1];
    final sortedChildren = sortChildren(children);
    sendPort.send(sortedChildren);
  }

  /// Call the assets tree *sort* method in an isolate, to avoid blocking the main thread.
  Future<List<AssetBase>> sortChildrenWithIsolate(
      List<AssetBase> children) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_sortTreeIsolate, [receivePort.sendPort, children]);
    return await receivePort.first;
  }

  /// Get the assets tree, logging the tree structure.
  Future<List<AssetBase>> getAssetsTree() async {
    final tree = await buildTreeInIsolate([...locations, ...assets], null);
    if (kDebugMode) Logger().d(_getTreeString(tree));

    return tree;
  }

  /// Build the assets tree recursively.
  static List<AssetBase> _buildTree(List<AssetBase> assets, String? parentId) {
    List<AssetBase> tree = [];

    for (var asset in assets.where(
      (a) {
        final parentIdEqual = a.parentId == parentId && a.locationId == null;
        final locationIdEqual = a.locationId == parentId && a.parentId == null;
        return parentIdEqual || locationIdEqual;
      },
    )) {
      asset.children = _buildTree(assets, asset.id);
      tree.add(asset);
    }

    return tree;
  }

  /// Handle the assets tree build in an isolate.
  static void _buildTreeIsolate(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (var message in port) {
      final assets = message[0] as List<AssetBase>;
      final parentId = message[1] as String?;
      final responsePort = message[2] as SendPort;

      final tree = _buildTree(assets, parentId);

      responsePort.send(tree);
    }
  }

  /// Call the assets tree *build* method in an isolate, to avoid blocking the main thread.
  Future<List<AssetBase>> buildTreeInIsolate(
      List<AssetBase> assets, String? parentId) async {
    final responsePort = ReceivePort();

    final isolate = await Isolate.spawn(
      _buildTreeIsolate,
      responsePort.sendPort,
    );

    final sendPort = await responsePort.first as SendPort;

    final resultPort = ReceivePort();
    sendPort.send([assets, parentId, resultPort.sendPort]);

    final tree = await resultPort.first as List<AssetBase>;

    isolate.kill();

    return tree;
  }

  /// Search assets in the tree and return a new tree with the search results.
  static List<TreeNodeWidget> _startSearchingAssetsInTree(
    List<TreeNodeWidget> tree,
    String name, {
    required bool alertFilterEnabled,
    required bool energyFilterEnabled,
  }) {
    List<TreeNodeWidget> result = [];

    for (var treeNode in tree) {
      final asset = treeNode.node;
      final matchFilters =
          name.isNotEmpty || alertFilterEnabled || energyFilterEnabled;
      if (asset.children.isNotEmpty) {
        final children = _startSearchingAssetsInTree(
          asset.children.map((e) => TreeNodeWidget(node: e)).toList(),
          name,
          alertFilterEnabled: alertFilterEnabled,
          energyFilterEnabled: energyFilterEnabled,
        );

        if (children.isNotEmpty) {
          result.add(
            TreeNodeWidget(
              isExpanded: matchFilters,
              node: AssetBase(
                type: asset.type,
                id: asset.id,
                name: asset.name,
                parentId: asset.parentId,
                locationId: asset.locationId,
                childrenDelegate: children.map((e) => e.node).toList(),
              ),
            ),
          );
          continue;
        }
      }
      if (!asset.name.toLowerCase().contains(name.toLowerCase()) &&
          name.isNotEmpty) {
        continue;
      }

      if (alertFilterEnabled || energyFilterEnabled) {
        if (asset is! CompanyAsset) {
          continue;
        }

        if (alertFilterEnabled && asset.status != AssetStatus.alert) {
          continue;
        }

        if (energyFilterEnabled && asset.sensorType != SensorType.energy.name) {
          continue;
        }
      }

      if (asset is CompanyAsset) {
        result.add(
          TreeNodeWidget(
            isExpanded: matchFilters,
            node: CompanyAsset(
              type: asset.type,
              id: asset.id,
              name: asset.name,
              parentId: asset.parentId,
              sensorId: asset.sensorId,
              gatewayId: asset.gatewayId,
              locationId: asset.locationId,
              status: asset.status,
              sensorType: asset.sensorType,
            )..children = asset.children,
          ),
        );
      } else {
        result.add(
          TreeNodeWidget(
            isExpanded: matchFilters,
            node: Location(
              type: asset.type,
              id: asset.id,
              name: asset.name,
              parentId: asset.parentId,
              locationId: asset.locationId,
            )..children = asset.children,
          ),
        );
      }
    }

    return result;
  }

  /// Search assets in the tree and return a new tree with the search results.
  static void _searchAssetsInTreeIsolate(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (var message in port) {
      final tree = message[0] as List<TreeNodeWidget>;
      final name = message[1] as String;
      final alertFilterEnabled = message[2] as bool;
      final energyFilterEnabled = message[3] as bool;
      final responsePort = message[4] as SendPort;

      final search = _startSearchingAssetsInTree(
        tree,
        name,
        alertFilterEnabled: alertFilterEnabled,
        energyFilterEnabled: energyFilterEnabled,
      );

      responsePort.send(search);
    }
  }

  /// Call the search assets in tree method in an isolate, to avoid blocking the main thread.
  Future<void> searchAssetsInTreeInIsolate() async {
    _store.setIsLoading(true);
    await Future.delayed(
        const Duration(milliseconds: 100), () {}); // Grants tile expansion
    if (!alreadySpawned) {
      alreadySpawned = true;
      _searchIsolate ??= await Isolate.spawn(
        _searchAssetsInTreeIsolate,
        searchResponsePort.sendPort,
      );
      _sendPort ??= await searchResponsePort.first as SendPort;
    }
    _sendPort?.send([
      tree?.map((e) => TreeNodeWidget(node: e)).toList() ?? [],
      searchText,
      alertFilterEnabled,
      energyFilterEnabled,
      searchResultPort.sendPort,
    ]);
  }

  /// Return a string representation of the tree for debugging purposes.
  String _getTreeString(List<AssetBase> tree, [int level = 0]) {
    StringBuffer buffer = StringBuffer();

    if (level == 0) {
      buffer.writeln(
        '\n\x1B[32m -------------------------- Assets Tree --------------------------\x1B[0m\n',
      );
    }

    for (var asset in tree) {
      buffer.writeln('\x1B[32m${'  ' * level}- ${asset.name}\x1B[0m');
      buffer.write(_getTreeString(asset.children, level + 1));
    }

    return buffer.toString();
  }

  /// Dispose the isolate when the view model is disposed.
  void dispose() {
    _searchIsolate?.kill();
  }
}
