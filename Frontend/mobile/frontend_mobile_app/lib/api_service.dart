/*
A singleton class.
Ensures a single instance throughout the entire app
*/
class ApiService
{
  static ApiService? _apiInstance;



  
  ApiService._init()
  {

  }

  static ApiService? get apiInstance
  {
    _apiInstance ??= ApiService._init();
    return _apiInstance;
  }
}