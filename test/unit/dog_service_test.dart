import 'package:doggo_dec_19/services/dog_service/dog_service.dart';
import 'package:doggo_dec_19/services/service_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doggo_dec_19/utils/service_locator.dart' as srv_loc;
import 'package:http/http.dart' as http;

import '../mock/mock_http_client_factory.dart';

void main() {
  // Tear down stateful dependencies after tests to ensure other tests (if any) get a fresh state.
  tearDown(() {
    srv_loc.serviceLocator.unregister<http.Client>();
  });

  group('When Dog Service', () {
    group('operates successfully', () {
      test('getBreeds delivers a successful result', () async {
        _testValidClient(
            MockHttpClientFactory.get200Client(_getValidJsonResponse()));
      });
    });

    group(
        'encounters no exceptions/errors from external service calls but receives a response we can parse (unknown formatting)',
        () {
      test(
          'getBreeds delivers an unsuccesful result on a json response that doesnt match our expected contract',
          () async {
        _testInvalidClient(
            MockHttpClientFactory.get200Client(_getInvalidJsonResponse()));
      });
    });

    group('encounters exeptions/errors from external service calls', () {
      test(
          'its functions (getBreeds currently) return a unsuccesful result on 404 response from service',
          () async {
        _testInvalidClient(MockHttpClientFactory.get404Client());
      });
      test(
          'its functions (getBreeds currently) return a unsuccesful result on HttpException',
          () async {
        _testInvalidClient(MockHttpClientFactory.getHttpExceptionClient());
      });

      test(
          'its functions (getBreeds currently) return a unsuccesful result on TimeoutException',
          () async {
        _testInvalidClient(MockHttpClientFactory.getTimeoutExceptionClitent());
      });

      test(
          'its functions (getBreeds currently) return a unsuccesful result on WebSocketException',
          () async {
        _testInvalidClient(MockHttpClientFactory.getWebSocketExceptionClient());
      });
    });
  });
}

Future<void> _testValidClient(http.Client mockClient) async {
  // Set up dependencies and resources needed in external environment
  srv_loc.serviceLocator.registerSingleton<http.Client>(mockClient);

  // Initialize instance containing unit being tested (if needed)
  // - We inject our own http.Client so the url path is irrelevant.. we can pass empty string as path.
  DogService dogService = DogService(baseDogApiUrl: "");

  // Perform test
  ServiceResult result = await dogService.getBreeds();

  expect(result.success, true);
}

Future<void> _testInvalidClient(http.Client mockClient) async {
  // Set up dependencies and resources needed in external environment
  srv_loc.serviceLocator.registerSingleton<http.Client>(mockClient);

  // Initialize instance containing unit being tested (if needed)
  // - We inject our own http.Client so the url path is irrelevant.. we can pass empty string as path.
  DogService dogService = DogService(baseDogApiUrl: "");

  // Perform test
  ServiceResult result = await dogService.getBreeds();
  expect(result.success, false);
}

String _getValidJsonResponse() {
  return """[{"weight":{"imperial":"6 - 13","metric":"3 - 6"},"height":{"imperial":"9 - 11.5","metric":"23 - 29"},"id":1,"name":"Affenpinscher","bred_for":"Small rodent hunting, lapdog","breed_group":"Toy","life_span":"10 - 12 years","temperament":"Stubborn, Curious, Playful, Adventurous, Active, Fun-loving","origin":"Germany, France","reference_image_id":"BJa4kxc4X"},{"weight":{"imperial":"50 - 60","metric":"23 - 27"},"height":{"imperial":"25 - 27","metric":"64 - 69"},"id":2,"name":"Afghan Hound","country_code":"AG","bred_for":"Coursing and hunting","breed_group":"Hound","life_span":"10 - 13 years","temperament":"Aloof, Clownish, Dignified, Independent, Happy","origin":"Afghanistan, Iran, Pakistan","reference_image_id":"hMyT4CDXR"},{"weight":{"imperial":"44 - 66","metric":"20 - 30"},"height":{"imperial":"30","metric":"76"},"id":3,"name":"African Hunting Dog","bred_for":"A wild pack animal","life_span":"11 years","temperament":"Wild, Hardworking, Dutiful","reference_image_id":"rkiByec47"}]
  """;
}

String _getInvalidJsonResponse() {
  return "#^&^((#%%%###)) HUEH HUE HUE hey hey hey yall";
}
