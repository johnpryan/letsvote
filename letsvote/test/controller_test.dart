@TestOn("vm")
library controller_test;
import 'package:letsvote/controllers.dart';
import 'package:letsvote/services.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';
void main() {
  group("controller", () {
    test("is pure dart", () {
      var client = new Client();
      var config = new MockConfigService();
      var services = new AppServices(config);
      new AppController(new AppContext(client, services));
    });
  });
}

class MockConfigService extends Mock implements ConfigService {}
