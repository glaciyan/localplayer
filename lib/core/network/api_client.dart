import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:localplayer/core/network/api_error_exception.dart';
import 'package:localplayer/main.dart';
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
        onRequest: (
          final RequestOptions options,
          final RequestInterceptorHandler handler,
        ) async {
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
    final String? token = prefs.getString("token");
    return token?.isNotEmpty == true ? token : null;
  }

  Future<Response<dynamic>> _request(
    final Future<Response<dynamic>> Function() requestFn,
  ) async {
    try {
      await _checkConnection();
      return await requestFn();
    } on NoConnectionException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw NoConnectionException();
      }
      throw _handleApiError(e);
    } catch (e, st) {
      log.e("Failed api request", error: e, stackTrace: st);
      throw ApiErrorException();
    }
  }

  Future<Response<dynamic>> get(
    final String path, {
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) => _request(
    () => _dio.get(path, queryParameters: queryParameters, options: options),
  );

  Future<Response<dynamic>> post(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) => _request(
    () => _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  Future<Response<dynamic>> patch(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) => _request(
    () => _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  Future<Response<dynamic>> delete(
    final String path, {
    final dynamic data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
  }) => _request(
    () => _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    ),
  );

  ApiErrorException _handleApiError(final DioException e) {
    if (e.response?.statusCode == 400) {
      final dynamic data = e.response?.data;
      String message = "Unexpected Error";
      String ecode = "Unexpected Error";
      if (data is Map<String, dynamic>) {
        final dynamic msg = data['message'];
        if (msg is String) {
          message = msg;
        }
        final dynamic code = data['code'];
        if (code is String) {
          ecode = code;
        }
      }
      return new ApiErrorException(message, ecode);
    }

    return new ApiErrorException();
  }
}
