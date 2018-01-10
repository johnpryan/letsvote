import 'dart:async';

import 'package:http/http.dart';
import 'package:letsvote/model.dart';
import 'package:letsvote/services.dart';
import 'package:requester/requester.dart';

class AppContext {
  final Requester requester;
  final AppServices services;

  AppContext(Client client, this.services) : requester = new Requester(client);
}

class AppController {
  final AppContext _context;
  final StreamController _stateSink;
  AppState _state;
  Election _election;

  AppController(this._context) : _stateSink = new StreamController.broadcast();

  AppState get state => _state;
  Stream get onStateChanged => _stateSink.stream;
  Election get election => _election;

  Future init() async {
    var config = await _context.services.config.loadConfig();
    var uri = Uri.parse(config.host);
    _context.services.election = new ElectionService(_context.requester, uri);
    setState(AppState.home);
  }

  void setState(AppState state) {
    _state = state;
    _stateSink.add(state);
  }

  Future create(String topic) async {
    _election = await _context.services.election.create(topic);
    setState(AppState.joining);
  }

  void showJoiningPage() {
    setState(AppState.joining);
  }

  Future join(String username, String id) {}
}

enum AppState {
  home, // create or join
  create, // enter topic
  joining, // enter id (skipped if using create)
  username, // enter username
  ideaSubmission,
  ballot,
  result,
}
