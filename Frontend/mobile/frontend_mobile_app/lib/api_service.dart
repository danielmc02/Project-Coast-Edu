/*
A singleton class.
Ensures a single instance throughout the entire app
*/
import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'boxes.dart';

class ApiService extends ChangeNotifier {
  static ApiService? _apiInstance;

  final _client = http.Client();

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

  ApiService._init() {
    Boxes.getUser() != null ? signedIn = true : signedIn = false;
    debugPrint("Just got inited");
  }
  static ApiService? get apiInstance {
    _apiInstance ??= ApiService._init();
    return _apiInstance;
  }

  http.Client get httpClient {
    return _client;
  }

  final endpoint = Uri.parse("http://localhost:8080/");

  Future<void> handleUser(Map res) async {
    developer.log("Checking and assigning user jwt", name: "Handling user");
    //retrieve new data, check if jwt is valid for longer than 5 minutes
    //create user and return a bool if valid(true) or not valid(false)
    try {
      print(res.toString());
      var currentUser = User(
          shortLifeJwt: res['short_life_jwt'],
          id: res['id'],
          email: res['email'],
          name: res['name'],
          interests: res['interests'],
          verifiedStudent: res['verified_student']
          );
      await Boxes.getUserBox().put('mainUser', currentUser);
    await  signIn();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signIn() async {
    signedIn = true;
    notifyListeners();
  }

  Future<void> signout() async {
    await Boxes.getUserBox().delete('mainUser');
    signedIn = false;
    notifyListeners();
  }
}
