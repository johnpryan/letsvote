@HtmlImport('lv_joining.html')
library lv_joining;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'proxies.dart';

@PolymerRegister(LvJoining.tag)
class LvJoining extends PolymerElement {
  static const String tag = 'lv-joining';

  @property
  AppControllerProxy controller;

  LvJoining.created() : super.created();
}
