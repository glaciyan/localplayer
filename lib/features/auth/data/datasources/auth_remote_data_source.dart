import 'package:localplayer/core/network/api_client.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<Map<String, dynamic>> signIn(final String name, final String password, final String notSecret) async {
    final Response<dynamic> response = await apiClient.post(
      '/user/login', 
      data: <String, String> {'name': name, 'password': password},
      options: Options(headers: <String, String> {'not_secret': notSecret}),
    );

    return response.data as Map<String, dynamic>;
  }

  Future<dynamic> signUp(final String name, final String password, final String notSecret) async {
    await apiClient.post(
      '/user/signup',
      data: <String, String> {'name': name, 'password': password},
      options: Options(headers: <String, String> {'not_secret': notSecret}),
    );
  }

  Future<dynamic> findMe() async => await apiClient.get("/profile/me");
}