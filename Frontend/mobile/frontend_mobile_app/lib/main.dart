/*
  Mobile Leader: DanielAtOcc (digity63@gmail.com)
*/
import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/onboarding_screen/onboard_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(home: OnboardingPage());
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late TextEditingController emailField;
  late  TextEditingController passwordField;
  @override
  void initState() {
   emailField = TextEditingController();
 passwordField = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailField.dispose();
    passwordField.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingProvider(),
      builder: (context, child) => Consumer<OnboardingProvider>(
        builder: (context, algo, child) => Scaffold(
          appBar: AppBar(),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: emailField,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    )),
                SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: passwordField,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    )),
                SizedBox(
                    width: 100,
                    height: 50,
                    child: TextButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.black)),
                        onPressed: () async{
                         await algo.registerUser(emailField.text,passwordField.text);
                        },
                        child: const Text("Sign Up")))
              ],
            ),
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
