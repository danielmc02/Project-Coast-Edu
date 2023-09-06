import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_mobile_app/theme/styles.dart';
import 'package:provider/provider.dart';

import 'propery_process.dart';

class PropertyProcessPage extends StatefulWidget {
  const PropertyProcessPage(this.snapshot, {super.key});
  final AsyncSnapshot<List> snapshot;
  @override
  State<PropertyProcessPage> createState() => _PropertyProcessPageState();
}

class _PropertyProcessPageState extends State<PropertyProcessPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PropertyProcessProvider(),
      child: Consumer<PropertyProcessProvider>(
        builder: (context, ppp, child) => Scaffold(
            bottomNavigationBar: Container(
              color: Colors.black,
              height: 79,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(onPressed: (){
                      if(ppp.pageController.page! > 0)
                      {
                      ppp.pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeOutSine).then((value) 
                      {
                        if(ppp.pageController.page! == 0)
                        {
                          ppp.changeColor(Colors.transparent);
                        }
                      });

                      }
                    },color:  ppp.backButtonColor,icon: const Icon(Icons.arrow_back),),
                    TextButton(
                      onPressed: () async {
                        switch (ppp.pageController.page) {
                          case 0:
                            //Name page, check that it's at least longer than 2
                            ppp.checkNamePage()
                                ? await ppp.pageController.nextPage(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInSine).then((value) => ppp.changeColor(Colors.white)) 
                                : null;
                            break;

                          case 1:
                            ppp.checkInterestPage()
                                ? await ppp.pageController.nextPage(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInSine)
                                : null;
                            break;
                          default:
                        }
                      },
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                      style: BorderStyle.solid))),
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.white)),
                      child: const Text(
                        "Next",
                        style: Styles.buttonText,
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: PageView.builder(
              controller: ppp.pageController,
              itemCount: widget.snapshot.data!.length,
              itemBuilder: (context, index) {
                return widget.snapshot.data![index];
              },
            )),
      ),
    );
  }
}

class NamePage extends StatelessWidget {
  const NamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProcessProvider>(
      builder: (context, algo, child) => Scaffold(
        body: Form(
          key: algo.nameFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "What's your name?",
                style: Styles.headerText,
              ),
              SizedBox(
                  width: 300,
                  child: TextFormField(
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
                    decoration: const InputDecoration(
                        hintText: "Your name here",
                        hintStyle:
                            TextStyle(color: Color.fromARGB(87, 0, 0, 0))),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProcessProvider>(
      builder: (context, algo, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "What Interests You?",
              style: Styles.headerText,
            ),
            Wrap(
                verticalDirection: VerticalDirection.down,
                runSpacing: 20,
                spacing: 20,
                direction: Axis.horizontal,
                textDirection: TextDirection.ltr,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  for (var e in algo.possibleMap.entries)
                    ChoiceChip(
                        elevation: e.value['isSelected'] ? 3 : 0,
                        selectedColor: e.value['color'],
                        label: Text(
                          e.key,
                          style: Styles.chipText,
                        ),
                        selected: e.value['isSelected'],
                        onSelected: (value) {
                          if (algo.chosen.length < 3 &&
                              e.value['isSelected'] ==
                                  false) //volume isn't at max
                          {
                            print('1');

                            setState(() {
                              e.value['isSelected'] = !e.value['isSelected'];
                              if (e.value['isSelected'] == true) {
                                algo.chosen.add(e.key);
                              }
                            });
                          } else if (e.value['isSelected'] == true) {
                            print('2');
                            setState(() {
                              e.value['isSelected'] = false;
                              algo.chosen.remove(e.key);
                            });
                          } else {
                            print('2.5');
                            print('Cant select because 3 is already chosen');
                          }

                          //  e.value.entries.elementAt(1).
                        },
                        avatar: e.value['icon'])
                ]),
          ],
        ),
      ),
    );
  }
}

class VerifiedStudentPage extends StatefulWidget {
  const VerifiedStudentPage({super.key, });

  @override
  State<VerifiedStudentPage> createState() => _VerifiedStudentPageState();
}

class _VerifiedStudentPageState extends State<VerifiedStudentPage> {
  late TextEditingController emailFieldController;
  @override
  void initState() {
    // TODO: implement initState
   emailFieldController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    emailFieldController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProcessProvider>(
      builder: (context, algo, child) => Form(
        key: algo.verificationFormKey,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Are you a student?",
                style: Styles.headerText,
              ),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(algo.supportedSchools.length, (index) {
                        String name = algo.supportedSchools.keys.elementAt(index);
                        Map<String, dynamic> schoolData = algo.supportedSchools[name];
      
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                // Deselect all tiles first
                                algo.supportedSchools.forEach((key, value) {
                                  value['isSelected'] = false;
                                });
      
                                // Select the tapped tile and update chosenSchool
                                schoolData['isSelected'] = true;
                                algo.chosenSchool = [name];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                                color: schoolData['isSelected'] ? Colors.white : null,
                              ),
                              width: 300,
                              child: ListTile(
                                tileColor: Colors.grey,
                                selected: schoolData['isSelected'],
                                leading: schoolData['icon'],
                                dense: false,
                               // subtitle: const Text("Current Users: "),
                                title: Text(name, textAlign: TextAlign.center),
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
                    width: 300,
                    child: TextFormField(
                      controller: emailFieldController,
                     // key: algo.verificationFormKey,
                      validator: (value) {
                        return value!.contains('@student.cccd.edu')
                            ? null
                            : "Invalid school email format";
                      },
                      maxLines: 1,
                     // maxLength: 20,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      textAlign: TextAlign.center,inputFormatters: [
                        FilteringTextInputFormatter.deny(' ')
                      ],
                      decoration: const InputDecoration(
                          hintText: "example@cccd.edu.com",
                          hintStyle:
                              TextStyle(color: Color.fromARGB(87, 0, 0, 0))),
                    )),
                    TextButton(onPressed: ()async{
                      algo.verificationFormKey.currentState!.validate() ; algo.verifyStudentEmail(emailFieldController.text);
                    }, child: Text("Verify"))
              
            ],
          ),
        ),
      ),
    );
  }
}






//              ListTile(dense:false ,subtitle: Text("Current Users: "),leading: e.value['icon'],title: Text(e.key.toString(),textAlign: TextAlign.center),)

class CapitalizedWordsTextInputFormatter extends FilteringTextInputFormatter {
  CapitalizedWordsTextInputFormatter() : super.allow(RegExp(r'^[A-Za-z\s]*$'));

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any digits from the input text
    final textWithoutDigits = newValue.text.replaceAll(RegExp(r'\d'), '');

    // Capitalize the first letter of each word
    final newString = textWithoutDigits.replaceAllMapped(
      RegExp(r'\b\w'),
      (match) => match.group(0)!.toUpperCase(),
    );

    // Calculate the updated selection range while ensuring it's within bounds
    final updatedSelection = newValue.selection.copyWith(
      baseOffset: newValue.selection.baseOffset <= newString.length
          ? newValue.selection.baseOffset
          : newString.length,
      extentOffset: newValue.selection.extentOffset <= newString.length
          ? newValue.selection.extentOffset
          : newString.length,
    );

    return TextEditingValue(
      text: newString,
      selection: updatedSelection,
    );
  }
}
