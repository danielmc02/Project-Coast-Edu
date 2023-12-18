import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import 'package:frontend_mobile_app/pages/home_screens/pages/profile/settings/setting_fields/update_name_field.dart';
import 'package:frontend_mobile_app/pages/property_flow/propery_process_prrovider.dart';
import 'dart:io';

import 'package:provider/provider.dart';



class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          print("Pressed");
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                title: Text("Settings"),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);

                        await ApiService.instance!.signout();
                      },
                      child: Text("Sign Out")),
                  TextButton(
                      onPressed: () async {
                        print(Boxes.getUser()!.name);
                        Navigator.pop(context);

                        Platform.isIOS
                            ? await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SettingsPage(),
                                ))
                            : await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(),
                                ));
                      },
                      child: Text("Edit Profile"))
                ],
              );
            },
          );
        },
        icon: Icon(Icons.settings));
  }
}

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsPageProvider(),
      builder: (context, child) => Consumer<SettingsPageProvider>(
        builder: (context, settingsProvider, child) => Scaffold(
          appBar: AppBar(title: Text("Settings")),
          body: Column(children: [settingsProvider.updatename, settingsProvider.saveButton]),
        ),
      ),
    );
  }
}

class SaveSettingsButton extends StatelessWidget {
  const SaveSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsPageProvider>(
        builder: (context, settingsProvider, child) => TextButton(
              onPressed: () {},
              child: Text("Save"),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(settingsProvider.saveColor)),
            ));
  }
}

class SettingsPageProvider extends ChangeNotifier {
  SettingsPageProvider() {}
  //initialized immutable reference to compare if name has changed

  final UpdateNameField updatename = UpdateNameField();
  final SaveSettingsButton saveButton = SaveSettingsButton();

  bool hasNewName = false;
  MaterialColor saveColor = Colors.grey;

  List<HttpRunable> updatableFields = List.empty(growable: true);

  Future<void> dealWithNewName(bool value) async {

    hasNewName = value;
    print("Has new value is $hasNewName");
    await runCheck();
  }

  Future<void> runCheck() async {
    List<bool> stateHolder = [hasNewName];
    print("{$stateHolder}");
    if (stateHolder.contains(true)) {
      print("ran in true");
      saveColor = Colors.green;
      notifyListeners();
    } else {
      print("Ran in false");
      saveColor = Colors.grey;
      notifyListeners();
    }
    //await  ?  : Colors.grey;
  }
}
