import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:logger/logger.dart';

class DioClient {
  // Instance singleton
  static final Dio _dio = Dio();
  static final Logger _logger = Logger();

  final String _baseUrl = 'https://fake-api.tractian.com';

  DioClient() {
    _dio.options.baseUrl = _baseUrl;
    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.refreshForceCache,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
    );
    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }

  /// Performs a GET request to the API.
  Future<Response> get(String path, {String? logId}) async {
    try {
      final response = await _dio.get(path);
      _logResponse(response, 'GET - ${logId ?? path}');
      return response;
    } catch (e) {
      _logger.e('Error on GET - ${logId ?? path}: $e');
      return Response(requestOptions: RequestOptions(path: path), statusCode: -1);
    }
  }

  /// Logs the response of a request with an id. If the status code is not 200, it logs as an error.
  void _logResponse(Response response, String id) {
    if (response.statusCode != 200) {
      _logger.e('Response ($id): ${response.statusCode} - ${response.data}');
      return;
    }
    _logger.i('Response ($id): ${response.statusCode} - ${response.data}');
  }
}
