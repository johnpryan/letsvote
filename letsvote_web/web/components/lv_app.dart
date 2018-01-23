@HtmlImport('lv_app.html')
library lv_app;

import 'dart:async';

import 'package:letsvote/services.dart';
import 'package:letsvote/views.dart';
import 'package:letsvote_web/services.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:http/browser_client.dart';
import 'package:letsvote/controllers.dart';

//ignore: unused_import
import 'package:polymer_elements/paper_styles.dart';

//ignore: unused_import
import 'package:polymer_elements/paper_toolbar.dart';

//ignore: unused_import
import 'package:polymer_elements/paper_dialog.dart';

//ignore: unused_import
import 'package:polymer_elements/paper_card.dart';

//ignore: unused_import
import 'package:polymer_elements/neon_animated_pages.dart';

// ignore: unused_import
import 'package:polymer_elements/neon_animatable.dart';

// ignore: unused_import
import 'package:polymer_elements/neon_animation.dart';

// ignore: unused_import
import 'package:polymer_elements/iron_flex_layout.dart';

// ignore: unused_import
import 'package:polymer_elements/paper_progress.dart';

//ignore: unused_import
import 'package:polymer_elements/paper_input.dart';

//ignore: unused_import
import 'package:polymer_elements/paper_button.dart';

//ignore: unused_import
import 'package:polymer_elements/paper_radio_group.dart';

//ignore: unused_import
import 'package:polymer_elements/paper_radio_button.dart';

@PolymerRegister(LvApp.tag)
class LvApp extends PolymerElement implements AppView {
  static const String tag = 'lv-app';

  AppController _controller;

  void set currentPageIndex(int i) => set('currentPageIndex', i);

  void set isLoading(bool l) => set('isLoading', l);

  LvApp.created() : super.created();

  // Polymer properties
  get createTopic => get('createTopic');
  set createTopic(String s) => set('createTopic', s);
  get enteredUsername => get('enteredUsername');
  set enteredUsername(String s) => set('enteredUsername', s);
  get enteredIdea => get('enteredIdea');
  set enteredIdea(String s) => set('enteredIdea', s);
  get enteredCode => get('enteredCode');
  set enteredCode(String s) => set('enteredCode', s);
  set topic(String topic) => set('topic', topic);
  set code(String code) => set('code', code);
  set voteIdeas(List<String> ideas) => set('voteIdeas', ideas);
  get selectedVoteIdea => get('selectedVoteIdea');
  set isCreator(bool b) => set('isCreator', b);
  set winner(String v) => set('winner', v);
  set winnerAuthor(String v) => set('winnerAuthor', v);
  set winnerVotes(int v) => set('winnerVotes', v);
  set showRestart(bool v) => set('canStartOver', v);
  set entryAnimation(String v) => set('entryAnimation', v);
  set exitAnimation(String v) => set('exitAnimation', v);

  Future<Null> ready() async {
    var client = new BrowserClient();
    var configService = new BrowserConfigService(client);
    var services = new AppServices(client, configService);
    var controller = new AppController(services);

    await controller.init(this);
  }

  @reflectable
  handleStartCreate(e, d) async {
    _controller.startByCreating();
  }

  @reflectable
  handleCreate(e, d) async {
    await _controller.create(createTopic);
  }

  @reflectable
  handleJoin(e, d) async {
    await _controller.join(enteredCode);
    _controller.goTo(Page.username);
  }

  @reflectable
  handleStartJoin(e, d) async {
    _controller.startByJoining();
  }

  @reflectable
  handleNameEntered(e, d) async {
    await _controller.setName(enteredUsername);
  }

  @reflectable
  handleIdeaEntered(e, d) async {
    await _controller.setIdea(enteredIdea);
  }

  @reflectable
  handleVoteEntered(e, d) async {
    var idea = this.selectedVoteIdea;
    if (idea == null || idea.isEmpty) {
      return;
    }
    await _controller.submitVote(selectedVoteIdea);
  }

  @reflectable
  closePolls(e, d) {
    _controller.submitClose(_controller.election.id);
  }

  @reflectable
  handleStartOver(e, d) {
    createTopic = "";
    enteredIdea = "";
    enteredUsername = "";
    enteredCode = "";
    _controller.startOver();
  }

  void renderPage(Page page) {
    _setAnimations(page);

    currentPageIndex = page.index;
    topic = _controller?.election?.topic;
    code = _controller?.election?.id;
    voteIdeas =
        _controller?.election?.ideas?.map((i) => i.name)?.toList() ?? [];
    isCreator = _controller?.isCreator;
    winner = _controller?.winnerName;
    winnerAuthor = _controller?.winnerAuthor;
    winnerVotes = _controller?.winnerVotes;
    showRestart = _controller?.isHomePage != true;
  }

  void set controller(AppPresenter presenter) {
    _controller = presenter;
  }

  void showError(String message) {
    set('dialogMessage', message);
    ($$('#dialog') as PaperDialog).open();
  }

  Page _lastPage;
  void _setAnimations(Page newPage) {
    if (_lastPage != null && _lastPage.index < newPage.index) {
      entryAnimation = "slide-from-right-animation";
      exitAnimation = "slide-left-animation";
    } else {
      entryAnimation = "slide-from-left-animation";
      exitAnimation = "slide-right-animation";
    }
    _lastPage = newPage;
  }
}
