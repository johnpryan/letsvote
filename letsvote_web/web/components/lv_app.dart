@HtmlImport('lv_app.html')
library lv_app;

import 'dart:async';

import 'package:letsvote/services.dart';
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

  String get createTopic => get('createTopic');
  void set createTopic(String s) => set('createTopic', s);

  String get enteredUsername => get('enteredUsername');
  void set enteredUsername(String s) => set('enteredUsername', s);

  String get enteredIdea => get('enteredIdea');
  void set enteredIdea(String s) => set('enteredIdea', s);

  String get enteredCode => get('enteredCode');
  void set enteredCode(String s) => set('enteredCode', s);

  void set topic(String topic) => set('topic', topic);

  void set code(String code) => set('code', code);

  void set voteIdeas(List<String> ideas) => set('voteIdeas', ideas);

  String get selectedVoteIdea => get('selectedVoteIdea');

  void set isCreator(bool b) => set('isCreator', b);

  void set winner(String v) => set('winner', v);

  void set winnerAuthor(String v) => set('winnerAuthor', v);

  void set winnerVotes(int v) => set('winnerVotes', v);

  void set canStartOver(bool v) => set('canStartOver', v);

  void set entryAnimation(String v) => set('entryAnimation', v);

  void set exitAnimation(String v) => set('exitAnimation', v);

  Future<Null> ready() async {
    var client = new BrowserClient();
    var services = new AppServices(new BrowserConfigService(client));
    var appContext = new AppContext(client, services);
    var controller = new AppController(appContext);

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
    canStartOver = _controller?.canStartOver ?? false;
  }

  void set controller(AppController controller) {
    _controller = controller;
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
