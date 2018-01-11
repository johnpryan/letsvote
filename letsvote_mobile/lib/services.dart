library letsvote_mobile.services;

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:letsvote/model.dart';
import 'package:letsvote/services.dart';

class FlutterConfigService extends ConfigService {
  FlutterConfigService(Client client) : super(client);

  Future<AppConfig> loadConfig() async {
    var configYaml = await rootBundle.loadString('config.yaml');
    return parseYaml(configYaml);
  }
}
