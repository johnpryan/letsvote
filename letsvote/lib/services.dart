import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:requester/requester.dart';
import 'package:letsvote/model.dart';
import 'package:letsvote/requests.dart' as requests;
import 'package:yaml/yaml.dart';

class AppServices {
  final Client client;
  final ConfigService config;
  final Requester requester;

  ElectionService election;

  AppServices(this.client, this.config) : requester = new Requester(client);

  void createElectionService(Uri host) {
    election = new ElectionService(requester, host);
  }
}

/// [ConfigService] is used to allow apps to be configured to run against other
/// servers.
///
/// Loads and parses a YAML configuration into an [AppConfig]
abstract class ConfigService {
  final Client client;

  ConfigService(this.client);

  Future<AppConfig> loadConfig();

  AppConfig parseYaml(String str) {
    var yaml = loadYaml(str);
    return new AppConfig.fromJson(yaml);
  }
}

/// Makes HTTP requests to perform various operations on an election. Each
/// method returns the latest state of the [Election].
class ElectionService {
  final Requester requester;
  final Uri host;

  ElectionService(this.requester, this.host);

  Future<Election> create(String topic) async {
    var request = new requests.CreateElection(host, topic);
    var response = await requester.send(request);
    return new Election.fromJson(JSON.decode(response.body));
  }

  Future<Election> get(String id) async {
    var request = new requests.GetElection(host, id);
    var response = await requester.send(request);
    return new Election.fromJson(JSON.decode(response.body));
  }

  Future<Election> join(String username, String electionId) async {
    var request = new requests.JoinElection(host, username, electionId);
    var response = await requester.send(request);
    return new Election.fromJson(JSON.decode(response.body));
  }

  Future<Election> submitIdea(
      String username, String idea, String electionId) async {
    var request = new requests.SubmitIdea(host, username, idea, electionId);
    var response = await requester.send(request);
    return new Election.fromJson(JSON.decode(response.body));
  }

  Future<Election> vote(String username, String idea, String electionId) async {
    var request = new requests.Vote(host, username, idea, electionId);
    var response = await requester.send(request);
    return new Election.fromJson(JSON.decode(response.body));
  }

  Future<Election> close(String electionId) async {
    var request = new requests.Close(host, electionId);
    var response = await requester.send(request);
    return new Election.fromJson(JSON.decode(response.body));
  }
}
