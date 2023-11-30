import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import 'package:frontend_mobile_app/pages/property_flow/property_flow_page.dart';
import 'package:frontend_mobile_app/pages/property_flow/propery_process_prrovider.dart';
import 'package:frontend_mobile_app/theme/styles.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class VerifiedStudentPage extends StatefulWidget implements HttpRunable {
  VerifiedStudentPage({
    super.key,
  });

  bool verified = false;

  @override
  Future<void> runHttp() async {
    Map updateVerifiedStudentStatus = {
      'jwt': Boxes.getUser()!.shortLifeJwt,
      'id': Boxes.getUser()!.id,
      'data': verified.toString()
    };
    await ApiService.instance!
        .updateVerifiedStudentStatus(updateVerifiedStudentStatus);
  }

  @override
  State<VerifiedStudentPage> createState() => _VerifiedStudentPageState();
}

class _VerifiedStudentPageState extends State<VerifiedStudentPage> {
  late TextEditingController emailFieldController;
  @override
  void initState() {
    emailFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProcessProvider>(
      builder: (context, algo, child) => PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: algo.verifyPageController,
          children: [
            algo.validatedEmail == false
                ? Form(
                    key: algo.verificationFormKey,
                    child: Scaffold(
                      //   backgroundColor: Colors.black,
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "What school do you attend?",
                            style: Styles.headerText1,
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                      algo.supportedSchools.length, (index) {
                                    String name = algo.supportedSchools.keys
                                        .elementAt(index);
                                    Map<String, dynamic> schoolData =
                                        algo.supportedSchools[name];

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Deselect all tiles first
                                            algo.supportedSchools
                                                .forEach((key, value) {
                                              value['isSelected'] = false;
                                            });

                                            // Select the tapped tile and update chosenSchool
                                            schoolData['isSelected'] = true;
                                            algo.chosenSchool = [name];
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // image: DecorationImage(image: AssetImage("assets/occ.jpeg")),
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: schoolData['isSelected']
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                          width: 300,
                                          //  height: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              selectedColor: Colors.white,
                                              //tileColor: Colors.grey,
                                              selected:
                                                  schoolData['isSelected'],
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                foregroundImage:
                                                    schoolData['icon'],
                                              ),
                                              dense: false,
                                              // subtitle: const Text("Current Users: "),
                                              title: Text(
                                                name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        schoolData['isSelected']
                                                            ? Colors.black
                                                            : Colors.white60),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                style: Styles.buttonText,
                                cursorColor: Colors.black,

                                controller: emailFieldController,
                                // key: algo.verificationFormKey,
                                validator: (value) {
                                  return value!.contains('@student.cccd.edu')
                                      ? null
                                      : "Invalid school email format";
                                },
                                maxLines: 1,
                                // maxLength: 20,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(' ')
                                ],
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "example@cccd.edu.com",
                                    hintStyle: TextStyle(
                                        color: Color.fromARGB(87, 0, 0, 0))),
                              )),
                          TextButton(
                              onPressed: () async {
                                algo.verificationFormKey.currentState!
                                            .validate() &&
                                        algo.chosenSchool.isEmpty == false
                                    ? await algo
                                        .verifyStudentEmail(
                                            emailFieldController.text)
                                        .then(
                                            (value) => widget.verified = value)
                                    : null;
                              },
                              child: const Text("Verify")),
                          const Spacer()
                        ],
                      ),
                    ),
                  )
                : const Summary(),
            const VerifyCode()
          ]),
    );
  }
}
