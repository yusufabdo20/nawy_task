import 'package:dio/dio.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Dio getDio({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    bool enableLogging = true,
    List<Interceptor>? customInterceptors,
  }) {
    if (_dio != null) return _dio!;

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        listFormat: ListFormat.multiCompatible,
        validateStatus: (status) => status != null && status <= 500,
      ),
    );

    if (enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }
    if (customInterceptors != null && customInterceptors.isNotEmpty) {
      dio.interceptors.addAll(customInterceptors);
    }

    _dio = dio;
    return _dio!;
  }

  static void reset() {
    _dio = null;
  }
}
