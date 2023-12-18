import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile_app/api/api_service.dart';
import 'package:frontend_mobile_app/api/endpoints.dart';
import 'package:frontend_mobile_app/constants/app_constants.dart';
import 'package:frontend_mobile_app/models/boxes.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ProfilePictureProvider extends ChangeNotifier {
  ProfilePictureProvider();

  Future<void> uploadProfilePicture(XFile pic) async {
    await ApiService.instance!.checkAndUpdateJwt();
  }
}