
import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'onboarding_screen/onboarding_page.dart';

void main() {
//  Hive.initFlutter();
  //Hive.registerAdapter(UserAdapter());

  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: OnboardingPage());
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.map_sharp), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.link_sharp), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "")
      ]),
    );
  }
}
