@HtmlImport('lv_create.html')
library lv_create;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'proxies.dart';

@PolymerRegister(LvCreate.tag)
class LvCreate extends PolymerElement {
  static const String tag = 'lv-create';

  @property
  AppControllerProxy controller;

  LvCreate.created() : super.created();
}
