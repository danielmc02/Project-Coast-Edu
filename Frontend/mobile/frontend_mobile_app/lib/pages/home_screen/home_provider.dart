import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/models/boxes.dart';


class HomeProvider extends ChangeNotifier {
  HomeProvider() ;

  bool needsRebuild = false;
  void trueRebuild() {
    needsRebuild = true;
    notifyListeners();
  }

  //This function inserts mandatory pages prior to accessing app
  /*
  For future feature adds that don't require updates, do NOT put them in here
  */
  Future<bool> requiresOnboarding() async {
    //List<Widget> preReqs = [];
print("Running requires onboard\n${Boxes.getUser()!.verifiedStudent}");
      await Future.delayed(const Duration(seconds: 1));
 
    if (Boxes.getUser()!.name == null ||
        Boxes.getUser()!.interests == null ||
        Boxes.getUser()!.verifiedStudent == false) {
      return true;
    } else {
      return false;
    }
  }
}
