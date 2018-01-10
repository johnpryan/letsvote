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
class LvApp extends PolymerElement {
  static const String tag = 'lv-app';

  AppController controller;

  void set currentPageIndex(int i) => set('currentPageIndex', i);
  void set isLoading(bool l) => set('isLoading', l);

  LvApp.created() : super.created();

  String get topic => get('topic');

  Future<Null> ready() async {
    var client = new BrowserClient();
    var services = new AppServices(new BrowserConfigService(client));
    var appContext = new AppContext(client, services);
    controller = new AppController(appContext);
    controller.onStateChanged.listen(_handleAppStateChanged);

    isLoading = true;
    await controller.init();
    isLoading = false;
  }

  void _handleAppStateChanged(AppState state) {
    currentPageIndex = state.index;
  }

  @reflectable
  handleCreate(e, d) async {
    await controller.create(this.topic);
  }

  @reflectable
  handleJoin(e, d) async {
    controller.showJoiningPage();
  }
}
