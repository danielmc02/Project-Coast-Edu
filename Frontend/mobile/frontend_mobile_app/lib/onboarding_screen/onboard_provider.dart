import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api_service.dart';
import 'package:frontend_mobile_app/databases.dart';
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

    print(response.statusCode);
    print(response.body);
  }
}
