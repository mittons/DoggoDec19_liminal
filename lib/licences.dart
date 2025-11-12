import 'package:doggo_dec_19/config/app_config.dart';
import 'package:doggo_dec_19/screens/dog_screen.dart';
import 'package:doggo_dec_19/services/dog_service/dog_service.dart';
import 'package:doggo_dec_19/utils/service_locator.dart' as srv_loc;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyAppLicences());
}

class MyAppLicences extends StatelessWidget {
  const MyAppLicences({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Licences',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LicensePage(),
    );
  }
}
