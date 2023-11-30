import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/pages/home_screens/pages/link_page.dart';
import 'package:frontend_mobile_app/pages/home_screens/pages/profile_page.dart';
import 'package:frontend_mobile_app/pages/home_screens/pages/school_page.dart';
import 'package:frontend_mobile_app/pages/loading.dart';

import 'package:provider/provider.dart';

import '../property_flow/property_flow_page.dart';
import 'home_provider.dart';

class Home extends StatefulWidget {
   const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 int index = 1;

final List<Widget> items = [const School(),const Link(),const Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
        height: MediaQuery.of(context).padding.bottom + 50,
        //width: MediaQuery.of(context).size.width,
        child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(

                onPressed:(){
                  setState(() {
                    index = 0;
                  });
                },
               icon: const Icon(Icons.school),
                color: index == 0 ? Colors.black : Colors.grey
              ),
              IconButton( onPressed:(){
                  setState(() {
                    index = 1;
                  });
                },icon: const Icon(Icons.link,),color: index == 1 ? Colors.black : Colors.grey, ),
              IconButton( onPressed:(){
                  setState(() {
                    index = 2;
                  });
                },icon: const Icon(Icons.person), color: index == 2 ? Colors.black : Colors.grey)
            ]),
      ),
      body: items[index]);
  }
}







class HomeLoader extends StatefulWidget {
  const HomeLoader({super.key});

  @override
  State<HomeLoader> createState() => _HomeLoaderState();
}

class _HomeLoaderState extends State<HomeLoader> {
@override
void initState() {
  print("Home loader inited");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 0)),
      builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? const SplashLoader(): ChangeNotifierProvider(
        create: (context) => HomeProvider(),
        builder: (context, child) => Consumer<HomeProvider>(
          builder: (context, HomeProvider, child) {
            if (HomeProvider.needsRebuild) {
              return const Home();
            } else{
              return FutureBuilder(
                future:   HomeProvider.needsToHandleProperties(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SplashLoader();
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    //if algo.TRIGGERRESET == true ?
                    return snapshot.data! == true
                        ? const PropertyProcessPage()
                        :  const Home();
                  } else {
                    return const Text("ERROR");
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
