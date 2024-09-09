import 'dart:isolate';

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

class AssetsScreenViewModel {
  final String companyId;
  final BuildContext context;
  List<AssetBase>? tree;

  final CompanyAssetRepository _companyAssetRepository =
      CompanyAssetRepository(DioClient());
  final LocationRepository _locationRepository =
      LocationRepository(DioClient());

  AssetsScreenViewModel(this.companyId, this.context);

  bool? get isLoading {
    return Provider.of<AssetsScreenStore>(context, listen: false).isLoading;
  }

  List<CompanyAsset> get assets {
    return Provider.of<AssetsScreenStore>(context, listen: false).companyAssets;
  }

  List<Location> get locations {
    return Provider.of<AssetsScreenStore>(context, listen: false).locations;
  }

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

  Future<List<AssetBase>> getAssetsTree() async {
    final tree = await buildTreeInIsolate([...locations, ...assets], null);
    Logger().d(_getTreeString(tree));

    return tree;
  }

  // Função recursiva para construir a árvore de pais e filhos
  static List<AssetBase> _buildTree(List<AssetBase> assets, String? parentId) {
    List<AssetBase> tree = [];

    // Filtra os assets que têm o 'parentId' correspondente
    for (var asset in assets.where(
      (a) {
        final parentIdEqual = a.parentId == parentId && a.locationId == null;
        final locationIdEqual = a.locationId == parentId && a.parentId == null;
        return parentIdEqual || locationIdEqual;
      },
    )) {
      // Recursivamente busca os filhos desse nó
      asset.children = _buildTree(assets, asset.id);
      tree.add(asset);
    }

    return tree;
  }

  // Função a ser executada no isolate
  static void _buildTreeIsolate(SendPort sendPort) async {
    // Recebe os dados enviados para o isolate
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (var message in port) {
      final assets = message[0] as List<AssetBase>;
      final parentId = message[1] as String?;
      final responsePort = message[2] as SendPort;

      // Constrói a árvore no isolate
      final tree = _buildTree(assets, parentId);

      // Envia o resultado de volta
      responsePort.send(tree);
    }
  }

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
}
