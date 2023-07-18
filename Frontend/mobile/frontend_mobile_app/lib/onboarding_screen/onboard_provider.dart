import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OnboardingProvider extends ChangeNotifier {
  bool wantsToSignUp = true;
  OnboardingProvider() {
    debugPrint("Onboarding init");
  }


  Future<bool> parseEmail(String email) async {
      List<String> supportedEmails = [
    "gmail.com",
    "yahoo.com",
    "outlook.com",
    "hotmail.com",
    "aol.com",
    " icloud.com"
  ];
    bool hasValidEmail = false;
    for (String e in supportedEmails) {
      if (email.contains(e)) {
        hasValidEmail = true;
        break;
      }
    }
    return hasValidEmail;
  }
String parsePassword(String password)  {
    List<String> specialCharacters = [
    "!",
    "\"",
    "#",
    "\$",
    "%",
    "&",
    "'",
    "(",
    ")",
    "*",
    "+",
    ",",
    "-",
    ".",
    "/",
    ":",
    ";",
    "<",
    "=",
    ">",
    "?",
    "@",
    "[",
    "\\",
    "]",
    "^",
    "_",
    "`",
    "{",
    "|",
    "}",
    "~"
  ];
List<String> capitalLetters = [
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O",
  "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
];
List<String> numbers = [
  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
];
List<String> lowercaseLetters = [
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
  "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
];
  bool hasSpecialCharacter = false;
  bool hasCapitalCharacter = false;
  bool hasLowerCharacter = false;
  bool hasNumber = false;

  for (String e in specialCharacters) {
    if (password.contains(e)) {
      hasSpecialCharacter = true;
      break;
    }
  }

  for (String e in capitalLetters) {
    if (password.contains(e)) {
      hasCapitalCharacter = true;
      break;
    }
  }

  for (String e in lowercaseLetters) {
    if (password.contains(e)) {
      hasLowerCharacter = true;
      break;
    }
  }

  for (String e in numbers) {
    if (password.contains(e)) {
      hasNumber = true;
      break;
    }
  }

  if (hasSpecialCharacter && hasCapitalCharacter && hasLowerCharacter && hasNumber) {
    return "Password meets all requirements.";
  }

  String feedback = "Must have: ";

  if (!hasSpecialCharacter) {
    feedback += "special character, ";
  }

  if (!hasCapitalCharacter) {
    feedback += "capital letter, ";
  }

  if (!hasLowerCharacter) {
    feedback += "lowercase letter, ";
  }

  if (!hasNumber) {
    feedback += "number, ";
  }

  feedback = feedback.substring(0, feedback.length - 2); // Remove the last comma and space

  return feedback;
}
  //http stuff
  Future<void> registerUser(String email, String password) async {
    print("registering user");
    
    final Uri uri = Uri.parse('http://localhost:8084/register_user');
    final Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try
    {
          final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    debugPrint(" ahhh ${response.statusCode.toString()}");
  
    }
    catch(e)
    {
      debugPrint("error in connection ${e}");
     //igit6 return "Uh Oh, there was an error in connecting to the db";
    }

  }

  bool defaultPasswordVisibilityState = true;
  void changePasswordVisibility() {
    defaultPasswordVisibilityState = !defaultPasswordVisibilityState;
    notifyListeners();
  }

  Future<void> changeIntention()async 
  {
    wantsToSignUp = !wantsToSignUp;
    notifyListeners();
  }

  Future<void> signInUser(String email, String password) async
  {
    print("sign in");
    
    final Uri uri = Uri.parse('http://localhost:8084/sign_in_user');
      final Map<String, String> body = {
      'email': email,
      'password': password,
    };
        try
    {
          final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    debugPrint(" ahhh ${response.statusCode.toString()}");
        debugPrint(" ahhh ${response.body}");


    }
    catch(e)
    {
      debugPrint("error in connection ${e}");
     //igit6 return "Uh Oh, there was an error in connecting to the db";
     
    }
  }
}
