

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import 'package:frontend_mobile_app/pages/property_flow/property_flow_page.dart';
import 'package:frontend_mobile_app/pages/property_flow/propery_process_prrovider.dart';
import 'package:frontend_mobile_app/theme/styles.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NamePage extends StatelessWidget implements HttpRunable {
   NamePage({super.key});

  @override
  Future<void> runHttp() async{
    Map updateNameRequest = { 'jwt' : Boxes.getUser()!.shortLifeJwt, 'id' : Boxes.getUser()!.id, 'data' : newName };
   await ApiService.instance!.updateUserName(updateNameRequest);
  }
  String newName = "";
  
  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProcessProvider>(
      builder: (context, algo, child) => Scaffold(
        body: Form(
          key: algo.nameFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "What's your name?",
                style: Styles.headerText1,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                  width: 300,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                                            newName = value;

                      algo.nameFormKey.currentState!.validate()
                          ? algo.updateRespectedStateIndex(true)//algo.state[algo.pageIndex] = true
                          : algo.updateRespectedStateIndex(false);
                    },
                    style: Styles.buttonText,
                    controller: algo.nameController,
                    inputFormatters: [CapitalizedWordsTextInputFormatter()],
                    validator: (value) {
                      return value!.length < 3
                          ? "Must be at least 3 characters"
                          : null;
                    },
                    maxLines: 1,
                    maxLength: 20,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    textAlign: TextAlign.center,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        //  hintTextDirection: TextDirection.rtl,
                        hintText: "Your name here",
                        hintStyle:
                            TextStyle(color: Color.fromARGB(87, 0, 0, 0))),
                  )),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
  

}
