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
    return SizedBox(
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
                decoration: const BoxDecoration(
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
                        Container(child: ConstrainedBox(constraints: const BoxConstraints(minWidth: 110,minHeight: 110),child: const CircleAvatar(backgroundColor: Colors.black,))),
                      Positioned(top: 0,right: 10,child: Boxes.getUser()!.verifiedStudent == true ? const Icon(Icons.check_circle,size: 30,color: Colors.blue,) : const Icon(Icons.warning,size: 30,color: Colors.yellow,),)
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
