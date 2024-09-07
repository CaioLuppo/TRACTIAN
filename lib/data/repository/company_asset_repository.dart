import 'package:tractian/data/dio/dio_client.dart';
import 'package:tractian/model/company_asset.model.dart';

class CompanyAssetRepository {
  final DioClient _dioClient;

  CompanyAssetRepository(this._dioClient);

  Future<List<CompanyAsset>?> getAssets(String companyId) async {
    final response = await _dioClient.get(_getAssetsPath(companyId));
    if (response.statusCode != 200 && response.statusCode != 304) return null;
    if (response.data == null || response.data is! List) return [];
    return (response.data as List).map((e) => CompanyAsset.fromJson(e)).toList();
  }

  String _getAssetsPath(String companyId) {
    return '/companies/$companyId/assets';
  }
}
