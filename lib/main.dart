import 'package:doggo_dec_19/config/app_config.dart';
import 'package:doggo_dec_19/screens/dog_screen.dart';
import 'package:doggo_dec_19/services/dog_service/dog_service.dart';
import 'package:doggo_dec_19/utils/service_locator.dart' as srv_loc;
import 'package:flutter/material.dart';

void main() {
  srv_loc.setupServiceLocator();

  const bool ciRun = bool.fromEnvironment('CI', defaultValue: false);

  AppConfig appConfig = ciRun ? IntegrationTestConfig() : DefaultConfig();

  runApp(MyApp(appConfig: appConfig));
}

class MyApp extends StatelessWidget {
  final AppConfig appConfig;

  const MyApp({super.key, required this.appConfig});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Breed Diversity Showcase App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: DogScreen(
          dogService: DogService(baseDogApiUrl: appConfig.dogApiBaseUrl)),
    );
  }
}
