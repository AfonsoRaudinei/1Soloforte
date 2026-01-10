import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/security/ssl_pinning_service.dart';
import '../config/env_config.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiUrl, // ✅ Dynamic URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-Key': EnvConfig.apiKey, // ✅ API Key
        },
      ),
    );

    // ✅ Configure SSL Pinning
    if (!kIsWeb) {
      SslPinningService.configurePinning(_dio);
    }

    _setupInterceptors();

    // Print config in debug mode
    if (EnvConfig.isDebug) {
      EnvConfig.printConfig();
    }
  }

  void _setupInterceptors() {
    // Auth Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final token = await SecureStorageService.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 - Token expired
          if (error.response?.statusCode == 401) {
            try {
              // Try to refresh token
              await _refreshToken();

              // Retry original request
              final opts = error.requestOptions;
              final token = await SecureStorageService.getAuthToken();
              opts.headers['Authorization'] = 'Bearer $token';

              final response = await _dio.fetch(opts);
              return handler.resolve(response);
            } catch (e) {
              // Refresh failed, logout user
              await _logout();
              return handler.reject(error);
            }
          }
          return handler.next(error);
        },
      ),
    );

    // Logging Interceptor (only in debug)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) {
          // Only log in debug mode
          if (kDebugMode) {
            debugPrint(obj.toString());
          }
        },
      ),
    );

    // Retry Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (_shouldRetry(error)) {
            try {
              await Future.delayed(const Duration(seconds: 1));
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.response?.statusCode == 503;
  }

  Future<void> _refreshToken() async {
    final refreshToken = await SecureStorageService.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token');

    final response = await _dio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    final newToken = response.data['token'];
    final newRefreshToken = response.data['refreshToken'];

    await SecureStorageService.saveAuthToken(newToken);
    await SecureStorageService.saveRefreshToken(newRefreshToken);
  }

  Future<void> _logout() async {
    await SecureStorageService.clearAll();
    // Navigate to login (via provider)
  }

  // HTTP Methods
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
