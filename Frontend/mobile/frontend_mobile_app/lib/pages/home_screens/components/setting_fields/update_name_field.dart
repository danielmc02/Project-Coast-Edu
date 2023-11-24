import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import 'package:frontend_mobile_app/pages/home_screens/components/settings.dart';
import 'package:frontend_mobile_app/pages/property_flow/property_flow_page.dart';
import 'package:frontend_mobile_app/theme/styles.dart';
import 'package:provider/provider.dart';

class UpdateNameField extends StatefulWidget {
  const UpdateNameField({super.key});

  @override
  State<UpdateNameField> createState() => _UpdateNameFieldState();
}

class _UpdateNameFieldState extends State<UpdateNameField> {
  TextEditingController nameField =
      TextEditingController(text: Boxes.getUser()!.name);
  final nameKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsPageProvider>(
      builder: (context, settingsProvider, child) => Form(
        key: nameKey,
        child: TextFormField(
          onChanged: (value) async {
            //* If is 3 or greater and dosen't equal origninal name 
            if (nameKey.currentState!.validate() == true && value != Boxes.getUser()!.name) {
                          

              await settingsProvider.dealWithNewName(true);
            }
            else
            {
                            await settingsProvider.dealWithNewName(false);

            }
          },

          autovalidateMode: AutovalidateMode.always,
          cursorColor: Colors.black,
          maxLines: 1,
          maxLength: 20,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          inputFormatters: [CapitalizedWordsTextInputFormatter()],
          validator: (value) {
            return value!.length < 3 ? "Must be at least 3 characters" : null;
          },
          controller: nameField,
          style: Styles.headerText2,
          decoration: InputDecoration(labelText: "name"),
        ),
      ),
    );
  }
}

