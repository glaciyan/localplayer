import 'package:flutter/services.dart' show rootBundle;
import 'package:ini/ini.dart';

class ConfigService {
  late final String clientId;
  late final String clientSecret;
  late final String apiBaseUrl;
  late final String notSecret;

  Future<void> load() async {
    final String iniString = await rootBundle.loadString('assets/config.ini');
    final Config config = Config.fromString(iniString);

    clientId = config.get('spotify', 'client_id')!;
    clientSecret = config.get('spotify', 'client_secret')!;
    apiBaseUrl = config.get('api_base_url', 'http://localplayer.fly.dev')!;
    notSecret = config.get('not_secret', '')!;
  }
}
