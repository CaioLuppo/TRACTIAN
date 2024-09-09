import 'package:tractian/model/asset.model.dart';

class CompanyAsset extends AssetBase {
  final String? sensorId;
  final String? gatewayId;
  final AssetStatus? status;
  final String? sensorType;

  CompanyAsset({
    required super.type,
    required super.id,
    required super.name,
    required super.parentId,
    required this.sensorId,
    required this.gatewayId,
    required super.locationId,
    required this.status,
    required this.sensorType,
  });

  factory CompanyAsset.fromJson(Map<String, dynamic> json) {
    final sensorType = json['sensorType'];

    AssetStatus? status;
    try {
      status = AssetStatus.values.firstWhere((e) => e.name == json['status']);
    } catch (e) {
      status = null;
    }

    return CompanyAsset(
      type: sensorType == null ? AssetType.asset : AssetType.component,
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      sensorId: json['sensorId'],
      gatewayId: json['gatewayId'],
      locationId: json['locationId'],
      status: status,
      sensorType: sensorType,
    );
  }
}

enum AssetType {
  asset,
  component,
  location,
}

enum AssetStatus {
  operating,
  alert,
}

enum SensorType {
  vibration,
  energy,
}
