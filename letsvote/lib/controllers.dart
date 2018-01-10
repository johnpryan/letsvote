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
  Election _election;
  AppView _view;
  String _username;
  bool isCreator;

  AppController(this._context);

  Election get election => _election;
  ElectionService get _service => _context.services.election;

  Future init(AppView view) async {
    var config = await _context.services.config.loadConfig();
    var uri = Uri.parse(config.host);
    _context.services.election = new ElectionService(_context.requester, uri);
    _view = view;
    _view.controller = this;
    goTo(Page.home);
  }

  void goTo(Page page) {
    _view.renderPage(page);
  }

  void startByCreating() {
    goTo(Page.create);
  }

  void startByJoining() {
    goTo(Page.joining);
  }

  Future create(String topic) async {
    _election = await _service.create(topic);
    goTo(Page.username);
    isCreator = true;
  }

  Future join(String code) async {
    _election = await _service.get(code);
    goTo(Page.username);
    isCreator = false;
  }

  Future setName(String name) async {
    _election = await _service.join(name, _election.id);
    _username = name;
    goTo(Page.ideaSubmission);
  }

  Future setIdea(String idea) async {
    _election = await _service.submitIdea(_username, idea, _election.id);
    goTo(Page.ideaSubmission);
  }
}

abstract class AppView {
  void renderPage(Page state);
  void set controller(AppController controller);
}

enum Page {
  home, // create or join
  create, // enter topic
  joining, // enter id (skipped if using create)
  username, // enter username
  ideaSubmission,
  ballot,
  result,
}
