import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OnboardingProvider extends ChangeNotifier {
  OnboardingProvider();
  Future<void> registerUser(String email, String password) async {
    final Uri uri = Uri.parse('http://localhost:8083/register_user');
    final Map<String, String> body = {
      'email': email,
      'password': password,
    };
   // print(jsonEncode(body));

    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
  }
}
