import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:telemedicine_hub_doctor/common/constants/app_constants.dart';
import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
import 'package:telemedicine_hub_doctor/common/managers/network_manager.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:http/http.dart' as http;
import 'package:telemedicine_hub_doctor/common/models/doctor_model.dart';
import 'package:telemedicine_hub_doctor/features/profile/widget/loading_dialog.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  final int _completedTickets = 0;
  final int _pendingTickets = 0;

  int get completedTickets => _completedTickets;
  int get pendingTickets => _pendingTickets;

  Future<CustomResponse> getTickets({
    required String doctorId,
    required String status,
    int page = 1,
    int limit = 10,
  }) async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();

    try {
      var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
        "${baseAuthUrl}ticket/get-all-tickets?doctorId=$doctorId&status=$status&page=$page&limit=$limit",
        headers: {"Authorization": "Bearer $accessToken", "type": "doctor"},
      );

      log(r.body);
      var responseBody = jsonDecode(r.body);
      print(responseBody);

      bool success = responseBody['success'] ?? false;

      if (success) {
        List<TicketModel> tickets = (responseBody['data']['tickets'] as List)
            .map<TicketModel>((json) => TicketModel.fromJson(json))
            .toList();

        // Extract pagination information
        var paginationInfo = {
          'currentPage': responseBody['data']['currentPage'] ?? page,
          'totalPages': responseBody['data']['totalPages'] ?? 1,
          'totalTickets':
              responseBody['data']['totalTickets'] ?? tickets.length,
        };

        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: {
            'tickets': tickets,
            'pagination': paginationInfo,
          },
        );
      } else {
        return CustomResponse(
          success: false,
          msg: responseBody['msg'] ?? 'Failed to fetch tickets',
          code: r.statusCode,
          data: {},
        );
      }
    } catch (e) {
      print('Error fetching tickets: $e');
      return CustomResponse(
        success: false,
        msg: "Failed to fetch tickets: $e",
        code: 400,
        data: {},
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<CustomResponse> getTicketById({required String? ticketId}) async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();
    print(ticketId);
    try {
      var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
        "${baseAuthUrl}ticket/get-ticket-by-id/$ticketId",
        headers: {"Authorization": "Bearer $accessToken", "type": "doctor"},
      );
      log(r.body);
      var responseBody = jsonDecode(r.body);
      print(responseBody);

      bool success = responseBody['success'] ?? false;

      if (success) {
        TicketModel ticket =
            TicketModel.fromJson(responseBody['data']['ticket']);
        print('Parsed Ticket: $ticket'); // For debugging
        print(
            'Questions and Answers: ${ticket.questionsAndAnswers}'); // For debugging
        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: ticket,
        );
      } else {
        return CustomResponse(
          success: false,
          msg: responseBody['msg'] ?? 'Failed to fetch ticket',
          code: r.statusCode,
          data: {},
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return CustomResponse(
          success: false, msg: "Failed to fetch ticket", code: 400);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<CustomResponse> getAllDoctors() async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();

    try {
      var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
        "${baseAuthUrl}doctor/get-all-general-doctors",
        headers: {"Authorization": "Bearer $accessToken", "type": "doctor"},
      );

      log(r.body);
      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;

      if (success) {
        List<DoctorModel> doctorlist = responseBody['data']['doctors']
            .map<DoctorModel>((json) => DoctorModel.fromJson(json))
            .toList();

        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: doctorlist,
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

  Future<CustomResponse> MarkAsComplete({
    required String id,
    required String note,
    File? file,
    String? directoryType,
    required BuildContext context,
  }) async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();
    LoadingDialog.showLoadingDialog(context);

    try {
      var uri = Uri.parse("${baseAuthUrl}ticket/mark-as-complete/$id");
      var request = http.MultipartRequest("PUT", uri)
        ..fields['note'] = note
        ..headers['type'] = 'doctor'
        ..headers['Authorization'] = 'Bearer $accessToken';

      if (directoryType != null) {
        request.fields['directoryType'] = directoryType;
      }

      if (file != null) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile('files', stream, length,
            filename: 'prescriptionFor$id.${file.path.split('.').last}');
        request.files.add(multipartFile);
      }

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
          data: resBody['data'],
        );
      } else {
        return CustomResponse(
          success: false,
          msg: resBody['msg'] ?? 'Failed to mark as complete',
          code: statusCode,
          data: {},
        );
      }
    } catch (e, stacktrace) {
      print("Error in MarkAsComplete: $e");
      print("Stacktrace: $stacktrace");
      return CustomResponse(
          success: false, msg: "Failed to mark as complete", code: 400);
    } finally {
      isLoading = false;
      notifyListeners();
      LoadingDialog.hideLoadingDialog(context);
    }
  }

  Future<CustomResponse> forwardTicket({
    required String newDoctorId,
    required String note,
    required String id,
  }) async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();

    try {
      var r = await NetworkDataManger(client: http.Client()).putResponseFromUrl(
        "${baseAuthUrl}ticket/forward-ticket/$id",
        data: {"newDoctorId": newDoctorId, "note": note},
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
          data: responseBody['data'],
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

  Future<CustomResponse> uploadPrescriptions({
    required File file,
    required BuildContext context,
    required String ticketID,
    required String fileType,
  }) async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();
    LoadingDialog.showLoadingDialog(context);

    try {
      var uri =
          Uri.parse("${baseAuthUrl}ticket/upload-prescriptions/$ticketID");
      var request = http.MultipartRequest("PUT", uri)
        ..fields['directoryType'] = "prescriptions"
        ..headers['type'] = 'doctor'
        ..headers['Authorization'] = 'Bearer $accessToken';

      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile('files', stream, length,
          filename: 'prescriptionsFor$ticketID.jpg');
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
    } catch (e, stacktrace) {
      return CustomResponse(success: false, msg: "Failed to Upload", code: 400);
    } finally {
      isLoading = false;
      notifyListeners();
      LoadingDialog.hideLoadingDialog(context);
    }
  }
}
