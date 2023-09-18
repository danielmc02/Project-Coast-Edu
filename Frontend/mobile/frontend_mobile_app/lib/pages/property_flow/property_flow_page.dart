import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_mobile_app/models/user.dart';
import 'package:frontend_mobile_app/pages/home_screen/home_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PropertyProcessProvider(widget.snapshot),
      child: Consumer<PropertyProcessProvider>(
        builder: (context, algo, child) => Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 92,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: AnimatedBuilder(
                          animation: Listenable.merge([]),
                          builder: (context, child) {
                            print(algo.pageIndex / algo.snapshot.length);
                            return LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                color: Colors.blue,
                                semanticsLabel: "Sign Up Progress Indicator",
                                value: algo.pageIndex /
                                    (algo.snapshot.length - 1));
                          }),
                    ),
                  ],
                )),
            bottomNavigationBar: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height * .1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (algo.pageIndex > 0) {
                          setState(() {
                            int copiedIndex = algo.pageIndex;
                            if ((copiedIndex -= 1) <= -1) {
                              print("woops");
                            } else {
                              algo.reverseTransition = true;
                              algo.pageIndex -= 1;
                            }
                          });
                        }
                      },
                      color: algo.pageIndex != 0
                          ? Colors.black
                          : Colors.transparent,
                      icon: const Icon(Icons.arrow_back),
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    SizedBox(
                      width: 100,
                      child: TextButton(
                        onPressed: () async {
                          algo.reverseTransition = false;
                          algo.state[algo.pageIndex] == true
                              ? algo.nextPage()
                              : null;
                        },
                        style: ButtonStyle(
                            elevation: const MaterialStatePropertyAll(6),
                            shadowColor:
                                const MaterialStatePropertyAll(Colors.black),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.black),
                            surfaceTintColor:
                                const MaterialStatePropertyAll(Colors.black),
                            overlayColor:
                                const MaterialStatePropertyAll(Colors.black12),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        style: BorderStyle.solid))),
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.black)),
                        child: const Text(
                          "Next",
                          style: Styles.buttonText2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: PageTransitionSwitcher(
                  duration: const Duration(seconds: 1),
                  transitionBuilder:
                      (child, primaryAnimation, secondaryAnimation) =>
                          SharedAxisTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  ),
                  reverse: algo.reverseTransition,
                  child: algo.snapshot[algo.pageIndex],
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
                      algo.nameFormKey.currentState!.validate()
                          ? algo.state[algo.pageIndex] = true
                          : algo.state[algo.pageIndex] = false;
                      print(algo.state);
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
              textAlign: TextAlign.center,
            ),
            const Spacer(),
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
                                algo.checkInterestState();
                              }
                            });
                          } else if (e.value['isSelected'] == true) {
                            debugPrint('2');
                            setState(() {
                              e.value['isSelected'] = false;
                              algo.chosen.remove(e.key);
                              algo.checkInterestState();
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
            const Spacer()
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
                            "What school do you attend?",
                            style: Styles.headerText1,
                            textAlign: TextAlign.center,
                          ),
            Spacer(),
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
                                              selected: schoolData['isSelected'],
                                              leading: CircleAvatar(backgroundColor: Colors.white,foregroundImage:schoolData['icon'] ,) ,
                                              dense: false,
                                              // subtitle: const Text("Current Users: "),
                                              title: Text(name,
                                                  textAlign: TextAlign.center,style: TextStyle(color: schoolData['isSelected'] ? Colors.black : Colors.white60),),
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
                                        .validate() && algo.chosenSchool.isEmpty == false
                                    ? algo.verifyStudentEmail(
                                        emailFieldController.text)
                                    : null;
                              },
                              child: const Text("Verify")),Spacer()
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

Widget schoolCard(String schoolName) {
  return Container(
    //decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/occ.jpeg"))),
    width: 350,
    height: 275,
    padding: const EdgeInsets.all(32),
    child: Card(
      elevation: 9,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      surfaceTintColor: Colors.red,
    child: Container(
      child: Stack(
        children: [
          Container(width: double.infinity,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: const Color.fromARGB(93, 0, 0, 0)),),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(backgroundColor: Colors.white,foregroundImage: AssetImage("assets/school_icons/occ.png"),),
              FittedBox(child: Text("Orange Coast College",style: Styles.buttonText2,maxLines: 3,))
            ],
          )
        ],
      ),
    decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover,image: AssetImage("assets/occ.jpeg")),color: Colors.black,borderRadius: BorderRadius.circular(20))),
      
    ),
    //decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),image: DecorationImage(image: AssetImage("assets/occ.jpeg"))),
  );
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
                  child: const Text("SEE STATS"))
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
