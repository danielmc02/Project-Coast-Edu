import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/api_service.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
                                  onPressed: () async {
                                    await ApiService.instance!.signout();
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.black),
                                          foregroundColor: MaterialStatePropertyAll(Colors.red)),
                                          
                                  child: const Text("SIGN OUT"),
                                );

  }
}