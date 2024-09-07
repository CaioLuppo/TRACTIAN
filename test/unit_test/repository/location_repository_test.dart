import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tractian/data/dio/dio_client.dart';
import 'package:tractian/data/repository/location_repository.dart';
import 'package:tractian/model/location.model.dart';

class DioClientMock extends Mock implements DioClient {}

void main() {
  final DioClient dioClient = DioClientMock();

  final mockData = [
    {
      "id": "65674204664c41001e91ecb4",
      "name": "PRODUCTION AREA - RAW MATERIAL",
      "parentId": null
    },
    {
      "id": "656a07b3f2d4a1001e2144bf",
      "name": "CHARCOAL STORAGE SECTOR",
      "parentId": "65674204664c41001e91ecb4"
    }
  ];

  test(
    "Should return a list of Locations when request code 200 and data isNotEmpty",
    () async {
      when(() => dioClient.get('/companies/1/locations')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: mockData,
        ),
      );
      final locations = await LocationRepository(dioClient).getLocations('1');
      expect(locations, isA<List<Location>>());
      expect(locations!.length, 2);
      debugPrint(locations.map((e) => e.name).toString());
    },
  );

  test(
    "Should return an empty list when request code 200 and data is an empty list",
    () async {
      when(() => dioClient.get('/companies/1/locations')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: [],
        ),
      );
      final locations = await LocationRepository(dioClient).getLocations('1');
      expect(locations, isA<List<Location>>());
      expect(locations!.isEmpty, true);
    },
  );

  test(
    "Should return null when request code is different from 200 and 304",
    () async {
      when(() => dioClient.get('/companies/1/locations')).thenAnswer(
        (_) async => Response(
          statusCode: 404,
          requestOptions: RequestOptions(),
        ),
      );
      final locations = await LocationRepository(dioClient).getLocations('1');
      expect(locations, null);
    },
  );

  test(
    "Should return emptyList when data is null",
    () async {
      when(() => dioClient.get('/companies/1/locations')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: null,
        ),
      );
      final locations = await LocationRepository(dioClient).getLocations('1');
      expect(locations?.isEmpty, true);
    },
  );

  test(
    "Should return emptyList when data is not a list",
    () async {
      when(() => dioClient.get('/companies/1/locations')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: {},
        ),
      );
      final locations = await LocationRepository(dioClient).getLocations('1');
      expect(locations?.isEmpty, true);
    },
  );
}
