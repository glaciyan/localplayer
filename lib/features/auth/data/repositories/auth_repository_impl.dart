import 'package:localplayer/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:localplayer/features/auth/data/IAuthRepository.dart';

class AuthRepository implements IAuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepository(this._dataSource);

  @override
  Future<dynamic> signIn(final String name, final String password) async => await _dataSource.signIn(name, password);

  @override
  Future<dynamic> signUp(final String name, final String password) async => await _dataSource.signUp(name, password);
}