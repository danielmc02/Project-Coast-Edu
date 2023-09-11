import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api_service.dart';
import 'package:frontend_mobile_app/models/interests.dart';
import 'package:http/http.dart';

import '../boxes.dart';

class PropertyProcessProvider extends ChangeNotifier {
  PropertyProcessProvider();
  final pageController = PageController();
  final nameFormKey = GlobalKey<FormState>();
  final verificationFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  bool checkNamePage() {
    return nameFormKey.currentState!.validate() ? true : false;
  }

  List<String> chosen = [];
  var possibleMap = <String, Map>{
    'Auto': {
      'icon': CircleAvatar(child: Image.asset('assets/interest_icons/car.png')),
      'isSelected': false,
      'color': Colors.white
    },
    'Tech': {
      'icon': CircleAvatar(
          child: Image.asset('assets/interest_icons/virtual-reality.png')),
      'isSelected': false,
      'color': Colors.white
    },
    'Gaming': {
      'icon': CircleAvatar(
          child: Image.asset('assets/interest_icons/game-controller.png')),
      'isSelected': false,
      'color': Colors.white
    },
    'Sports': {
      'icon':
          CircleAvatar(child: Image.asset('assets/interest_icons/sports.png')),
      'isSelected': false,
      'color': Colors.white
    },
    'Fitness': {
      'icon':
          CircleAvatar(child: Image.asset('assets/interest_icons/barbell.png')),
      'isSelected': false,
      'color': Colors.white
    },
    'Art': {
      'icon': CircleAvatar(
          child: Image.asset('assets/interest_icons/watercolor.png')),
      'isSelected': false,
      'color': Colors.white
    },
    'Music': {
      'icon':
          CircleAvatar(child: Image.asset('assets/interest_icons/music.png')),
      'isSelected': false,
      'color': Colors.white
    },
    'Entrepreneurship': {
      'icon': CircleAvatar(
          child: Image.asset('assets/interest_icons/entrepreneurship.png')),
      'isSelected': false,
      'color': Colors.white
    },
  };

  bool checkInterestPage() {
    return chosen.isNotEmpty;
  }

  List<String> chosenSchool = [];
  Map supportedSchools = {
    "Orange Coast College": {
      'icon': Image.asset("assets/school_icons/occ.png"),
      'isSelected': false
    },
    "Golden West College": {
      'icon': Image.asset("assets/school_icons/gwc.png"),
      'isSelected': false
    }
  };
  var backButtonColor = Colors.transparent;

  changeColor(Color color) {
    backButtonColor = color;
    notifyListeners();
  }

  void verifyStudentEmail(String value) async {
    int fourDigit = Random().nextInt(9001) + 1000;
    String verificationCode = fourDigit.toString();
    givenCode = fourDigit;
    debugPrint(verificationCode);

    final api = ApiService.instance!;
    var body = {
      'jwt': Boxes.getUser()!.shortLifeJwt.toString(),
      'email': value,
      'code': verificationCode
    };
    final Uri uri = Uri.parse('http://localhost:8080/send_verification_email');

    var result = await api.httpClient.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'applicatoin/json'});
        
   result.statusCode == 200 ? await verifyPageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInSine) : null;
  }
  final verifyPageController = PageController();
  int givenCode = 0;
bool validatedEmail = false;
  void emailValidated()  async
  {
    validatedEmail = true;
    notifyListeners();
   await verifyPageController.animateToPage(0, duration: const Duration(seconds: 1), curve: Curves.easeOutSine);
  }


  Future<int> updateUserPreferences() async
  {
    Map mapPayLoad = {'name':nameController.text, 'interests': chosen.toString(),'school':chosenSchool.first.toString(), 'verified':validatedEmail };
   print(mapPayLoad);
    String payload = jsonEncode(mapPayLoad);
    print(payload);
    final uri = Uri.parse("http://localhost:8080/update_user_preferences");
   Response result = await ApiService.instance!.httpClient.post(uri,body: payload,headers: {'Content-Type': 'applicatoin/json'} );
       print(result.statusCode);

   
   return result.statusCode;
  }

}
