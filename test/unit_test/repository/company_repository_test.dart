import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/data/dio/dio_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian/data/repository/company_repository.dart';
import 'package:tractian/model/company.model.dart';

class DioClientMock extends Mock implements DioClient {}

void main() {
  final DioClient dioClient = DioClientMock();
  test(
    "Should return a list of companies when getCompanies is called",
    () async {
      when(() => dioClient.get('/companies')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: [
            {'id': '1', 'name': 'Company 1'},
            {'id': '2', 'name': 'Company 2'},
          ],
        ),
      );
      final companies = await CompanyRepository(dioClient).getCompanies();
      expect(companies, isA<List<Company>>());
      expect(companies!.length, 2);
    },
  );

  test(
    "Should return null when getCompanies is called and the status code is not 200",
    () async {
      when(() => dioClient.get('/companies')).thenAnswer(
        (_) async => Response(
          statusCode: 400,
          requestOptions: RequestOptions(),
          data: [],
        ),
      );
      final companies = await CompanyRepository(dioClient).getCompanies();
      expect(companies, isNull);
    },
  );

  test(
    "Should return an empty list when getCompanies is called and the data is not a list",
    () async {
      when(() => dioClient.get('/companies')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: {},
        ),
      );
      final companies = await CompanyRepository(dioClient).getCompanies();
      expect(companies, isA<List<Company>>());
      expect(companies!.isEmpty, true);
    },
  );

  test(
    "Should return an empty list when getCompanies is called and the data is null",
    () async {
      when(() => dioClient.get('/companies')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: null,
        ),
      );
      final companies = await CompanyRepository(dioClient).getCompanies();
      expect(companies, isA<List<Company>>());
      expect(companies!.isEmpty, true);
    },
  );
}
