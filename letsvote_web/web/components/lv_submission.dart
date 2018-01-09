@HtmlImport('lv_submission.html')
library lv_submission;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister(LvSubmission.tag)
class LvSubmission extends PolymerElement {
  static const String tag = 'lv-submission';

  LvSubmission.created() : super.created();
}
