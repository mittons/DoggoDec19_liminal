class AppConfig {
  final String dogApiBaseUrl;

  AppConfig({required this.dogApiBaseUrl});
}

// This app uses thedogapi.com as a data source, but the http requests are routed through a backend to manage secrets.
// Its possible to replace this url with a direct reference to thedogapi.com but it requires user access to the api from the person
//   who is responsible for the requests.
class DefaultConfig extends AppConfig {
  DefaultConfig()
      : super(dogApiBaseUrl: "https://doggo-ergo-cogito-b5e22946bd8a.herokuapp.com");
}

class IntegrationTestConfig extends AppConfig {
  IntegrationTestConfig() : super(dogApiBaseUrl: "http://localhost:3019");
}
