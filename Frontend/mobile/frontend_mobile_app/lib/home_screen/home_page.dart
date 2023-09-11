import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api_service.dart';
import 'package:frontend_mobile_app/home_screen/home_provider.dart';
import 'package:frontend_mobile_app/property_flow/property_flow_page.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 18, 18, 18)),
        height: MediaQuery.of(context).padding.bottom + 50,
        //width: MediaQuery.of(context).size.width,
        child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.school,
                color: Colors.white,
              ),
              Icon(Icons.link, color: Colors.white),
              Icon(Icons.person, color: Colors.white)
            ]),
      ),
      body: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {}),
        body: Center(
          child: TextButton(
            onPressed: () async {
              await ApiService.instance!.signout();
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red)),
            child: const Text("SIGN OUT"),
          ),
        ),
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
    return ChangeNotifierProvider(
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
                      : const Home();
                } else {
                  return const Text("ERROR");
                }
              },
            );
          }
        },
      ),
    );
  }
}
