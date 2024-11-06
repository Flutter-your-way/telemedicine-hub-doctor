// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:telemedicine_hub_doctor/common/constants/app_constants.dart';
import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
import 'package:telemedicine_hub_doctor/common/managers/network_manager.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';
import 'package:telemedicine_hub_doctor/features/profile/widget/loading_dialog.dart';

class ProfileProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<CustomResponse> resetPassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "email": email,
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      };

      log(data.toString());
      var r =
          await NetworkDataManger(client: http.Client()).postResponseFromUrl(
        "${baseAuthUrl}doctor/reset-password",
        data: data,
        headers: {"Authorization": "Bearer $accessToken", "type": "doctor"},
      );

      log(r.body);

      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;

      if (success) {
        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: responseBody,
        );
      } else {
        return CustomResponse(
          success: false,
          msg: responseBody['msg'] ?? 'Failed to send OTP',
          code: r.statusCode,
          data: {},
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return CustomResponse(success: false, msg: "Failed to verify", code: 400);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<CustomResponse> uploadProfilePicture({
    required File file,
    required BuildContext context,
  }) async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();
    LoadingDialog.showLoadingDialog(context);
    File compressedFile = await compressImage(file);

    try {
      var uri = Uri.parse("${baseAuthUrl}doctor/upload-profile-image");
      var request = http.MultipartRequest("PUT", uri)
        ..fields['directoryType'] = "profile"
        ..headers['type'] = 'doctor'
        ..headers['Authorization'] = 'Bearer $accessToken';

      var stream = http.ByteStream(compressedFile.openRead());
      var length = await compressedFile.length();
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: 'profile_image.jpg');
      request.files.add(multipartFile);

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var resBody = jsonDecode(responseBody);

      int statusCode = response.statusCode;
      bool success = resBody['success'] ?? false;
      if (statusCode == 200 && success) {
        return CustomResponse(
          success: true,
          msg: resBody['msg'],
          code: statusCode,
          data: {},
        );
      } else {
        return CustomResponse(
          success: false,
          msg: resBody['msg'] ?? 'Failed to upload file',
          code: statusCode,
          data: {},
        );
      }
    } catch (e) {
      return CustomResponse(success: false, msg: "Failed to Upload", code: 400);
    } finally {
      isLoading = false;
      notifyListeners();
      LoadingDialog.hideLoadingDialog(context);
    }
  }

  Future<File> compressImage(File file) async {
    // Read the original image
    final originalImage = img.decodeImage(file.readAsBytesSync());

    // Resize and compress the image
    final compressedImage =
        img.copyResize(originalImage!, width: 800); // Resize to a smaller width

    // Save the compressed image
    final compressedFile = File(file.path)
      ..writeAsBytesSync(img.encodeJpg(compressedImage, quality: 85));

    return compressedFile;
  }
}
