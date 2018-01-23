import 'dart:async';

abstract class AppPresenter {
  Future init(AppView view);
  void setView(AppView view);
  void startOver();
  bool get isHomePage;
}

/// A view used by [AppController] to switch to each page and show errors.
abstract class AppView {
  void renderPage(Page state);
  void set controller(AppPresenter controller);
  void showError(String message);
  void set isLoading(bool loading);
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