import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api_service.dart';
import 'package:frontend_mobile_app/boxes.dart';
import 'package:frontend_mobile_app/home_screen/home_page.dart';
import 'package:frontend_mobile_app/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'onboarding_screen/onboarding_page.dart';

void main() async {
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
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper() /*AuthWrapper()*/);
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

@override
  void initState()
{
  Boxes.getUserBox().delete('mainUser');
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ApiService.apiInstance!,
        child: Consumer<ApiService>(builder: (context, algo, child) {
          return algo.signedIn == true ? const HomeLoader()/*Home()*/ : const OnboardingPage();
        }));
  }
}