import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/theme/styles.dart';

import '../models/boxes.dart';

class SlidingSheet extends StatefulWidget {
  const SlidingSheet({super.key});

  @override
  State<SlidingSheet> createState() => _SlidingSheetState();
}

class _SlidingSheetState extends State<SlidingSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height / 4.5),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Color.fromARGB(255, 229, 229, 229)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
               //   mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(child: ConstrainedBox(constraints: BoxConstraints(minWidth: 110,minHeight: 110),child: CircleAvatar(backgroundColor: Colors.black,))),
                      Positioned(child: Boxes.getUser()!.verifiedStudent == true ? Icon(Icons.check_circle,size: 30,color: Colors.blue,) : Icon(Icons.warning,size: 30,color: Colors.yellow,),top: 0,right: 10,)
                      ],
                    ),
                    Text(Boxes.getUser()!.name!,style: Styles.headerText2,)
                  ],
                ),
              )) //color: Color.fromARGB(255, 245, 245, 245)
        ],
      ),
    );
  }
}
