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

  void renderPage(Page state) {
    currentPageIndex = state.index;
    topic = _controller?.election?.topic;
  }

  void set controller(AppController controller) {
    _controller = controller;
  }
}
