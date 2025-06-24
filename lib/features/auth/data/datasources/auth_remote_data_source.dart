import 'package:localplayer/core/network/api_client.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<dynamic> signIn(final String name, final String password, final String notSecret) async {
    await apiClient.post(
      '/user/login', 
      data: <String, String> {'name': name, 'password': password},
      options: Options(headers: <String, String> {'not_secret': notSecret}),
    );
  }

  Future<dynamic> signUp(final String name, final String password, final String notSecret) async {
    await apiClient.post(
      '/user/signup', 
      data: <String, String> {'name': name, 'password': password},
      options: Options(headers: <String, String> {'not_secret': notSecret}),
    );
  }
}