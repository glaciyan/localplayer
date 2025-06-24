abstract class IAuthController {
  Future<dynamic> signIn(final String name, final String password);
  Future<dynamic> signUp(final String name, final String password);
  Future<dynamic> findMe();
}