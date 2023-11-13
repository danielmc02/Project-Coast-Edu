import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import 'package:frontend_mobile_app/pages/home_screen/components/setting_fields/sign_out_button.dart';
import 'package:frontend_mobile_app/pages/home_screen/components/setting_fields/update_name_field.dart';
import 'dart:io';

import 'package:frontend_mobile_app/theme/styles.dart';
import 'package:provider/provider.dart';
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: ()async{
      print("Pressed");
      Platform.isIOS ? await Navigator.push(context, CupertinoPageRoute(builder: (context) =>SettingsPage() ,)): await Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(),));
    }, icon: Icon(Icons.settings));
  }
}

class SettingsPage extends StatelessWidget {
   SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsPageProvider(),
      builder: (context, child) =>  Consumer<SettingsPageProvider>(
        builder: (context, settingsProvider, child) =>  Scaffold(
          appBar: AppBar(title: Text("Settings")),
          body: Column(children: [
           UpdateNameField(),
        SignOutButton()
          
          ]),
        ),
      ),
    );
  }
}



class SettingsPageProvider extends ChangeNotifier
{

}