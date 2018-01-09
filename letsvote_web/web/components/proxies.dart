import 'package:letsvote/controllers.dart';
import 'package:polymer/polymer.dart';

/// In PolymerDart, proxy classes when passing non-javascript data through
/// templates.
class AppControllerProxy extends JsProxy {
  /// The real controller sent to each view
  final AppController controller;
  AppControllerProxy(this.controller);
}