abstract class IAuthRepository {
  Future<Map<String, dynamic>> signIn(final String name, final String password);
  Future<dynamic> signUp(final String name, final String password);
  Future<dynamic> findMe(final String bearer);
}