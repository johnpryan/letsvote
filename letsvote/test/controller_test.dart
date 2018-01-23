@TestOn("vm")
library controller_test;
import 'dart:async';

import 'package:letsvote/controllers.dart';
import 'package:letsvote/model.dart';
import 'package:letsvote/services.dart';
import 'package:letsvote/views.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';

void main() {
  group("controller", () {
    test("is pure dart", () {
      var client = new Client();
      var config = new MockConfigService();
      var services = new AppServices(client, config);
      new AppController(services);
    });

    test('loads the app configuration', () async {
      var client = new Client();
      var config = new MockConfigService();
      var services = new AppServices(client, config);
      var controller = new AppController(services);
      var view = new MockView();

      var mockConfig = new AppConfig("http://test.com");
      when(config.loadConfig()).thenReturn(new Future.value(mockConfig));
      await controller.init(view);
      verify(config.loadConfig()).called(1);
    });
  });
}

class MockConfigService extends Mock implements ConfigService {}
class MockView extends Mock implements AppView {}
