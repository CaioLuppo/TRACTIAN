import 'package:tractian/model/company_asset.model.dart';

class AssetBase {
  final String id;
  final String name;
  final String? parentId;
  final String? locationId;
  List<AssetBase> children = [];
  AssetType type;

  AssetBase({
    required this.type,
    required this.id,
    required this.name,
    required this.parentId,
    required this.locationId,
  });
}
