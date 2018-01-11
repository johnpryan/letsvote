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
import 'package:polymer_elements/paper_spinner.dart';
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
  String get enteredUsername => get('enteredUsername');
  String get enteredIdea => get('enteredIdea');
  String get enteredCode => get('enteredCode');
  void set topic(String topic) => set('topic', topic);
  void set code(String code) => set('code', code);
  void set voteIdeas(List<String> ideas) => set('voteIdeas', ideas);
  String get selectedVoteIdea => get('selectedVoteIdea');
  void set isCreator(bool b) => set('isCreator', b);
  void set winner(String v) => set('winner', v);
  void set winnerAuthor(String v) => set('winnerAuthor', v);
  void set winnerVotes(int v) => set('winnerVotes',v);

  Future<Null> ready() async {
    var client = new BrowserClient();
    var services = new AppServices(new BrowserConfigService(client));
    var appContext = new AppContext(client, services);
    var controller = new AppController(appContext);

    isLoading = true;
    await controller.init(this);
    isLoading = false;
  }

  @reflectable
  handleStartCreate(e, d) async {
    _controller.startByCreating();
  }

  @reflectable
  handleCreate(e, d) async {
    _controller.create(createTopic);
  }

  @reflectable
  handleJoin(e, d) async {
    _controller.join(enteredCode);
    _controller.goTo(Page.username);
  }

  @reflectable
  handleStartJoin(e, d) async {
    _controller.startByJoining();
  }

  @reflectable
  handleNameEntered(e, d) {
    _controller.setName(enteredUsername);
  }

  @reflectable
  handleIdeaEntered(e, d) {
    _controller.setIdea(enteredIdea);
  }

  @reflectable
  handleVoteEntered(e, d) {
    var idea = this.selectedVoteIdea;
    if (idea == null || idea.isEmpty) {
      return;
    }
    _controller.submitVote(selectedVoteIdea);
  }

  @reflectable
  closePolls(e, d) {
    _controller.submitClose(_controller.election.id);
  }

  void renderPage(Page state) {
    currentPageIndex = state.index;
    topic = _controller?.election?.topic;
    code = _controller?.election?.id;
    voteIdeas =
        _controller?.election?.ideas?.map((i) => i.name)?.toList() ?? [];
    isCreator = _controller?.isCreator;
    winner = _controller?.winnerName;
    winnerAuthor = _controller?.winnerAuthor;
    winnerVotes = _controller?.winnerVotes;
  }

  void set controller(AppController controller) {
    _controller = controller;
  }
}
