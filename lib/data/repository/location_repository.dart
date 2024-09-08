import 'package:tractian/data/dio/dio_client.dart';
import 'package:tractian/model/location.model.dart';

class LocationRepository {
  final DioClient _dioClient;

  LocationRepository(this._dioClient);

  /// Get a list of locations from a company.
  /// 
  /// --------------------------------------
  /// If the request is *successful*, it returns a list of [Location].
  /// If the request is *not successful*, it returns *null*.
  /// If the request is *successful but the data is empty or is unexpected*, it returns an *empty list*.
  Future<List<Location>?> getLocations(String companyId) async {
    final response = await _dioClient.get(_getLocationsUrl(companyId));
    if (response.statusCode != 200 && response.statusCode != 304) return null;
    if (response.data == null || response.data is! List) return [];
    return (response.data as List).map((e) => Location.fromJson(e)).toList();
  }

  String _getLocationsUrl(String companyId) {
    return '/companies/$companyId/locations';
  }
}
