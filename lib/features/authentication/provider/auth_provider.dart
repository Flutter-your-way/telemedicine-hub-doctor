import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:telemedicine_hub_doctor/common/constants/app_constants.dart';
import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
import 'package:telemedicine_hub_doctor/common/managers/network_manager.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';

import 'package:telemedicine_hub_doctor/common/models/doctor_model.dart';
import 'package:telemedicine_hub_doctor/features/splash/screen/splash_screen.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  late String _authToken;
  late String _refreshToken;
  DoctorModel? _usermodel;

  set authToken(String _) {
    _authToken = _;
    notifyListeners();
  }

  String get authToken => _authToken;
  String get refreshToken => _refreshToken;
  DoctorModel? get usermodel => _usermodel;

  Future<CustomResponse> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {
        "email": email,
        "password": password,
      };
      var r =
          await NetworkDataManger(client: http.Client()).postResponseFromUrl(
        "${baseAuthUrl}doctor/login-doctor",
        data: data,
      );

      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;

      if (success) {
        print("happending");
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        String token = responseBody['data']['accessToken'];
        String userId = responseBody['data']['doctor']['_id'];

        String refreshToken = responseBody['data']['accessToken'];
        print("refreshToken ${refreshToken}");
        print("token ${token}");
        print("token ${userId}");

        await LocalDataManager.storeToken(token);
        await LocalDataManager.storeRefreshToken(refreshToken);
        await LocalDataManager.storeId(userId);

        _authToken = token;

        await getUser();
        await updateToken(
            deviceToken: fcmToken.toString(),
            id: responseBody['data']['doctor']['_id']);

        notifyListeners();

        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: responseBody,
        );
      } else {
        return CustomResponse(
          success: false,
          msg: responseBody['msg'] ?? 'Failed to Login',
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

  Future<CustomResponse> logOut(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      LocalDataManager.deleteRefreshToken();
      LocalDataManager.deleteToken().then(
        (value) async {
          notifyListeners();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false,
          );
          _usermodel = null;
        },
      );
      return CustomResponse(
        msg: "Logged out !",
        code: 200,
        data: "Logged out ",
        success: true,
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return CustomResponse(
          success: false, msg: "Failed to register", code: 201);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Future<CustomResponse> getUser() async {
  //   try {
  //     String? accessToken = await LocalDataManager.getToken();
  //     var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
  //         "${baseAuthUrl}doctor/get-doctor-by-id/",
  //         headers: {"Authorization": "Bearer $accessToken", "type": "doctor"});
  //     var responseBody = jsonDecode(r.body);
  //     bool success = responseBody['success'] ?? false;
  //     if (success) {
  //       FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
  //         await updateToken(
  //             deviceToken: newToken, id: responseBody['data']['user']['_id']);
  //       });
  //       log(r.body);

  //       DoctorModel u = DoctorModel(
  //         id: responseBody['data']['user']['_id'],
  //         nameEnglish: responseBody['data']['user']['name_english'],
  //         nameArabic: responseBody['data']['user']['name_arabic'],
  //         nameKurdish: responseBody['data']['user']['name_kurdish'],
  //         email: responseBody['data']['user']['email'],
  //         type: responseBody['data']['user']['type'],
  //         isAvailable: responseBody['data']['user']['isAvailable'],
  //         isBlocked: responseBody['data']['user']['isBlocked'],
  //         gender: responseBody['data']['user']['gender'],
  //         languages: (responseBody['data']['user']['languages'] != null)
  //             ? List<String>.from(responseBody['data']['user']['languages'])
  //             : null,
  //         specialization: responseBody['data']['user']['specialization'] != null
  //             ? Specialization.fromJson(
  //                 responseBody['data']['user']['specialization'])
  //             : null,
  //         averageRating:
  //             responseBody['data']['user']['averageRating']?.toDouble(),
  //         ratings: (responseBody['data']['user']['ratings'] != null)
  //             ? List<Rating>.from(
  //                 responseBody['data']['user']['ratings']
  //                     .map((rating) => Rating.fromJson(rating)),
  //               )
  //             : null,
  //         accountStatus: responseBody['data']['user']['accountStatus'],
  //         availability: responseBody['data']['user']['availability'] != null
  //             ? Availability.fromJson(
  //                 responseBody['data']['user']['availability'])
  //             : null,
  //         createdAt: responseBody['data']['user']['createdAt'] != null
  //             ? DateTime.parse(responseBody['data']['user']['createdAt'])
  //             : null,
  //         updatedAt: responseBody['data']['user']['updatedAt'] != null
  //             ? DateTime.parse(responseBody['data']['user']['updatedAt'])
  //             : null,
  //         deviceToken: responseBody['data']['user']['deviceToken'],
  //       );
  //       _usermodel = u;

  //       notifyListeners();

  //       return CustomResponse(
  //         success: true,
  //         msg: responseBody['msg'],
  //         code: r.statusCode,
  //         data: responseBody,
  //       );
  //     } else {
  //       return CustomResponse(
  //         success: false,
  //         msg: responseBody['msg'] ?? 'Failed to get User',
  //         code: r.statusCode,
  //         data: {},
  //       );
  //     }
  //   } catch (e) {
  //     return CustomResponse(
  //         success: false, msg: "Failed to get User", code: 400);
  //   }
  // }

  Future<CustomResponse> getUser() async {
    try {
      String? accessToken = await LocalDataManager.getToken();
      var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
          "${baseAuthUrl}doctor/get-doctor-by-id",
          headers: {"Authorization": "Bearer $accessToken"});

      var responseBody = jsonDecode(r.body);
      bool success = responseBody['success'] ?? false;
      print(responseBody);

      if (success) {
        DoctorModel u = DoctorModel.fromJson(responseBody['data']['doctor']);
        print(u.email);

        handleFCMTokenRefresh(u.id.toString());

        _usermodel = u;
        notifyListeners();

        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: responseBody,
        );
      } else {
        print("Failed to get User");
        return CustomResponse(
          success: false,
          msg: responseBody['msg'] ?? 'Failed to get User',
          code: r.statusCode,
          data: {},
        );
      }
    } catch (e) {
      print(e.toString());
      return CustomResponse(
          success: false, msg: "Failed to get User", code: 400);
    }
  }

// Separate method to handle FCM token refresh
  void handleFCMTokenRefresh(String userId) {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await updateToken(deviceToken: newToken, id: userId);
    });
  }

  // Future<CustomResponse> getUser() async {
  //   try {
  //     String? accessToken = await LocalDataManager.getToken();
  //     var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
  //         "${baseAuthUrl}doctor/get-doctor-by-id/",
  //         headers: {"Authorization": "Bearer $accessToken", "type": "doctor"});

  //     var responseBody = jsonDecode(r.body);
  //     bool success = responseBody['success'] ?? false;

  //     if (success) {
  //       // Handle FCM token refresh
  //       FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
  //         await updateToken(
  //             deviceToken: newToken, id: responseBody['data']['user']['_id']);
  //       });

  //       DoctorModel u = DoctorModel(
  //         id: responseBody['data']['user']['_id'],
  //         nameEnglish: responseBody['data']['user']['name_english'],
  //         nameArabic: responseBody['data']['user']['name_arabic'],
  //         nameKurdish: responseBody['data']['user']['name_kurdish'],
  //         email: responseBody['data']['user']['email'],
  //         type: responseBody['data']['user']['type'],
  //         isAvailable: responseBody['data']['user']['isAvailable'],
  //         isBlocked: responseBody['data']['user']['isBlocked'],
  //         gender: responseBody['data']['user']['gender'],
  //         languages: (responseBody['data']['user']['languages'] != null)
  //             ? List<String>.from(responseBody['data']['user']['languages'])
  //             : null,
  //         specialization: responseBody['data']['user']['specialization'] != null
  //             ? Specialization.fromJson(
  //                 responseBody['data']['user']['specialization'])
  //             : null,
  //         averageRating:
  //             responseBody['data']['user']['averageRating']?.toDouble(),
  //         ratings: (responseBody['data']['user']['ratings'] != null)
  //             ? List<Rating>.from(
  //                 responseBody['data']['user']['ratings']
  //                     .map((rating) => Rating.fromJson(rating)),
  //               )
  //             : null,
  //         accountStatus: responseBody['data']['user']['accountStatus'],
  //         availability: responseBody['data']['user']['availability'] != null
  //             ? Availability.fromJson(
  //                 responseBody['data']['user']['availability'])
  //             : null,
  //         createdAt: responseBody['data']['user']['createdAt'] != null
  //             ? DateTime.parse(responseBody['data']['user']['createdAt'])
  //             : null,
  //         updatedAt: responseBody['data']['user']['updatedAt'] != null
  //             ? DateTime.parse(responseBody['data']['user']['updatedAt'])
  //             : null,
  //         imageUrl: responseBody['data']['user']
  //             ['imageUrl'], // Ensure imageUrl is included
  //         deviceToken: responseBody['data']['user']
  //             ['deviceToken'], // Handle deviceToken
  //       );

  //       _usermodel = u; // Assign to _usermodel
  //       print(_usermodel!.nameEnglish.toString());
  //       notifyListeners(); // Notify listeners to update UI

  //       return CustomResponse(
  //         success: true,
  //         msg: responseBody['msg'],
  //         code: r.statusCode,
  //         data: responseBody,
  //       );
  //     } else {
  //       return CustomResponse(
  //         success: false,
  //         msg: responseBody['msg'] ?? 'Failed to get User',
  //         code: r.statusCode,
  //         data: {},
  //       );
  //     }
  //   } catch (e) {
  //     return CustomResponse(
  //         success: false, msg: "Failed to get User", code: 400);
  //   }
  // }

  Future<void> updateToken({
    required String deviceToken,
    required String id,
  }) async {
    try {
      Map<String, dynamic> data = {
        "deviceToken": deviceToken,
      };

      var r = await NetworkDataManger(client: http.Client()).putResponseFromUrl(
        "${baseAuthUrl}doctor/update-device-token/$id",
        data: data,
      );

      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;

      if (success) {
        print("Token Upated");
      } else {
        print("Token Upated Failed");
      }
    } catch (e) {
      print("Token Upated Failed with reason $e");
    }
  }

  Future<CustomResponse> forgetPassword({
    required String email,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {
        "email": email,
      };

      var r =
          await NetworkDataManger(client: http.Client()).postResponseFromUrl(
        "${baseAuthUrl}doctor/send-forgot-password-email",
        data: data,
      );
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
          msg: responseBody['msg'] ?? 'Failed to send link',
          code: r.statusCode,
          data: {},
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return CustomResponse(
          success: false, msg: "Failed to send link", code: 400);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
