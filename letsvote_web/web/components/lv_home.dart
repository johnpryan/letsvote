@HtmlImport('lv_home.html')
library lv_home;

import 'dart:async';
import 'dart:html';

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

  @Property(observer: 'controllerChanged')
  AppControllerProxy controller;

  String get topic => get('topic');

  LvHome.created() : super.created();

//  @reflectable
//  void controllerChanged(_, __) {
//    print("changed controller $controller");
//  }

  @reflectable
  Future handleCreate(CustomEvent e, dynamic d) async {
    await controller.controller.create(this.topic);
  }
}
