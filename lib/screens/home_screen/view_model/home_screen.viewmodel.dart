import 'package:tractian/data/dio/dio_client.dart';
import 'package:tractian/data/repository/company_repository.dart';
import 'package:tractian/model/company.model.dart';

class HomeScreenViewModel {
  final CompanyRepository _companyRepository = CompanyRepository(DioClient());

  /// Get companies from the API.
  Future<List<Company>?> getCompanies() async {
    return await _companyRepository.getCompanies();
  }
}
