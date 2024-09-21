import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:telemedicine_hub_doctor/common/constants/app_constants.dart';
import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
import 'package:telemedicine_hub_doctor/common/managers/network_manager.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:http/http.dart' as http;

class AppointmentProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<CustomResponse> getTickets({
    required String doctorId,
  }) async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();

    try {
      var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
        "${baseAuthUrl}ticket/get-all-tickets?doctorId=$doctorId",
        headers: {"Authorization": "Bearer $accessToken", "type": "doctor"},
      );

      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;

      if (success) {
        List<TicketModel> tickets = responseBody['data']['tickets']
            .map<TicketModel>((json) => TicketModel.fromJson(json))
            .toList();

        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: tickets,
        );
      } else {
        return CustomResponse(
          success: false,
          msg: responseBody['msg'] ?? 'Failed to fetch diseases',
          code: r.statusCode,
          data: {},
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return CustomResponse(
          success: false, msg: "Failed to fetch diseases", code: 400);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
