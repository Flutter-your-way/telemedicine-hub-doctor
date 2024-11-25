import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:telemedicine_hub_doctor/common/constants/app_constants.dart';
import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';

/// The `NetworkDataManager` class in Dart handles HTTP requests, including GET, POST, PUT, and DELETE
/// methods, with token refresh functionality to manage authentication errors.
class NetworkDataManger {
  final http.Client client;
  bool _isRefreshing = false; // Flag to prevent multiple refresh attempts

  NetworkDataManger({required this.client});

  Future<http.Response> getResponseFromUrl(
    String url, {
    Map<String, String>? headers,
  }) async {
    return await _handleRequest(() async {
      headers = headers ?? {};
      headers!['Authorization'] = 'Bearer ${await LocalDataManager.getToken()}';
      return await client.get(Uri.parse(url), headers: headers);
    });
  }

  Future<http.Response> postResponseFromUrl(String url,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    return await _handleRequest(() async {
      headers = headers ?? {};
      headers!['Authorization'] = 'Bearer ${await LocalDataManager.getToken()}';
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
      headers!['Authorization'] = 'Bearer ${await LocalDataManager.getToken()}';
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
      headers!['Authorization'] = 'Bearer ${await LocalDataManager.getToken()}';
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
    try {
      http.Response response = await requestFn();

      if (response.statusCode == 401 && !_isRefreshing) {
        CustomResponse refreshResponse = await _refreshToken();

        if (refreshResponse.success) {
          // Retry the request if refresh succeeds
          log("Retrying original request after token refresh...");
          response = await requestFn();
        } else {
          Fluttertoast.showToast(
              msg: "Authentication failed. Please login again.");
        }
      }

      if (response.statusCode >= 400) {
        log("API Error: Status ${response.statusCode}, Body: ${response.body}");
      }

      return response;
    } catch (e) {
      log("Network Error: $e");
      return http.Response('{"error": "Network error occurred"}', 500);
    }
  }

  /// The `_refreshToken` function handles the process of refreshing an access token using a refresh
  /// token in Dart.
  ///
  /// Returns:
  ///   The `_refreshToken` function returns a `Future<CustomResponse>`.
  Future<CustomResponse> _refreshToken() async {
    if (_isRefreshing) {
      return CustomResponse(
        success: false,
        msg: 'Token refresh already in progress',
        code: 429,
      );
    }

    try {
      _isRefreshing = true;
      log("Starting token refresh");

      String? refreshToken = await LocalDataManager.getRefreshToken();

      String? token = await LocalDataManager.getToken();
      if (refreshToken == null) {
        log("No refresh token available");
        return CustomResponse(
          success: false,
          msg: 'No refresh token available',
          code: 401,
        );
      }

      print(token);
      final refreshClient = http.Client();
      try {
        final response = await refreshClient.post(
          Uri.parse("${baseAuthUrl}doctor/refresh-access-token"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"refreshToken": refreshToken}),
        );

        log("Refresh token response: ${response.body}");

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          String newToken = responseData['data']['accessToken'];
          String newRefreshToken = responseData['data']['refreshToken'];

          await LocalDataManager.storeToken(newToken);
          await LocalDataManager.storeRefreshToken(newRefreshToken);

          return CustomResponse(
            success: true,
            msg: 'Token refreshed successfully',
            code: response.statusCode,
            data: response.body,
          );
        } else {
          log("Failed to refresh token: ${response.body}");
          return CustomResponse(
            success: false,
            msg: 'Failed to refresh token',
            code: response.statusCode,
            data: response.body,
          );
        }
      } finally {
        refreshClient.close();
      }
    } catch (e) {
      log("Error during token refresh: $e");
      return CustomResponse(
        success: false,
        msg: 'Failed to refresh token: $e',
        code: 500,
      );
    } finally {
      _isRefreshing = false;
    }
  }
}

// // ignore_for_file: depend_on_referenced_packages

// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:telemedicine_hub_doctor/common/constants/app_constants.dart';
// import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
// import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';

// class NetworkDataManger {
//   final http.Client client;

//   NetworkDataManger({required this.client});

//   Future<http.Response> getResponseFromUrl(
//     String url, {
//     Map<String, String>? headers,
//   }) async {
//     return await _handleRequest(() async {
//       return await client.get(Uri.parse(url), headers: headers);
//     });
//   }

//   Future<http.Response> postResponseFromUrl(String url,
//       {Map<String, dynamic>? data, Map<String, String>? headers}) async {
//     return await _handleRequest(() async {
//       headers = headers ?? {};
//       headers!['Content-Type'] = 'application/json';
//       return await client.post(
//         Uri.parse(url),
//         body: jsonEncode(data),
//         headers: headers,
//       );
//     });
//   }

//   Future<http.Response> putResponseFromUrl(
//     String url, {
//     Map<String, dynamic>? data,
//     Map<String, String>? headers,
//   }) async {
//     return await _handleRequest(() async {
//       headers = headers ?? {};
//       headers!['Content-Type'] = 'application/json';
//       return await client.put(
//         Uri.parse(url),
//         body: jsonEncode(data),
//         headers: headers,
//       );
//     });
//   }

//   Future<http.Response> deleteResponseFromUrl(String url,
//       {Map<String, dynamic>? data, Map<String, String>? headers}) async {
//     return await _handleRequest(() async {
//       headers = headers ?? {};
//       headers!['Content-Type'] = 'application/json';
//       return await client.delete(
//         Uri.parse(url),
//         body: jsonEncode(data),
//         headers: headers,
//       );
//     });
//   }

//   Future<http.Response> _handleRequest(
//     Future<http.Response> Function() requestFn,
//   ) async {
//     http.Response response = await requestFn();

//     if (response.statusCode == 401) {
//       // Token might have expired, try to refresh it
//       CustomResponse refreshResponse = await _refreshToken();
//       if (!refreshResponse.success) {
//         // Retry the original request with new token
//         response = await requestFn();
//       } else {
//         Fluttertoast.showToast(
//             msg: "Authentication failed. Please login again.");
//       }
//     }

//     if (response.statusCode >= 400) {
//       // Fluttertoast.showToast(msg: "Failed to make network call");
//     }

//     return response;
//   }

//   Future<CustomResponse> _refreshToken() async {
//     try {
//       String? refreshToken = await LocalDataManager.getRefreshToken();
//       if (refreshToken == null) {
//         return CustomResponse(
//           success: true,
//           msg: 'No refresh token available',
//           code: 401,
//         );
//       }

// var r =
//     await NetworkDataManger(client: http.Client()).postResponseFromUrl(
//   "${baseAuthUrl}doctor/refresh-access-token",
//   data: {"refreshToken": refreshToken.toString()},
// );

//       if (r.statusCode == 200) {
//         String newToken = jsonDecode(r.body)['data']['accessToken'];
//         String refreshToken = jsonDecode(r.body)['data']['refreshToken'];
//         await LocalDataManager.storeToken(newToken);
//         await LocalDataManager.storeRefreshToken(refreshToken);
//         return CustomResponse(
//           success: false,
//           msg: 'Token refreshed successfully',
//           code: r.statusCode,
//           data: r.body,
//         );
//       } else {
//         return CustomResponse(
//           success: true,
//           msg: 'Failed to refresh token',
//           code: r.statusCode,
//           data: r.body,
//         );
//       }
//     } catch (e) {
//       return CustomResponse(
//         success: true,
//         msg: 'Failed to refresh token',
//         code: 500,
//       );
//     }
//   }
// }
