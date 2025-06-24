import 'package:flutter/services.dart' show rootBundle;
import 'package:ini/ini.dart';

class ConfigService {
  late final String clientId;
  late final String clientSecret;

  String get apiBaseUrl => 'http://localhost:3030';
  String get authToken => 'mock-token';

  Future<void> load() async {
    final String iniString = await rootBundle.loadString('assets/config.ini');
    final Config config = Config.fromString(iniString);

    clientId = config.get('spotify', 'client_id')!;
    clientSecret = config.get('spotify', 'client_secret')!;
  }
}

