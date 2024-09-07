import 'package:tractian/data/dio/dio_client.dart';
import 'package:tractian/model/company_asset.model.dart';

class CompanyAssetRepository {
  final DioClient _dioClient;

  CompanyAssetRepository(this._dioClient);

  /// Get a list of assets from a company.
  /// --------------------------------------
  /// If the request is *successful*, it returns a list of [CompanyAsset].
  /// If the request is *not successful*, it returns *null*.
  /// If the request is *successful but the data is empty or is unexpected*, it returns an *empty list*.
  Future<List<CompanyAsset>?> getAssets(String companyId) async {
    final response = await _dioClient.get(_getAssetsPath(companyId));
    if (response.statusCode != 200 && response.statusCode != 304) return null;
    if (response.data == null || response.data is! List) return [];
    return (response.data as List)
        .map((e) => CompanyAsset.fromJson(e))
        .toList();
  }

  String _getAssetsPath(String companyId) {
    return '/companies/$companyId/assets';
  }
}
