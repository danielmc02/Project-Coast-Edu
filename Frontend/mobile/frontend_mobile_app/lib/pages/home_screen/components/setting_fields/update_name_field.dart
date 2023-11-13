

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import 'package:frontend_mobile_app/theme/styles.dart';

class UpdateNameField extends StatefulWidget {
  const UpdateNameField({super.key});

  @override
  State<UpdateNameField> createState() => _UpdateNameFieldState();
}

class _UpdateNameFieldState extends State<UpdateNameField> {
  TextEditingController nameField = TextEditingController(text: Boxes.getUser()!.name);

  @override
  Widget build(BuildContext context) {
    return TextFormField(controller: nameField,style: Styles.headerText2,decoration: InputDecoration(labelText: "name"),);
  }
}

class UpdateNameProvider extends ChangeNotifier
{
  UpdateNameProvider(){}
  

}