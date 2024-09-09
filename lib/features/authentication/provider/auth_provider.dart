import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:telemedicine_hub_doctor/common/constants/app_constants.dart';
import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
import 'package:telemedicine_hub_doctor/common/managers/network_manager.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';
import 'package:telemedicine_hub_doctor/common/models/user_model.dart';

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

  Future<CustomResponse> sendEmailOTP({
    required String identifier,
    required String email,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {
        "identifier": identifier,
        "email": email,
      };
      log(data.toString());

      var r =
          await NetworkDataManger(client: http.Client()).postResponseFromUrl(
        "${baseAuthUrl}auth/request-otp",
        data: data,
      );

      log("Response: ${r.body}");
      log(r.statusCode.toString());

      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;
      log(success.toString());

      if (success) {
        log("succeesss: ${r.body}");
        String hashedOTP = responseBody['data']['hashedOTP']?.toString() ?? '';
        String otpExpiration =
            responseBody['data']['otpExpiration']?.toString() ?? '';

        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: {
            'hashedOTP': hashedOTP,
            'otpExpiration': otpExpiration,
          },
        );
      } else {
        log("CustomResponse: ${r.body}");

        return CustomResponse(
          success: false,
          msg: responseBody['msg'] ?? 'Failed to send OTP',
          code: r.statusCode,
          data: {},
        );
      }
    } catch (e) {
      log("catch: }");
      isLoading = false;
      notifyListeners();
      return CustomResponse(success: false, msg: "${e.toString()}", code: 400);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<CustomResponse> verifyOTP({
    required String receivedOTP,
    required String hashedOTP,
    required String otpExpiration,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {
        "receivedOTP": receivedOTP,
        "hashedOTP": hashedOTP,
        "otpExpiration": otpExpiration,
      };
      log(data.toString());

      var r =
          await NetworkDataManger(client: http.Client()).postResponseFromUrl(
        "${baseAuthUrl}auth/verify-otp",
        data: data,
      );

      log("msg error ${r.body}");
      log(r.statusCode.toString());

      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;
      log(success.toString());

      if (success) {
        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: {},
        );
      } else {
        return CustomResponse(
          success: false,
          msg: responseBody['msg'] ?? 'Failed to verify OTP',
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

  Future<CustomResponse> register({
    required String email,
    required String fullName,
    required String password,
    required String identifier,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {
        "email": email,
        "fullName": fullName,
        "password": password,
        "identifier": identifier
      };
      log(data.toString());
      var r =
          await NetworkDataManger(client: http.Client()).postResponseFromUrl(
        "${baseAuthUrl}auth/register-user",
        data: data,
      );
      log("Response: ${r.body}");
      log(r.statusCode.toString());

      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;
      log(success.toString());

      if (success) {
        String hashedOTP = responseBody['data']['hashedOTP']?.toString() ?? '';
        String otpExpiration =
            responseBody['data']['otpExpiration']?.toString() ?? '';

        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: {
            'hashedOTP': hashedOTP,
            'otpExpiration': otpExpiration,
          },
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
        "${baseAuthUrl}auth/login-user/",
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
}
