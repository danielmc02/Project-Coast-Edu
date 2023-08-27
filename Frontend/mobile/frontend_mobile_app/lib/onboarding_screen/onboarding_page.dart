import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/onboarding_screen/onboard_provider.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late TextEditingController emailField;
  late TextEditingController passwordField;
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

  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnboardingProvider(),
      builder: (context, child) => Consumer<OnboardingProvider>(
        builder: (context, algo, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
            shadowColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _fromKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "LinkEdu",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                      width: 300,
                      child: TextFormField(
                        validator: (value) {
                          return value!.length < 5
                              ? "Email is to short"
                              : algo.parseEmail(value) == false
                                  ? "Invalid Email"
                                  : null;
                        },
                        controller: emailField,
                        style: const TextStyle(),
                        decoration: const InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                      width: 300,
                      child: TextFormField(
                        obscureText: algo.defaultPasswordVisibilityState,
                        validator: (value) {
                          if (value!.length < 8) {
                            return "Password must be greater than 8 characters";
                          }

                          String feedback = algo.parsePassword(value);
                          if (feedback !=
                              "Password meets all requirements.") {
                            return feedback;
                          }

                          return null;
                        },
                        controller: passwordField,
                        style: const TextStyle(),
                        decoration: InputDecoration(
                            errorMaxLines: 3,
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  algo.changePasswordVisibility();
                                },
                                child: algo.defaultPasswordVisibilityState
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off)),
                            hintText: "Password",
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 50,
                      child: TextButton(
                          style: const ButtonStyle(
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.black)),
                          onPressed: () async {
                            if (_fromKey.currentState!.validate()) {
                              if (algo.wantsToSignUp) {
                                var res = await algo.registerUser(
                                    emailField.text, passwordField.text);
                                print(res.runtimeType.toString());
                                res.runtimeType != Null
                                    ? showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(res['body']),
                                            title: Text(res['code']),
                                          );
                                        },
                                      )
                                    : null;
                              } else {
                                var res = await algo.signInUser(
                                    emailField.text, passwordField.text);
                                     res.runtimeType != Null
                                    ? showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(res['body']),
                                            title: Text(res['code']),
                                          );
                                        },
                                      )
                                    : null;
                              }
                            }
                          },
                          child: Text(
                              algo.wantsToSignUp ? "Sign Up" : "Log in"))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        await algo.changeIntention();
                      },
                      child: Text(algo.wantsToSignUp
                          ? "Already have an account?"
                          : "Dont have an account? Sign Up!"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
