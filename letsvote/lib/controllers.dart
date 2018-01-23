import 'dart:async';

import 'package:letsvote/model.dart';
import 'package:letsvote/services.dart';
import 'package:letsvote/views.dart';

/// The logic four our app.
class AppController implements AppPresenter {
  AppServices _services;
  Election _election;
  AppView _view;
  String _username;
  bool isCreator;
  Page _currentPage;

  AppController(this._services);

  Election get election => _election;
  ElectionService get _service => _services.election;
  Voter get _currentVoter =>
      _election.voters.firstWhere((v) => v.name == _username);
  String get winnerName => _election?.winner?.name ?? "";
  int get winnerVotes => _election?.winner?.votes ?? 0;
  String get winnerAuthor => _election?.winner?.authorName ?? "";

  Future init(AppView view) async {
    view.isLoading = true;

    // Load the app configuration
    var config = await _services.config.loadConfig();
    var uri = Uri.parse(config.host);

    // Create the election service
    _services.createElectionService(uri);

    // Show the Home page
    setView(view);
    goTo(Page.home);

    view.isLoading = false;
  }

  void setView(AppView view) {
    _view = view;
    _view.controller = this;
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

  /// Creates a new election and makes the current user the owner.
  Future create(String topic) async {
    _loadWithException(_create(topic), "Unable to create vote");
  }

  Future _create(String topic) async {
    _election = await _service.create(topic);
    goTo(Page.username);
    isCreator = true;
  }

  /// Joins an election given a [code]
  Future join(String code) async {
    _loadWithException(
        _join(code),
        "Sorry, we were unable to find that vote."
        " Make sure the code you entered is correct.");
  }

  Future _join(String code) async {
    _election = await _service.get(code);
    goTo(Page.username);
    isCreator = false;
  }

  /// Adds a new user to the election.
  Future setName(String name) async {
    await _loadWithException(_setName(name), "That username is already taken");
  }

  Future _setName(String name) async {
    _election = await _service.join(name, _election.id);
    _username = name;
    goTo(Page.ideaSubmission);
  }

  /// Submits an idea to the current election.
  Future setIdea(String idea) async {
    _loadWithException(_setIdea(idea), "Something went wrong");
  }

  Future _setIdea(String idea) async {
    _election = await _service.submitIdea(_username, idea, _election.id);
    goTo(Page.ballot);
    // Poll the election on an interval
    _startTimer();
  }

  Future submitVote(String vote) async {
    _loadWithException(_submitVote(vote), "Something went wrong");
  }

  Future _submitVote(String vote) async {
    var voter = this._currentVoter;
    var idea = this._ideaWithName(vote);
    if (idea == null) {
      return;
    }
    _election = await _service.vote(voter.name, idea.name, _election.id);
    goTo(Page.waitingForVotes);
  }

  Future submitClose(String electionId) async {
    _loadWithException(_submitClose(electionId), "Something went wrong");
  }

  Future _submitClose(String electionId) async {
    _election = await _service.close(_election.id);
    _timer.cancel();
    goTo(Page.result);
  }

  bool get isHomePage {
    return this._currentPage == null || this._currentPage == Page.home;
  }

  void startOver() {
    _timer?.cancel();
    _timer = null;
    _election = null;
    _username = "";
    isCreator = false;
    goTo(Page.home);
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

  /// Runs the [operation] and alerts the view if there is an
  /// exception.
  Future _loadWithException(Future operation, String message) async {
    _view.isLoading = true;
    try {
      await operation;
    } catch (e) {
      _view.showError(message);
    } finally {
      _view.isLoading = false;
    }
  }
}
