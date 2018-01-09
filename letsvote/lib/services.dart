import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:requester/requester.dart';
import 'package:letsvote/model.dart';
import 'package:letsvote/requests.dart' as requests;
import 'package:yaml/yaml.dart';

class AppServices {
  final ConfigService config;
  ElectionService election;
  AppServices(this.config);
}

abstract class ConfigService {
  final Client client;

  ConfigService(this.client);

  Future<AppConfig> loadConfig();

  AppConfig parseYaml(String str) {
    var yaml = loadYaml(str);
    return new AppConfig.fromJson(yaml);
  }
}

class ElectionService {
  final Requester requester;
  final Uri host;

  ElectionService(this.requester, this.host);

  Future<Election> create(String topic) async {
    var request = new requests.CreateElection(host, topic);
    var response = await requester.send(request);
    return new Election.fromJson(JSON.decode(response.body));
  }

  Future<Election> join(String username, String electionId) async {
    var request = new requests.JoinElection(host, username, electionId);
    var response = await requester.send(request);
    return new Election.fromJson(JSON.decode(response.body));
  }
}
