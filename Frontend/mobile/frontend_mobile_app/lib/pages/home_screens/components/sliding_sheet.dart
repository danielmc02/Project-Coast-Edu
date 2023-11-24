import 'package:camera/camera.dart' ;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/pages/home_screens/components/profile_picture.dart';
import 'package:frontend_mobile_app/pages/home_screens/components/settings.dart';
import 'package:frontend_mobile_app/pages/home_screens/pages/link_page.dart';
import 'package:frontend_mobile_app/theme/styles.dart';
import 'package:provider/provider.dart';

import '../../../models/boxes.dart';

class ProfileFooter extends StatefulWidget {
  const ProfileFooter({super.key});

  @override
  State<ProfileFooter> createState() => _ProfileFooterState();
}

class _ProfileFooterState extends State<ProfileFooter> {
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
                          const Flexible(child: ProfilePicture()),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        Boxes.getUser()!.name!,
                                        style: Styles.headerText2,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SettingsButton()
                                  ],
                                ),
                                //   Container(color: Colors.red,height: 40,width: MediaQuery.of(context).size.width,)
                                //  Expanded(child: Container(color: Colors.red,))

                                SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        Boxes.getUser()!.interests!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Chip(
                                              backgroundColor: Colors.white,
                                              label: Text(Boxes.getUser()!
                                                  .interests![index])));
                                    },
                                  ),
                                ),
                                
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
