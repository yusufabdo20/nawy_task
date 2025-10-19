import 'dart:async';
import 'package:dio/dio.dart';

class ApiService {
  static ApiService? _instance;
  final Dio dio;
  final Future<String?> Function()? tokenProvider;
  final Future<void> Function()? onSessionExpired;
  final Future<bool> Function()? connectivityChecker;
  final void Function(String message)? logger;

  ApiService._internal({
    required this.dio,
    this.tokenProvider,
    this.onSessionExpired,
    this.connectivityChecker,
    this.logger,
  }) {
    _initializeInterceptors();
  }

  /// Initialize and get singleton instance
  static ApiService init({
    required Dio dio,
    Future<String?> Function()? tokenProvider,
    Future<void> Function()? onSessionExpired,
    Future<bool> Function()? connectivityChecker,
    void Function(String message)? logger,
  }) {
    _instance ??= ApiService._internal(
      dio: dio,
      tokenProvider: tokenProvider,
      onSessionExpired: onSessionExpired,
      connectivityChecker: connectivityChecker,
      logger: logger,
    );
    return _instance!;
  }

  /// Access the already initialized instance
  static ApiService get instance {
    if (_instance == null) {
      throw Exception(
        'ApiService not initialized. Call ApiService.init() first.',
      );
    }
    return _instance!;
  }

  void _initializeInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Connectivity check (optional)
          if (connectivityChecker != null) {
            final connected = await connectivityChecker!.call();
            if (!connected) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.connectionError,
                  message: 'No internet connection',
                ),
              );
            }
          }

          // Token injection
          if (tokenProvider != null) {
            final token = await tokenProvider!.call();
            if (token != null &&
                !options.headers.containsKey('Authorization')) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          handler.next(options);
        },
        onResponse: (response, handler) async {
          await _handleSessionExpiration(response);
          handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response != null) {
            await _handleSessionExpiration(error.response!);
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<void> _handleSessionExpiration(Response response) async {
    if (response.statusCode == 401) {
      logger?.call('Session expired (401)');
      if (onSessionExpired != null) await onSessionExpired!.call();
    }
  }

  /// Generic HTTP request with retry and exponential backoff
  Future<dynamic> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) async {
    if (connectivityChecker != null) {
      final connected = await connectivityChecker!.call();
      if (!connected) throw Exception('No internet connection');
    }

    const int maxRetries = 2;
    int attempt = 0;
    DioException? lastError;

    while (attempt <= maxRetries) {
      try {
        final response = await dio.request(
          endpoint,
          options: Options(method: method, headers: headers),
          queryParameters: queryParameters,
          data: data,
        );

        if (response.statusCode != null && response.statusCode! >= 400) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            message: 'HTTP ${response.statusCode}',
          );
        }

        return response.data;
      } on DioException catch (e) {
        lastError = e;
        final transient =
            e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout;

        if (!transient || attempt == maxRetries) rethrow;

        final backoffMs = 300 * (1 << attempt);
        logger?.call('Retrying in ${backoffMs}ms (attempt $attempt)...');
        await Future.delayed(Duration(milliseconds: backoffMs));
        attempt++;
      }
    }
    throw lastError ?? Exception('Unknown network error');
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) => _request(
    'GET',
    endpoint,
    headers: headers,
    queryParameters: queryParameters,
  );

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) => _request(
    'POST',
    endpoint,
    headers: headers,
    queryParameters: queryParameters,
    data: data,
  );

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) => _request(
    'PUT',
    endpoint,
    headers: headers,
    queryParameters: queryParameters,
    data: data,
  );

  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) => _request(
    'PATCH',
    endpoint,
    headers: headers,
    queryParameters: queryParameters,
    data: data,
  );

  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) => _request(
    'DELETE',
    endpoint,
    headers: headers,
    queryParameters: queryParameters,
  );
}
