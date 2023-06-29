/*
  Mobile Leader: DanielAtOcc (digity63@gmail.com)
*/
import 'package:flutter/material.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Project Coast Edu"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Text("This is the mobile application"),
              ),
              TextButton(onPressed: (){}, child: Text("Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}
