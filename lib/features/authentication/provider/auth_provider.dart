import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:telemedicine_hub_doctor/common/constants/app_constants.dart';
import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
import 'package:telemedicine_hub_doctor/common/managers/network_manager.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';
import 'package:telemedicine_hub_doctor/common/models/user_model.dart';
import 'package:telemedicine_hub_doctor/features/splash/screen/splash_screen.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  late String _authToken;
  late String _refreshToken;
  UserModel? _usermodel;

  set authToken(String _) {
    _authToken = _;
    notifyListeners();
  }

  String get authToken => _authToken;
  String get refreshToken => _refreshToken;
  UserModel? get usermodel => _usermodel;

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
      log(data.toString());
      var r =
          await NetworkDataManger(client: http.Client()).postResponseFromUrl(
        "${baseAuthUrl}login-doctor",
        data: data,
      );
      log("Response: ${r.body}");
      log(r.statusCode.toString());

      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;
      log(success.toString());

      if (success) {
        String token = responseBody['data']['accessToken'];
        String refreshToken = responseBody['data']['accessToken'];
        await LocalDataManager.storeToken(token);
        await LocalDataManager.storeRefreshToken(refreshToken);

        _authToken = token;

        // await getUser(accessToken: _authToken);

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
          _usermodel = null;
          notifyListeners();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
            (route) => false,
          );
        },
      );
      return CustomResponse(
        msg: "Logged out Successfully !",
        code: 200,
        data: "Logged out successfully",
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
}
