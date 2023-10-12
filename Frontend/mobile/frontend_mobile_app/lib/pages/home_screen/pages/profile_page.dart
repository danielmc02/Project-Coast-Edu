


import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/pages/home_screen/components/sliding_sheet.dart';
import 'package:frontend_mobile_app/theme/styles.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Stack(
          children: [
            Center(
              child: Text("Show people who you really are. Post a video for others to see",style: Styles.headerText2,)
            ),
          const SlidingSheet()
          ],
        ),
      );
    
  }
}
