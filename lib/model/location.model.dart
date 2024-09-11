import 'package:tractian/model/asset.model.dart';
import 'package:tractian/model/company_asset.model.dart';

class Location extends AssetBase {
  Location({
    required super.id,
    required super.name,
    super.parentId,
    super.locationId,
    super.isExpanded,
    super.type = AssetType.location,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
    );
  }
}
