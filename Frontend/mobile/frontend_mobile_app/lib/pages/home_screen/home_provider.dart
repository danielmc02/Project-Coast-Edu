import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/models/boxes.dart';

import '../property_flow/property_flow_page.dart';


class HomeProvider extends ChangeNotifier {
  HomeProvider(){
    print("RANNIGGA");
  }

  bool  needsRebuild = false;
  void trueRebuild()
  {
    needsRebuild = true;
    notifyListeners();
  }




  //This function inserts mandatory pages prior to accessing app
  /*
  For future feature adds that don't require updates, do NOT put them in here
  */
  Future<bool> requiresOnboarding() async {
    //List<Widget> preReqs = [];

    //  await Future.delayed(Duration(seconds: 3));
    debugPrint(
        "\nname: ${Boxes.getUser()!.name}\ninterests: ${Boxes.getUser()!.interests}\nverified student:  ${Boxes.getUser()!.verifiedStudent}");

    if (Boxes.getUser()!.name == null ||
        Boxes.getUser()!.interests == null ||
        Boxes.getUser()!.verifiedStudent == false) {
          return true;
    } else {
      return false;
    }
  }

}

