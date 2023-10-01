import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/theme/styles.dart';

import '../../../models/boxes.dart';

class SlidingSheet extends StatefulWidget {
  const SlidingSheet({super.key});

  @override
  State<SlidingSheet> createState() => _SlidingSheetState();
}

class _SlidingSheetState extends State<SlidingSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height / 4.5),
            child: Container(
              height: 40,
                            decoration: const BoxDecoration(
                
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                      color: Color.fromARGB(255, 229, 229, 229),
                      //color: Color.fromARGB(255, 229, 229, 229)),
),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                 // mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                               //   mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child: ProfilePicture()),
                          Expanded(
                            flex: 3,
                            child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                               //       mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  child: Text(Boxes.getUser()!.name!,style: Styles.headerText2, maxLines: 1,overflow: TextOverflow.ellipsis
                                  ,),
                                ),
                             //   Container(color: Colors.red,height: 40,width: MediaQuery.of(context).size.width,)
                              //  Expanded(child: Container(color: Colors.red,))
                                              
                                   Container(
                                     height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: Boxes.getUser()!.interests!.length,itemBuilder:(context, index) {
                                                            return Container(margin: EdgeInsets.symmetric(horizontal: 4),child: Chip(backgroundColor:Colors.white,label: Text(Boxes.getUser()!.interests![index])));
                                                          }, ),
                                    )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                
                  ],
                ),
              ),
            ))
      ],
    );
  }
}


class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
                      children: [
                        ConstrainedBox(constraints: const BoxConstraints(minWidth: 110,minHeight: 110),child: const CircleAvatar(backgroundColor: Colors.black,)),
                      Positioned(top: 0,right: 10,child: Boxes.getUser()!.verifiedStudent == true ? const Icon(Icons.check_circle,size: 30,color: Colors.blue,) : const Icon(Icons.warning,size: 30,color: Colors.yellow,),)
                      ],
                    );
  }
}