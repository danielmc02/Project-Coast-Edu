

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
      bottomNavigationBar:  ReusableButton(title: "Create a Chain"),
    );
  }
}

class ReusableButton extends StatelessWidget {
   ReusableButton({super.key, required this.title});
  late String title;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(widthFactor: .9,child: TextButton(onPressed: (){}, child: Text(title,style: Styles.buttonText2,),style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.black),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
    ),));
  }
}