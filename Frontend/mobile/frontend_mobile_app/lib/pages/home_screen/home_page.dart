import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/experimental/sliding_sheet.dart';
import 'package:frontend_mobile_app/pages/loading.dart';

import 'package:provider/provider.dart';

import '../property_flow/property_flow_page.dart';
import 'home_provider.dart';

class Home extends StatefulWidget {
   Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 int index = 2;

final List<Widget> items = [School(),Link(),Profile()];

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
                  print("school");
                },
               icon: Icon(Icons.school),
                color: Colors.grey,
              ),
              FloatingActionButton( backgroundColor: Colors.white,onPressed:(){
                  setState(() {
                    index = 1;
                  });
                  print("link");
                },child: Icon(Icons.link,color: Colors.black,), ),
              IconButton( onPressed:(){
                  setState(() {
                    index = 2;
                  });
                  print("profile");
                },icon:Icon(Icons.person), color: Colors.grey)
            ]),
      ),
      body: items[index]);
  }
}

class School extends StatelessWidget {
  const School({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class Link extends StatelessWidget {
  const Link({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Stack(
          children: [
            Center(
              child: TextButton(
                onPressed: () async {
                  await ApiService.instance!.signout();
                },
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                child: const Text("SIGN OUT"),
              ),
            ),
          SlidingSheet()
          ],
        ),
      );
    
  }
}

class HomeLoader extends StatefulWidget {
  const HomeLoader({super.key});

  @override
  State<HomeLoader> createState() => _HomeLoaderState();
}

class _HomeLoaderState extends State<HomeLoader> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 0)),
      builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? SplashLoader(): ChangeNotifierProvider(
        create: (context) => HomeProvider(),
        builder: (context, child) => Consumer<HomeProvider>(
          builder: (context, algo, child) {
            if (algo.needsRebuild) {
              return Home();
            } else {
              return FutureBuilder(
                future: algo.preReqSetup(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    //if algo.TRIGGERRESET == true ?
                    return snapshot.data!.isNotEmpty == true
                        ? PropertyProcessPage(snapshot)
                        :  Home();
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
