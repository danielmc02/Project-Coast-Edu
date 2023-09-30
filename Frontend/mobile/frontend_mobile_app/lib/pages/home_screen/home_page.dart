import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/experimental/sliding_sheet.dart';
import 'package:frontend_mobile_app/pages/loading.dart';
import 'package:frontend_mobile_app/theme/styles.dart';

import 'package:provider/provider.dart';

import '../property_flow/property_flow_page.dart';
import 'home_provider.dart';

class Home extends StatefulWidget {
   const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 int index = 2;

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
                color: Colors.grey,
              ),
              FloatingActionButton( backgroundColor: Colors.white,onPressed:(){
                  setState(() {
                    index = 1;
                  });
                },child: const Icon(Icons.link,color: Colors.black,), ),
              IconButton( onPressed:(){
                  setState(() {
                    index = 2;
                  });
                },icon:const Icon(Icons.person), color: Colors.grey)
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
      floatingActionButton: FloatingActionButton(onPressed: (){},backgroundColor: Colors.black, child: const Icon(Icons.add,color: Colors.white,)),
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
      body: const Column(),
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
          const SlidingSheet()
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
void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 0)),
      builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? const SplashLoader(): ChangeNotifierProvider(
        create: (context) => HomeProvider(),
        builder: (context, child) => Consumer<HomeProvider>(
          builder: (context, algo, child) {
            if (algo.needsRebuild) {
              return const Home();
            } else{
              return FutureBuilder(
                future:   algo.requiresOnboarding(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
