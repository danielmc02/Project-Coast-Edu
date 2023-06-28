import 'package:flutter/material.dart';

void main()
{
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(title: Text("Welcome to the mobile app"),),
      ),
    );
  }
}