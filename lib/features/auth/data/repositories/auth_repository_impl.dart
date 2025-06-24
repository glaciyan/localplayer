import 'package:localplayer/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:localplayer/features/auth/data/IAuthRepository.dart';
import 'package:localplayer/spotify/data/services/config_service.dart';

class AuthRepository implements IAuthRepository {
  final AuthRemoteDataSource _dataSource;
  final ConfigService config;

  AuthRepository(this._dataSource, this.config);

  @override
  Future<dynamic> signIn(final String name, final String password) async =>
      await _dataSource.signIn(name, password, config.notSecret);

  @override
  Future<dynamic> signUp(final String name, final String password) async =>
      await _dataSource.signUp(name, password, config.notSecret);
}
