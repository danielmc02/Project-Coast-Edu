

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import 'package:frontend_mobile_app/pages/property_flow/property_flow_page.dart';
import 'package:frontend_mobile_app/pages/property_flow/propery_process_prrovider.dart';
import 'package:frontend_mobile_app/theme/styles.dart';
import 'package:provider/provider.dart';

class InterestsPage extends StatefulWidget implements HttpRunable {
   InterestsPage({super.key});

  List<String> chosenInterests = [];
  @override
  Future<void> runHttp() async{
    Map updateInterestRequest = { 'jwt' : Boxes.getUser()!.shortLifeJwt, 'id' : Boxes.getUser()!.id, 'data' :  (jsonEncode(chosenInterests)).toString() };

    await ApiService.instance!.updateUserInterests(updateInterestRequest);
  }
  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  
  

  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProcessProvider>(
      builder: (context, algo, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "What Interests You?",
              style: Styles.headerText1,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Wrap(
                verticalDirection: VerticalDirection.down,
                runSpacing: 20,
                spacing: 20,
                direction: Axis.horizontal,
                textDirection: TextDirection.ltr,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  for (var e in algo.possibleMap.entries)
                    ChoiceChip(
                        elevation: e.value['isSelected'] ? 3 : 0,
                        selectedColor: e.value['color'],
                        label: Text(
                          e.key,
                          style: Styles.chipText,
                        ),
                        selected: e.value['isSelected'],
                        onSelected: (value) {
                          if (algo.chosen.length < 3 &&
                              e.value['isSelected'] ==
                                  false) //volume isn't at max
                          {
                            debugPrint('1');

                            setState(() {
                              e.value['isSelected'] = !e.value['isSelected'];
                              if (e.value['isSelected'] == true) {
                                algo.chosen.add(e.key);
                                algo.checkInterestState();
                              }
                            });
                          } else if (e.value['isSelected'] == true) {
                            debugPrint('2');
                            setState(() {
                              e.value['isSelected'] = false;
                              algo.chosen.remove(e.key);
                              algo.checkInterestState();
                            });
                          } else {
                            debugPrint('2.5');
                            debugPrint(
                                'Cant select because 3 is already chosen');
                          }
                          widget.chosenInterests = algo.chosen;
                                                    print(widget.chosenInterests);

                          //  e.value.entries.elementAt(1).
                        },
                        avatar: e.value['icon'])
                ]),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
