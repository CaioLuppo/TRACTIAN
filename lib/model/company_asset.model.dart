class CompanyAsset {
  AssetType type;

  final String id;
  final String name;

  final String? parentId;
  final String? sensorId;
  final String? gatewayId;
  final String? locationId;
  final AssetStatus? status;
  final String? sensorType;

  CompanyAsset({
    required this.type,
    required this.id,
    required this.name,
    required this.parentId,
    required this.sensorId,
    required this.gatewayId,
    required this.locationId,
    required this.status,
    required this.sensorType,
  });

  factory CompanyAsset.fromJson(Map<String, dynamic> json) {
    final sensorType = json['sensorType'];

    return CompanyAsset(
      type: sensorType == null ? AssetType.asset : AssetType.component,
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      sensorId: json['sensorId'],
      gatewayId: json['gatewayId'],
      locationId: json['locationId'],
      status: AssetStatus.values.firstWhere((e) => e.name == json['status']),
      sensorType: sensorType,
    );
  }
}

enum AssetType {
  asset,
  component,
}

enum AssetStatus {
  operating,
  alert,
}
