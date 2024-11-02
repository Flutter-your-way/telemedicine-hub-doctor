// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:telemedicine_hub_doctor/common/constants/app_constants.dart';
import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';

class NetworkDataManger {
  final http.Client client;

  NetworkDataManger({required this.client});

  Future<http.Response> getResponseFromUrl(
    String url, {
    Map<String, String>? headers,
  }) async {
    return await _handleRequest(() async {
      return await client.get(Uri.parse(url), headers: headers);
    });
  }

  Future<http.Response> postResponseFromUrl(String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    return await _handleRequest(() async {
      headers = headers ?? {};
      headers!['Content-Type'] = 'application/json';
      return await client.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: headers,
      );
    });
  }

  Future<http.Response> putResponseFromUrl(
    String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    return await _handleRequest(() async {
      headers = headers ?? {};
      headers!['Content-Type'] = 'application/json';
      return await client.put(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: headers,
      );
    });
  }

  Future<http.Response> deleteResponseFromUrl(String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    return await _handleRequest(() async {
      headers = headers ?? {};
      headers!['Content-Type'] = 'application/json';
      return await client.delete(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: headers,
      );
    });
  }

  Future<http.Response> _handleRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    http.Response response = await requestFn();

    if (response.statusCode == 401) {
      // Token might have expired, try to refresh it
      CustomResponse refreshResponse = await _refreshToken();
      if (!refreshResponse.success) {
        // Retry the original request with new token
        response = await requestFn();
      } else {
        Fluttertoast.showToast(
            msg: "Authentication failed. Please login again.");
      }
    }

    if (response.statusCode >= 400) {
      // Fluttertoast.showToast(msg: "Failed to make network call");
    }

    return response;
  }

  Future<CustomResponse> _refreshToken() async {
    try {
      String? refreshToken = await LocalDataManager.getRefreshToken();
      if (refreshToken == null) {
        return CustomResponse(
          success: true,
          msg: 'No refresh token available',
          code: 401,
        );
      }

      var r =
          await NetworkDataManger(client: http.Client()).postResponseFromUrl(
        "${baseAuthUrl}doctor/refresh-access-token",
        data: {"refreshToken": refreshToken},
        // headers: {
        //   "Content-Type": "application/json",
        //   "Connection": "keep-alive",
        //   "Accept-Encoding": "gzip, deflate, br",
        //   "Accept": "*/*",
        //   "User-Agent": "PostmanRuntime/7.40.0",
        //   "Authorization": "Bearer ${accessToken.toString()}",
        // },
      );

      if (r.statusCode == 200) {
        String newToken = jsonDecode(r.body)['accessToken'];
        await LocalDataManager.storeToken(newToken);
        return CustomResponse(
          success: false,
          msg: 'Token refreshed successfully',
          code: r.statusCode,
          data: r.body,
        );
      } else {
        return CustomResponse(
          success: true,
          msg: 'Failed to refresh token',
          code: r.statusCode,
          data: r.body,
        );
      }
    } catch (e) {
      return CustomResponse(
        success: true,
        msg: 'Failed to refresh token',
        code: 500,
      );
    }
  }
}
