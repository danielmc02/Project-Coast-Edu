import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/api/endpoints.dart';
import 'package:frontend_mobile_app/pages/property_flow/property_flow_page.dart';
import 'package:http/http.dart';

import '../../models/boxes.dart';

class PropertyProcessProvider extends ChangeNotifier {

  NamePage NAMEPAGE = NamePage();
  InterestsPage INTERESTSPAGE = InterestsPage();
  VerifiedStudentPage VERIFYSTUDENT = VerifiedStudentPage();
 // NAMEPAGE.runhttp();

 late  List<HttpRunable> onboardPages;
 late List<bool> state;



Future<void> finishAll() async
{
  onboardPages.every((element) 
  {
    element.runHttp();
    return true;
  } );
}
  
  PropertyProcessProvider() {
    //The list of widgets
  //  snapshot = snap;
    //Used to refer to a page's state
 //   state = List.filled(snapshot.length, false);
 onboardPages = List.empty(growable: true);
     Boxes.getUser()!.name == null ? onboardPages.add(NAMEPAGE) : null;
    Boxes.getUser()!.interests == null ? onboardPages.add(INTERESTSPAGE) : null;
    Boxes.getUser()!.verifiedStudent == false ? onboardPages.add(VERIFYSTUDENT) : null;
    state = List.filled(onboardPages.length, false);
  }



  //A reference for the current page
  int pageIndex = 0;


  //Used for verifying name length
  final nameFormKey = GlobalKey<FormState>();
  //Controller for name
  final nameController = TextEditingController();


  //Used for verifying email signature
  final verificationFormKey = GlobalKey<FormState>();

  //Used as a reference for which way the transition should be
  bool reverseTransition = false;



  bool checkNamePage() {
    return nameFormKey.currentState!.validate() ? true : false;
  }

  List<String> chosen = [];
  void checkInterestState() {
    if (chosen.isEmpty) {
      updateRespectedStateIndex(false);
    } else {
      updateRespectedStateIndex(true);
    }
  }

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
      'icon': AssetImage("assets/school_icons/occ.png"),
      'isSelected': false
    },
    "Golden West College": {
      'icon': AssetImage("assets/school_icons/gwc.png"),
      'isSelected': false
    }
  };
  var backButtonColor = Colors.transparent;

  changeColor(Color color) {
    print("IN HERE");
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

    var result = await api.httpClient.post(Endpoints.sendVerificationEmailUri,
        body: jsonEncode(body), headers: {'Content-Type': 'applicatoin/json'});

    result.statusCode == 200
        ? await verifyPageController.nextPage(
            duration: const Duration(seconds: 1), curve: Curves.easeInSine)
        : null;
  }

  final verifyPageController = PageController();
  int givenCode = 0;
  bool validatedEmail = false;
  void emailValidated() async {
    validatedEmail = true;
    updateRespectedStateIndex(true);
    notifyListeners();
    await verifyPageController.animateToPage(0,
        duration: const Duration(seconds: 1), curve: Curves.easeOutSine);
  }

  Future<int> updateUserPreferences() async {
    // Print the chosen list as a map.
    print(chosen.asMap().toString());

    // Convert the chosen list as a map to a string.
    String chosenString = chosen.asMap().toString();

    // Construct the payload as a Map.
    Map mapPayLoad = {
      // 'email': Boxes.getUser()!.email,
      'name': nameController.text,
      'interests': (jsonEncode(chosen)).toString(), //.toString(),
      'verified': validatedEmail,
    };

    // Print the constructed payload.
    print(mapPayLoad);

    // Send a POST request to a specified API endpoint using the ApiService.
    Response result = await ApiService.instance!.httpClient.post(
      Endpoints.updateUserPreferencesUri,
      body: jsonEncode(mapPayLoad),
      headers: {
        'Content-Type': 'application/json'
      }, // Corrected 'applicatoin' to 'application'
    );

    // Print the HTTP status code received in the response.
    print(result.statusCode);

    // Return the HTTP status code as an integer.
    return result.statusCode;
  }

  void printStats() {
    Map mapPayLoad = {
      //   'email': Boxes.getUser()!.email,
      'name': nameController.text,
      'interests': (jsonEncode(chosen)).toString(), //.toString(),
      'verified': validatedEmail,
    };
    print(mapPayLoad);
    print("\n\n\n");
    print(jsonEncode(mapPayLoad));
  }

  nextPage() {
    int coppiedIndex = pageIndex;
    coppiedIndex += 1;
    if (onboardPages.length <= coppiedIndex) {
    } else {
      pageIndex += 1;
    }
    notifyListeners();
  }

  Future<void> previousPage() async {
    pageIndex += 1;

    notifyListeners();
  }

  bool canFinish = false;
  void updateRespectedStateIndex(bool value) {
    state[pageIndex] = value;
    canFinish = state.every((element) => element == true);
    notifyListeners();
  }


}
