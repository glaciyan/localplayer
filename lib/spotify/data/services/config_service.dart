import 'package:flutter/services.dart' show rootBundle;
import 'package:ini/ini.dart';

class ConfigService {
  late final String clientId;
  late final String clientSecret;

  Future<void> load() async {
    final iniString = await rootBundle.loadString('assets/config.ini');
    final config = Config.fromString(iniString);

    clientId = config.get('spotify', 'client_id')!;
    clientSecret = config.get('spotify', 'client_secret')!;
  }
}
