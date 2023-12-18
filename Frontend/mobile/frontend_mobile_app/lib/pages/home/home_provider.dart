import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/models/boxes.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider()
  {
      if (Boxes.getUser()!.name != null ||
        Boxes.getUser()!.interests != null ||
        Boxes.getUser()!.verifiedStudent != false) {
      needsRebuild = true;
    } else {
      needsRebuild = false;
    }
  }
 late bool needsRebuild;
 // bool needsRebuild = false;
  void trueRebuild() {
    needsRebuild = true;
    notifyListeners();
  }

  //This function inserts mandatory pages prior to accessing app
  /*
  For future feature adds that don't require updates, do NOT put them in here
  */
  Future<bool> needsToHandleProperties() async {
    //List<Widget> preReqs = [];
    print("Running needsToHandleProperties\n${Boxes.getUser()!.name}");

    if (Boxes.getUser()!.name == null ||
        Boxes.getUser()!.interests == null ||
        Boxes.getUser()!.verifiedStudent == false) {
      return true;
    } else {
      return false;
    }
  }
}
