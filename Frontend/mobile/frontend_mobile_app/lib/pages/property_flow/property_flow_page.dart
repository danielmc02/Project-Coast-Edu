import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/models/user.dart';
import 'package:frontend_mobile_app/theme/styles.dart';
import 'package:provider/provider.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import '../home_screen/home_provider.dart';
import 'propery_process_prrovider.dart';

class PropertyProcessPage extends StatefulWidget {
  const PropertyProcessPage({super.key});

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
                            return LinearProgressIndicator(
                                backgroundColor:
                                    const Color.fromARGB(255, 158, 158, 158),
                                color: const Color.fromARGB(255, 2, 144, 246),
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                semanticsLabel: "Sign Up Progress Indicator",
                                value: algo.pageIndex /
                                    (algo.onboardPages.length ));
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
                      child: Consumer<HomeProvider>(
                        builder: (context, algo2, child) => TextButton(
                          onPressed: () async {
                            if (algo.canFinish) {
                              //what about calling handle user
                              await algo.finishAll().then((value) async {
                                await ApiService.instance!
                                    .updateLocalUserInfo()
                                    .then((value) {
                                  if (value) {
                                    algo2.trueRebuild();
                                  }
                                });
                              });
                            }
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
                              overlayColor: const MaterialStatePropertyAll(
                                  Colors.black12),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                          style: BorderStyle.solid))),
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.black)),
                          child: Text(
                            algo.canFinish ? "Finish" : "Next",
                            style: Styles.buttonText2,
                          ),
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
                  child: algo.onboardPages[algo.pageIndex] as Widget,
                ) /*
              PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: ppp.pageController,
                itemCount: widget.onboardPages.data!.length,
                itemBuilder: (context, index) {
                  return widget.onboardPages.data![index];
                },
              ),
           */

                )),
      ),
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
          decoration: BoxDecoration(
              image: const DecorationImage(
                  fit: BoxFit.cover, image: AssetImage("assets/occ.jpeg")),
              color: Colors.black,
              borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(93, 0, 0, 0)),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    foregroundImage: AssetImage("assets/school_icons/occ.png"),
                  ),
                  FittedBox(
                      child: Text(
                    "Orange Coast College",
                    style: Styles.buttonText2,
                    maxLines: 3,
                  ))
                ],
              )
            ],
          )),
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
  CapitalizedWordsTextInputFormatter() : super.allow(RegExp(r'^[A-Za-z\s.]*$'));

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

    // Replace consecutive spaces with a single space
    final newStringWithSingleSpace = newString.replaceAll(RegExp(r'\s{2,}'), ' ');

    // Calculate the updated selection range while ensuring it's within bounds
    final updatedSelection = newValue.selection.copyWith(
      baseOffset: newValue.selection.baseOffset <= newStringWithSingleSpace.length
          ? newValue.selection.baseOffset
          : newStringWithSingleSpace.length,
      extentOffset: newValue.selection.extentOffset <= newStringWithSingleSpace.length
          ? newValue.selection.extentOffset
          : newStringWithSingleSpace.length,
    );

    return TextEditingValue(
      text: newStringWithSingleSpace,
      selection: updatedSelection,
    );
  }
}
