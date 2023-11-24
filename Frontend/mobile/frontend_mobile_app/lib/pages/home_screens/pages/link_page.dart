

import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/theme/styles.dart';

class Link extends StatelessWidget {
  const Link({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // floatingActionButton: FloatingActionButton(onPressed: (){},backgroundColor: Colors.black, child: const Icon(Icons.add,color: Colors.white,)),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("All",style: Styles.headerText2,),
            Text("Links"),
            Text("Chains")
          ],
        
        )
      ),
      body: const Column(
        children: [],
      ),
      bottomNavigationBar:  ReusableButton(title: "Create a Chain",command: () {
        showDialog(context: context, builder: (context) {
          return AlertDialog(actions: [
            ReusableButton(title: "Continue", command: (){})
          ],alignment: Alignment.center,title: const Text("All big things start small"),content: const Column(mainAxisSize: MainAxisSize.min,
            children: [Text("1. Create a chain\n2. Users will be notified\n3. With enough people interested, you have created a link")],
          ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          );
        },);
      },),
    );
  }
}

class ReusableButton extends StatelessWidget {
   ReusableButton({super.key, required this.title, required this.command});
  late String title;
  late void Function()? command;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(widthFactor: .9,child: TextButton(onPressed:command,style: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Colors.black),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
    ), child: Text(title,style: Styles.buttonText2,),));
  }
}