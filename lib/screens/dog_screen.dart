import 'package:doggo_dec_19/helpers/ui_helper.dart';
import 'package:doggo_dec_19/models/dog_service/dog_breed.dart';
import 'package:doggo_dec_19/services/dog_service/dog_service.dart';
import 'package:doggo_dec_19/services/service_result.dart';
import 'package:flutter/material.dart';

class DogScreen extends StatefulWidget {
  final DogService dogService;

  const DogScreen({super.key, required this.dogService});

  @override
  State<StatefulWidget> createState() => _DogScreenState();
}

class _DogScreenState extends State<DogScreen> {
  bool dogsLoaded = false;
  late List<DogBreed> dogList;
  bool isLoadingInitialList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dog app! ~ For dogs and humans!"),
        backgroundColor: Colors.deepPurpleAccent.shade100,
      ),
      body: Column(children: [
        _buildButtonContainer(),
        if (isLoadingInitialList)
          const Center(child: CircularProgressIndicator()),
        if (dogsLoaded) Expanded(child: _buildDogBreedList())
      ]),
    );
  }

  Widget _buildButtonContainer() {
    return Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 9, bottom: 10),
        child: ElevatedButton(
          onPressed: _handleRequestButtonPressed,
          child: const Text("Display list of dog breeds, please!"),
        ));
  }

  void _handleRequestButtonPressed() async {
    if (dogsLoaded != true && isLoadingInitialList != true) {
      setState(() {
        isLoadingInitialList = true;
      });
    }

    // Attempt to fetch the requested data from the service layer (await)
    ServiceResult breedsResult = await widget.dogService.getBreeds();

    // If context is not mounted (this screen isn't being dispalayed any more), return.
    if (!context.mounted) return;

    // If the response from the service layer expressed an unsuccessful attepmt, display user message and return
    if (!breedsResult.success) {
      if (isLoadingInitialList == true) {
        setState(() {
          isLoadingInitialList = false;
        });
      }
      UiHelper.displaySnackbar(context,
          "Unable to retrieve data from external provider. Please try again later!");
    }

    // If everything went well, update state data with list of dog breeds from service layer, and ensure the widget builder knows the list has been loaded.
    setState(() {
      dogList = breedsResult.data!;
      dogsLoaded = true;
      isLoadingInitialList = false;
    });
  }

  Widget _buildDogBreedList() {
    return ListView.builder(
        itemBuilder: _dogBreedItemBuilder, itemCount: dogList.length);
  }

  Widget _dogBreedItemBuilder(context, index) {
    return Card(
      child: ListTile(
        title: Text(dogList[index].name),
        subtitle: (dogList[index].temperament == null)
            ? null
            : Text(dogList[index].temperament!),
      ),
    );
  }
}
