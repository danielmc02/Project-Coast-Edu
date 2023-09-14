import 'package:flutter/material.dart';

class SlidingSheet extends StatefulWidget {
  const SlidingSheet({super.key});

  @override
  State<SlidingSheet> createState() => _SlidingSheetState();
}

class _SlidingSheetState extends State<SlidingSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 4.5),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Color.fromARGB(255, 229, 229, 229)),
              )) //color: Color.fromARGB(255, 245, 245, 245)
        ],
      ),
    );
  }
}
