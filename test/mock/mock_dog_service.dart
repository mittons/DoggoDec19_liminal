import 'package:doggo_dec_19/models/dog_service/dog_breed.dart';
import 'package:doggo_dec_19/services/dog_service/dog_service.dart';
import 'package:doggo_dec_19/services/service_result.dart';

class MockDogService extends DogService {
  // We don't need a url as this class doesnt make any http calls.
  // - It mocks the class that makes external calls, but generates the mocked responses without external depenencies.
  MockDogService() : super(baseDogApiUrl: "");

  @override
  Future<ServiceResult<List<DogBreed>?>> getBreeds() async {
    // Simulate slight delay in the function return time
    await Future.delayed(const Duration(milliseconds: 500));

    return getBreedsSync();
  }

  ServiceResult<List<DogBreed>?> getBreedsSync() {
    List<DogBreed> breeds = [1, 2, 3, 4, 5]
        .map((e) => DogBreed(
            id: e,
            name: "Dog breed $e",
            weight: "10 - 2$e",
            height: "1 - $e",
            lifeSpan: "70 - 10$e",
            referenceImageId: "referenceImageId$e"))
        .toList();

    return ServiceResult(data: breeds, success: true);
  }
}
