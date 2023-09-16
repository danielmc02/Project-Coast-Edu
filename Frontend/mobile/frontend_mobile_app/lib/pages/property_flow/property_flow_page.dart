import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_mobile_app/models/user.dart';
import 'package:frontend_mobile_app/theme/styles.dart';
import 'package:provider/provider.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import '../home_screen/home_provider.dart';
import 'propery_process_prrovider.dart';

class PropertyProcessPage extends StatefulWidget {
  const PropertyProcessPage(this.snapshot, {super.key});
  final List<Widget> snapshot;
  @override
  State<PropertyProcessPage> createState() => _PropertyProcessPageState();
}

class _PropertyProcessPageState extends State<PropertyProcessPage> {
  @override
  void initState() {
    super.initState();
  }
int pageIndex = 0;
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
                    IconButton(
                      onPressed: () {
                        if (ppp.pageController.page! > 0) {
                          ppp.pageController
                              .previousPage(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOutSine)
                              .then((value) {
                            if (ppp.pageController.page! == 0) {
                              ppp.changeColor(Colors.transparent);
                            }
                          });
                        }
                      },
                      color: ppp.backButtonColor,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    TextButton(
                      onPressed: () async {
                  setState(() {
                    pageIndex +=1;
                  });
                      /*  switch (ppp.pageController.page) {
                          case 0:
                            //Name page, check that it's at least longer than 2
                            ppp.checkNamePage()
                                ? await ppp.pageController
                                    .nextPage(
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInSine)
                                    .then((value) =>
                                        ppp.changeColor(Colors.white))
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
                */      },
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
            body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: PageTransitionSwitcher(
                  duration: Duration(seconds: 1),

child: widget.snapshot[pageIndex] ,
                  transitionBuilder: (child, primaryAnimation,
                          secondaryAnimation) =>
                      SharedAxisTransition(
                          animation: primaryAnimation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                          child: child,),
                ) /*
              PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: ppp.pageController,
                itemCount: widget.snapshot.data!.length,
                itemBuilder: (context, index) {
                  return widget.snapshot.data![index];
                },
              ),
           */

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
                style: Styles.headerText1,
              ),
              SizedBox(
                  width: 300,
                  child: TextFormField(
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
              style: Styles.headerText1,
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
                            debugPrint('1');

                            setState(() {
                              e.value['isSelected'] = !e.value['isSelected'];
                              if (e.value['isSelected'] == true) {
                                algo.chosen.add(e.key);
                              }
                            });
                          } else if (e.value['isSelected'] == true) {
                            debugPrint('2');
                            setState(() {
                              e.value['isSelected'] = false;
                              algo.chosen.remove(e.key);
                            });
                          } else {
                            debugPrint('2.5');
                            debugPrint(
                                'Cant select because 3 is already chosen');
                          }
                          print(algo.chosen);
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
  const VerifiedStudentPage({
    super.key,
  });

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
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Are you a student?",
                            style: Styles.headerText1,
                          ),
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
                                          print(algo.chosenSchool);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: schoolData['isSelected']
                                                ? Colors.white
                                                : null,
                                          ),
                                          width: 300,
                                          child: ListTile(
                                            tileColor: Colors.grey,
                                            selected: schoolData['isSelected'],
                                            leading: schoolData['icon'],
                                            dense: false,
                                            // subtitle: const Text("Current Users: "),
                                            title: Text(name,
                                                textAlign: TextAlign.center),
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
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(' ')
                                ],
                                decoration: const InputDecoration(
                                    hintText: "example@cccd.edu.com",
                                    hintStyle: TextStyle(
                                        color: Color.fromARGB(87, 0, 0, 0))),
                              )),
                          TextButton(
                              onPressed: () async {
                                algo.verificationFormKey.currentState!
                                        .validate()
                                    ? algo.verifyStudentEmail(
                                        emailFieldController.text)
                                    : null;
                              },
                              child: const Text("Verify"))
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

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProcessProvider>(
      builder: (context, algo, child) => Scaffold(
          appBar: AppBar(),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                "You're all set!",
                style: Styles.headerText1,
              ),
              const Text(
                "Here are some things you should look out for",
                style: Styles.headerText2,
              ),
              const Text("1. Go to your profile and add some pictures."),
              const Text(
                  "2. Some campus features are enabled by default. Go to Your Campus to disable them"),
              const Text("3. IDK BUT THIS IS TODO"),
              Consumer<HomeProvider>(
                builder: (context, algo2, child) => TextButton(
                    onPressed: () async {
                      if (await algo.updateUserPreferences() == 200) {
                        User template = Boxes.getUser()!;
                        template.name = algo.nameController.text;
                        template.interests = algo.chosen;
                        template.verifiedStudent = algo.validatedEmail;
                        await Boxes.getUserBox().put('mainUser', template);
                        algo2.trueRebuild();
                      }
                    },
                    child: const Text("FINish")),
              ),
              TextButton(
                  onPressed: () {
                    algo.printStats();
                  },
                  child: Text("SEE STATS"))
            ],
          )),
    );
  }
}

class VerifyCode extends StatelessWidget {
  const VerifyCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProcessProvider>(
      builder: (context, algo, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 1.5),
                  child: RichText(
                    softWrap: true,
                    text: const TextSpan(
                      style: Styles.headerText1,
                      children: [
                        TextSpan(text: "We will ", style: Styles.headerText1
                            // Add any styles you want for the rest of the text here
                            ),
                        TextSpan(
                          text: "NEVER",
                          style: TextStyle(
                              fontSize: 44,
                              color: Colors.black,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: " charge for blue checks",
                            style: Styles.headerText1
                            // Add any styles you want for the rest of the text here
                            ),
                      ],
                    ),
                  ),
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width / 2),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 80,
                    ))
              ],
            ),
            const Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                    style: Styles.headerText2,
                    "But we do email you to make sure you’re real. Enter the 4-digit code that was sent to your student email.")
              ],
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: TextField(
                  onChanged: (value) {
                    algo.givenCode.toString() == value
                        ? algo.emailValidated()
                        : null;
                  },
                  cursorColor: Colors.black,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: "4 digit code",
                      counterText: "",
                      border: InputBorder.none),
                ))
          ],
        ),
      ),
    );
  }
}

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
