

import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/theme/styles.dart';

class SplashLoader extends StatelessWidget {
  const SplashLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(backgroundColor: Colors.white,body: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("LinkEdu",style: Styles.headerText1,),
          //Center(child: CircularProgressIndicator(color: Colors.black,),),
        ],
      ),
    ),);
  }
}