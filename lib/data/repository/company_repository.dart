import 'package:tractian/data/dio/dio_client.dart';
import 'package:tractian/model/company.model.dart';

class CompanyRepository {
  final DioClient _dioClient;

  CompanyRepository(this._dioClient);

  /// Get a list of companies.
  /// 
  /// --------------------------------------
  /// If the request is *successful*, it returns a list of [Company].
  /// If the request is *not successful*, it returns *null*.
  /// If the request is *successful but the data is empty or is unexpected*, it returns an *empty list*.
  Future<List<Company>?> getCompanies() async {
    final response = await _dioClient.get('/companies');
    if (response.statusCode != 200 && response.statusCode != 304) return null;
    if (response.data == null || response.data is! List) return [];
    return (response.data as List).map((e) => Company.fromJson(e)).toList();
  }
}
