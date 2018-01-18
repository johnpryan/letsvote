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
  Page _currentPage;

  AppController(this._context);

  Election get election => _election;
  ElectionService get _service => _context.services.election;
  Voter get _currentVoter =>
      _election.voters.firstWhere((v) => v.name == _username);
  String get winnerName => _election?.winner?.name ?? "";
  int get winnerVotes => _election?.winner?.votes ?? 0;
  String get winnerAuthor => _election?.winner?.authorName ?? "";

  Future init(AppView view) async {
    var config = await _context.services.config.loadConfig();
    var uri = Uri.parse(config.host);
    _context.services.election = new ElectionService(_context.requester, uri);
    _view = view;
    _view.controller = this;
    goTo(Page.home);
  }

  Idea _ideaWithName(String name) =>
      _election.ideas.firstWhere((i) => i.name == name, orElse: () => null);

  void goTo(Page page) {
    _currentPage = page;
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
    goTo(Page.ballot);
    _startTimer();
  }

  Future submitVote(String vote) async {
    var voter = this._currentVoter;
    var idea = this._ideaWithName(vote);
    if (idea == null) {
      return;
    }
    _election = await _service.vote(voter.name, idea.name, _election.id);
    goTo(Page.waitingForVotes);
  }

  Future submitClose(String electionId) async {
    _election = await _service.close(_election.id);
    _timer.cancel();
    goTo(Page.result);
  }

  Timer _timer;
  void _startTimer() {
    if (_timer != null) {
      return;
    }
    var dur = new Duration(seconds: 3);
    _timer = new Timer.periodic(dur, (_) => _handlePollUpdate());
  }

  _handlePollUpdate() async {
    _election = await _service.get(_election.id);

    // Re-render the current page
    goTo(_currentPage);

    if (_election.pollsOpen) {
      return;
    }

    goTo(Page.result);
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
  ideaSubmission, // enter an candidate
  ballot, // display each candidate (idea) and pick one
  waitingForVotes, // wait for the polls to close
  result, // show the winner
}
