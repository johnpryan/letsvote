library letsvote_web.services;

import 'dart:async';
import 'dart:html' hide Client;

import 'package:http/http.dart';
import 'package:letsvote/model.dart';
import 'package:letsvote/services.dart';

class BrowserConfigService extends ConfigService {
  BrowserConfigService(Client c) : super(c);

  Future<AppConfig> loadConfig() async {
    var host = Uri.parse(window.location.href);
    var u = host.replace(path: '/config.yaml');
    var response = await client.get(u);
    return parseYaml(response.body);
  }
}
