/*
A singleton class.
Ensures a single instance throughout the entire app
*/
import 'package:http/http.dart' as http;

class ApiService
{
  static ApiService? _apiInstance;

  final _client = http.Client();
  
  ApiService._init()
;
  static ApiService? get apiInstance
  {
    _apiInstance ??= ApiService._init();
    return _apiInstance;
  }

  http.Client get httpClient
  {
    return _client;
  }


  final endpoint = Uri.parse("http://localhost:8080/");


  /*
  an async function that fetches a refreshed token
  */
  Future<void> refreshToken() async
  {

  }
}