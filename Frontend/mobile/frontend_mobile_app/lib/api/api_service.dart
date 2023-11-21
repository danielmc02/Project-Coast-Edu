/*
A singleton class.
Ensures a single instance throughout the entire app
*/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/endpoints.dart';
import 'package:http/http.dart' as http;
import '../models/boxes.dart';

class ApiService extends ChangeNotifier {
  //Singleton Instance
  static ApiService? _apiInstance;

  //Http client used as gateway for requests
  final _client = http.Client();
  http.Client get httpClient {
    return _client;
  }
  /*------------------------------*/

  // Constructor that's ran first time "instance is called"
  ApiService._init() {
    Boxes.getUser() != null ? signedIn = true : signedIn = false;
    print("Signed In value from apiservice is: $signedIn");
    debugPrint("Just got inited");
  }
  /*------------------------------*/

  //Used to fetch the private instance to portray it publicly
  static ApiService? get instance {
    _apiInstance ??= ApiService._init();
    return _apiInstance;
  }
  /*------------------------------*/

  //Auth purposed var and method to let app root know auth status
  late bool signedIn;
  Future<bool> isSignedIn() async {
    await Future.delayed(const Duration(seconds: 2));
    if (Boxes.getUser() == null) {
      signedIn = false;
      return signedIn;
    } else {
      signedIn = true;
      return signedIn;
    }
  }
  /*------------------------------*/

  //Auth method called when middle layer of app determines if signed in
  Future<void> signIn() async {
    signedIn = true;
    notifyListeners();
  }
  /*------------------------------*/



  Future<void> signout() async {
    await Boxes.getUserBox().delete('mainUser');
    signedIn = false;
    notifyListeners();
  }

  Future<void> updateUserName(Map req) async {
    try {

      String reqJson = jsonEncode(req);

      //  print(reqJson);

      await _client.put(
        Endpoints.defaultUriConcatanate("/update_user_name"),
        body: reqJson,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateUserInterests(Map request) async {
    try {

      String reqJson = jsonEncode(request);


      await _client.put(
        Endpoints.defaultUriConcatanate("/update_user_interests"),
        body: reqJson,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateVerifiedStudentStatus(Map req) async {
    try {
      String reqJson = jsonEncode(req);


      await _client.put(
        Endpoints.defaultUriConcatanate("/update_verified_student_status"),
        body: reqJson,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> updateLocalUserInfo() async
  {
    try
    {
   var res =   await httpClient.post(Endpoints.getPublicUserInfo, body:jsonEncode( {'id': Boxes.getUser()!.id}),headers: {'Content-Type': 'application/json'},);
   Map dataRes = jsonDecode(res.body);

      List<String> stringInterests = [];
      List? fromJson = dataRes['interests'];
      if (fromJson != null) {
        for (var element in fromJson) {
          stringInterests.add(element as String);
        }
      }



   Boxes.getUser()!.updateName(dataRes['name']);
   Boxes.getUser()!.updateInterests(stringInterests);
      Boxes.getUser()!.updateVerifiedStatus(dataRes['verified_student']);

return true;
    }
    catch(e)
    {
      return false;
    }
  }
}
