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

  AssetsScreenViewModel(this.companyId, this.context);

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

  // SearchStore

  SearchStore get _searchStore {
    return Provider.of<SearchStore>(context, listen: false);
  }

  bool get energyFilterEnabled => _searchStore.energyFilterEnabled;

  bool get alertFilterEnabled => _searchStore.alertFilterEnabled;

  /// Load the assets and locations data.
  void loadData() async {
    final store = Provider.of<AssetsScreenStore>(context, listen: false);

    store.setIsLoading(true);

    final locations = await _locationRepository.getLocations(companyId);
    final assets = await _companyAssetRepository.getAssets(companyId);

    if (locations != null) store.setLocations(locations);
    if (assets != null) store.setCompanyAssets(assets);

    final rawTree = await getAssetsTree();
    tree = sortChildren(rawTree);

    store.setIsLoading(false);
  }

  /// Sort the assets tree by the following criteria:
  /// - If the asset has children and the other doesn't, the one with children comes first.
  /// - If both have children or don't have children, sort by name.
  List<AssetBase> sortChildren(List<AssetBase> children) {
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

  /// Call the assets tree build method in an isolate, to avoid blocking the main thread.
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

  /// Search assets in the tree and return a new tree with the search results.
  List<TreeNodeWidget> startSearchingAssetsInTree(
    List<TreeNodeWidget> tree,
    String name, {
    required bool alertFilterEnabled,
    required bool energyFilterEnabled,
  }) {
    List<TreeNodeWidget> result = [];

    for (var treeNode in tree) {
      final asset = treeNode.node;
      final matchFilters =
          asset.name.toLowerCase().contains(name.toLowerCase()) &&
                  name.isNotEmpty ||
              alertFilterEnabled ||
              energyFilterEnabled;
      if (asset.children.isNotEmpty) {
        final children = startSearchingAssetsInTree(
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

  /// Start the search process and set the loading state.
  List<TreeNodeWidget> searchAssetsInTree(
    List<TreeNodeWidget> tree,
    String name, {
    required bool alertFilterEnabled,
    required bool energyFilterEnabled,
  }) {
    _store.setIsLoading(true);
    final search = startSearchingAssetsInTree(
      tree,
      name,
      alertFilterEnabled: alertFilterEnabled,
      energyFilterEnabled: energyFilterEnabled,
    );
    _store.setIsLoading(false);
    return search;
  }

  void dispose() {
    _store.dispose();
    _searchStore.dispose();
  }
}
