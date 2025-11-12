import 'dart:convert';

import 'package:doggo_dec_19/models/dog_service/dog_breed.dart';
import 'package:doggo_dec_19/services/service_result.dart';
import 'package:doggo_dec_19/utils/service_locator.dart' as srv_loc;
import 'package:http/http.dart' as http;

class DogService {
  final String baseDogApiUrl;

  DogService({required this.baseDogApiUrl});

  http.Client _getHttpClient() {
    return srv_loc.serviceLocator<http.Client>();
  }

  String _generateRequestUrl(String endpointRoute) {
    return "$baseDogApiUrl$endpointRoute";
  }

  Future<ServiceResult<List<DogBreed>?>> getBreeds() async {
    // Define response variable
    final http.Response response;

    // Try requesting the data from the external REST api, if it doesnt work then log and return no success
    try {
      response =
          await _getHttpClient().get(Uri.parse(_generateRequestUrl("/breeds")));
    } catch (e) {
      print("Error fetching data from external REST service: $e");
      return ServiceResult(data: null, success: false);
    }

    // If response did not have the current status code, log and return unsuccessful result
    if (response.statusCode != 200) {
      print(
          "Invalid status code in response from external service ${response.statusCode}");
      return ServiceResult(data: null, success: false);
    }

    try {
      final parsedJson = jsonDecode(response.body);

      List<DogBreed> dogBreeds = (parsedJson as List)
          .map((breedJson) => DogBreed.fromJson(breedJson))
          .toList();

      return ServiceResult(data: dogBreeds, success: true);
    } catch (e) {
      print("Error parsing json response from external service call: $e");
      return ServiceResult(data: null, success: false);
    }
  }
}
