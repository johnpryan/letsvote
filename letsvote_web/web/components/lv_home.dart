@HtmlImport('lv_home.html')
library lv_home;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

//ignore: unused_import
import 'package:polymer_elements/paper_input.dart';
//ignore: unused_import
import 'package:polymer_elements/paper_button.dart';

import 'proxies.dart';

@PolymerRegister(LvHome.tag)
class LvHome extends PolymerElement {
  static const String tag = 'lv-home';

  @property
  AppControllerProxy controller;

  String get topic => get('topic');

  LvHome.created() : super.created();

  @reflectable
  handleCreate(e, d) async {
    await controller.controller.create(this.topic);
  }

  @reflectable
  handleJoin(e, d) async {
    controller.controller.showJoiningPage();
  }
}
