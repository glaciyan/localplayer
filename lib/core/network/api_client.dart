// lib/core/network/api_client.dart
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({required final String baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl, // Set your default base URL
          connectTimeout: const Duration(seconds: 7),
          receiveTimeout: const Duration(seconds: 7),
        ));

  Future<Response<dynamic>> get(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) async => await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );

  Future<Response<dynamic>> post(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) async => await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
  
  Future<Response<dynamic>> patch(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) async => await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );

  Future<Response<dynamic>> delete(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) async => await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
}