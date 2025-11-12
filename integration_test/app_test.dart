import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';
import 'package:doggo_dec_19/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Check if this is flagged as a continuous integration test run
  // - If so then we will expect mocked external services with known responses
  //   - Currently expecting mock services:
  //   - TheDogApi: [MockDogApiDec19] docker image available on localhost:3019
  const bool ciRun = bool.fromEnvironment('CI', defaultValue: false);

  group('Run app', () {
    testWidgets('and evalute initial state as well as a set of state changes',
        (widgetTester) async {
      // Set up dependencies and access to environment resources if needed

      // Run app
      app.main();
      await widgetTester.pumpAndSettle();

      // Perform tests
      // ---------------------------------------------------------------------------------------------------
      // | Evaluate initial state - All expected elements displayed
      // ---------------------------------------------------------------------------------------------------
      // Scaffold/Appbar
      expect(find.widgetWithText(AppBar, "Dog app! ~ For dogs and humans!"),
          findsOneWidget);

      // Request Button
      expect(
          find.widgetWithText(
              ElevatedButton, "Display list of dog breeds, please!"),
          findsOneWidget);

      // ---------------------------------------------------------------------------------------------------
      // | Evaluate state change - on - get dog list button pressed
      // ---------------------------------------------------------------------------------------------------
      // List of dog breeds is not displayed before request button is ever pressed
      // - No ListTile widgets should be on the screen at this point
      expect(find.byType(ListTile), findsNothing);

      // Tap the request button
      await widgetTester.tap(find.widgetWithText(
          ElevatedButton, "Display list of dog breeds, please!"));
      await widgetTester.pumpAndSettle();

      // If the CI flag is not set we can not be certain if we are testing against production service(s) or not
      // - Therefore we give the services a bit of time to respond ~ in case it we are relying on remote network calls
      if (!ciRun) {
        Future.delayed(const Duration(seconds: 5));
      }

      // List of dog breeds is displayed after the request button is pressed
      // - There should be some list tiles present on the screen at this point
      expect(find.byType(ListTile), findsAtLeastNWidgets(1));

      // - If the CI flag is set we can assume the external service(s) the app runs against are mocked.
      //   - In that case we assume that the mocked dog api service is an image of mockdogapidec19:1.0
      //   - And we can test against the data we know that this specific image produces
      if (ciRun) {
        for (String dogBreed in [
          "Affenpinscher",
          "Afghan Hound",
          "African Hunting Dog"
        ]) {
          expect(find.widgetWithText(ListTile, dogBreed), findsOneWidget);
        }
      }
    });
  });
}
