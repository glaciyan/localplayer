// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'no_connection_exception.dart';

class ApiClient {
  final Dio _dio;
  final Connectivity _connectivity;

  ApiClient({required final String baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 7),
          receiveTimeout: const Duration(seconds: 7),
        ),
      ),
      _connectivity = Connectivity() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (final RequestOptions options, final RequestInterceptorHandler handler) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? token = prefs.getString('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<void> _checkConnection() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      throw NoConnectionException();
    }
  }

  Future<String?> getBearerToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Object? token = prefs.get("token");
    if (token == null && !(token is String)) {
      return null;
    }
    return token as String;
  }

  Future<Response<dynamic>> get(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) async {
    await _checkConnection();
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw NoConnectionException();
      }
      rethrow;
    }
  }

  Future<Response<dynamic>> post(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) async {
    await _checkConnection();
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw NoConnectionException();
      }
      rethrow;
    }
  }

  Future<Response<dynamic>> patch(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) async {
    await _checkConnection();
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw NoConnectionException();
      }
      rethrow;
    }
  }

  Future<Response<dynamic>> delete(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) async {
    await _checkConnection();
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw NoConnectionException();
      }
      rethrow;
    }
  }
}
