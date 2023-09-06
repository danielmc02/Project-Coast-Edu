import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/property_flow/property_flow_page.dart';
import 'package:frontend_mobile_app/boxes.dart';


class HomeProvider extends ChangeNotifier {
  HomeProvider();

  Future<List> preReqSetup() async {
    List<Widget> preReqs = [];

    //  await Future.delayed(Duration(seconds: 3));
    debugPrint(
        "\nname: ${Boxes.getUser()!.name}\ninterests: ${Boxes.getUser()!.interests}\nverified student:  ${Boxes.getUser()!.verifiedStudent}");

    if (Boxes.getUser()!.name == null ||
        Boxes.getUser()!.interests == null ||
        Boxes.getUser()!.verifiedStudent == false) {
      debugPrint(preReqs.length.toString());
      Boxes.getUser()!.name == null ? preReqs.add(const NamePage()) : null;
      Boxes.getUser()!.interests == null
          ? preReqs.add(const InterestsPage())
          : null;
      Boxes.getUser()!.verifiedStudent == false
          ? preReqs.add(const VerifiedStudentPage())
          : null;
      debugPrint(preReqs.length.toString());

      return preReqs;
    } else {
      return preReqs;
    }
  }

}

