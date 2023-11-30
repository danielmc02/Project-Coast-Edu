import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/api/endpoints.dart';
import 'package:frontend_mobile_app/constants/app_constants.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import 'package:frontend_mobile_app/pages/home_screens/pages/link_page.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  static late CameraController cameraController;

  Future<void> _initCamera() async {
    final cameras = await availableCameras(); // Get available camera devices
    print(cameras);
    CameraDescription? frontCamera;
    for (CameraDescription camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break;
      }
    }
    if (cameras.isEmpty) {
      // Handle the case where no camera is available
      return;
    }
    cameraController = CameraController(
      frontCamera!,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await cameraController.initialize();
    } catch (e) {
      // Handle the initialization error
      print('Camera initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfilePictureProvider(),
      builder: (context, child) => Consumer<ProfilePictureProvider>(
        builder: (context, profilePicProvider, child) => Stack(
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  await _initCamera();
                  Navigator.push(context, CupertinoPageRoute(
                    builder: (context) {
                      return Scaffold(
                          // appBar: PreferredSize(preferredSize: Size.fromHeight(20), child: Container(color: Colors.black,width: 40,)),
                          backgroundColor: Colors.black,
                          body: Column(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: CameraPreview(cameraController)),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: GestureDetector(
                                        onTap: () async {
                                          print("PRESSED");
                                          var picture = await cameraController
                                              .takePicture();

                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                actions: [
                                                  ReusableButton(
                                                      title: "Okay",
                                                      command: () {
                                                        profilePicProvider
                                                            .uploadProfilePicture(
                                                                picture);
                                                      }),
                                                  ReusableButton(
                                                      title: "Retake",
                                                      command: () {
                                                        Navigator.pop(context);
                                                      })
                                                ],
                                                title: const Text(
                                                    "This is your new probile picture"),
                                                content: CircleAvatar(
                                                  radius: 110,
                                                  foregroundImage:
                                                      // NetworkImage("https://08link02storage02.blob.core.windows.net/profile-pictures/IMG_0098.jpg")
                                                      AssetImage(picture.path),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 64,
                                          height: 64,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ));
                    },
                  ));
                } catch (e) {
                  // Handle any errors during camera initialization
                  print('Camera open error: $e');
                }
              },
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(minWidth: 110, minHeight: 110),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.edit,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 10,
              child: Boxes.getUser()!.verifiedStudent == true
                  ? const Icon(
                      Icons.check_circle,
                      size: 30,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.warning,
                      size: 30,
                      color: Colors.yellow,
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfilePictureProvider extends ChangeNotifier {
  ProfilePictureProvider();

  Future<void> uploadProfilePicture(XFile pic) async {
    try {
      print(pic.path.toString());

      List<int> imageAsBytes = await pic.readAsBytes();

      MultipartRequest req =
          await http.MultipartRequest('PUT', Endpoints.updateUserPhoto);
      req.files.add(MultipartFile.fromBytes(
        "Chese field",
        imageAsBytes,
        filename: "${Boxes.getUser()!.id}.png",
      ));
      req.headers['Authorization'] = await Boxes.getUser()!.shortLifeJwt;

      //Send the file to the backend
      Response responce = await http.Response.fromStream(await req.send())
          .timeout(AppConstants.HttpDurationTimeout);
    

    } catch (e) {
      print("We got a problem\n$e");
    }
  }
}
