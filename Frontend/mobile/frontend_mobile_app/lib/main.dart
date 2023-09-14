import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import 'package:frontend_mobile_app/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'pages/home_screen/home_page.dart';
import 'pages/onboarding_screen/onboarding_page.dart';



void main() async {
  //init everything and user model
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('mainUser');

  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      routes: {
        'home' : (context) => HomeLoader()
      },
        debugShowCheckedModeBanner: false, home: AuthWrapper());
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    //Only delete the below if necessary. This can cause the app to become unstable
    Boxes.getUserBox().delete('mainUser');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ApiService.instance!,
        child: Consumer<ApiService>(builder: (context, algo, child) {
          return algo.signedIn == true
              ? const HomeLoader()
              : const OnboardingPage();
        }));
  }
}
