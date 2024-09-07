import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tractian/data/dio/dio_client.dart';
import 'package:tractian/data/repository/company_asset_repository.dart';
import 'package:tractian/model/company_asset.model.dart';

class DioClientMock extends Mock implements DioClient {}

void main() {
  final DioClient dioClient = DioClientMock();

  final mockData = [
    {
      "id": "656734821f4664001f296973",
      "name": "Fan - External",
      "parentId": null,
      "sensorId": "MTC052",
      "sensorType": "energy",
      "status": "operating",
      "gatewayId": "QHI640",
      "locationId": null
    },
    {
      "id": "656a07bbf2d4a1001e2144c2",
      "name": "CONVEYOR BELT ASSEMBLY",
      "locationId": "656a07b3f2d4a1001e2144bf"
    },
    {
      "id": "656a07cdc50ec9001e84167b",
      "name": "MOTOR RT COAL AF01",
      "parentId": "656a07c3f2d4a1001e2144c5",
      "sensorId": "FIJ309",
      "sensorType": "vibration",
      "status": "operating",
      "gatewayId": "FRH546"
    },
  ];

  test(
    'Should return a list of CompanyAssets when request code 200 and data isNotEmpty',
    () async {
      when(() => dioClient.get('/companies/1/assets')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: mockData,
        ),
      );
      final assets = await CompanyAssetRepository(dioClient).getAssets('1');
      expect(assets, isA<List<CompanyAsset>>());
      expect(assets!.length, 3);
    },
  );

  test(
    'Should have null sensorType when json\'s sensorType is null, and needs to be an asset type',
    () async {
      when(() => dioClient.get('/companies/1/assets')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: mockData,
        ),
      );
      final assets = await CompanyAssetRepository(dioClient).getAssets('1');
      expect(assets, isA<List<CompanyAsset>>());
      expect(assets![1].sensorType, isNull);
      expect(assets[1].type, AssetType.asset);
    },
  );

  test(
    'Should be a component if has sensorType',
    () async {
      when(() => dioClient.get('/companies/1/assets')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: mockData,
        ),
      );
      final assets = await CompanyAssetRepository(dioClient).getAssets('1');
      expect(assets, isA<List<CompanyAsset>>());
      expect(assets![0].type, AssetType.component);
    },
  );

  test(
    'Should return null when request code is not 200',
    () async {
      when(() => dioClient.get('/companies/1/assets')).thenAnswer(
        (_) async => Response(
          statusCode: 400,
          requestOptions: RequestOptions(),
          data: [],
        ),
      );
      final assets = await CompanyAssetRepository(dioClient).getAssets('1');
      expect(assets, isNull);
    },
  );

  test(
    'Should return an empty list when data is not a list',
    () async {
      when(() => dioClient.get('/companies/1/assets')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: {},
        ),
      );
      final assets = await CompanyAssetRepository(dioClient).getAssets('1');
      expect(assets, isA<List<CompanyAsset>>());
      expect(assets!.isEmpty, true);
    },
  );

  test(
    'Should return an empty list when data is null',
    () async {
      when(() => dioClient.get('/companies/1/assets')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: null,
        ),
      );
      final assets = await CompanyAssetRepository(dioClient).getAssets('1');
      expect(assets, isA<List<CompanyAsset>>());
      expect(assets!.isEmpty, true);
    },
  );

  test(
    'Should return an empty list when data is empty',
    () async {
      when(() => dioClient.get('/companies/1/assets')).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(),
          data: [],
        ),
      );
      final assets = await CompanyAssetRepository(dioClient).getAssets('1');
      expect(assets, isA<List<CompanyAsset>>());
      expect(assets!.isEmpty, true);
    },
  );
}
