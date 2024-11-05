import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:telemedicine_hub_doctor/common/constants/app_constants.dart';
import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
import 'package:telemedicine_hub_doctor/common/managers/network_manager.dart';
import 'package:telemedicine_hub_doctor/common/models/comment_model.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_count_model.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:http/http.dart' as http;
import 'package:telemedicine_hub_doctor/common/models/doctor_model.dart';
import 'package:telemedicine_hub_doctor/features/profile/provider/language_provider.dart';
import 'package:telemedicine_hub_doctor/features/profile/widget/loading_dialog.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoading = false;
  bool commentLoading = false;
  final int _completedTickets = 0;
  final int _pendingTickets = 0;
  TicketCountsModel? ticketCounts;
  int get completedTickets => _completedTickets;
  int get pendingTickets => _pendingTickets;

  Future<CustomResponse> getTickets({
    required String doctorId,
    required String status,
    int page = 1,
    String search = '', // Add search parameter

    int limit = 10,
  }) async {
    String currentLang =
        LanguageProvider.getCurrentLanguage; // Get language directly
    print(currentLang);
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();

    try {
      var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
        "${baseAuthUrl}ticket/get-all-tickets?doctorId=$doctorId&status=$status&page=$page&limit=$limit&search=$search",
        headers: {
          "Authorization": "Bearer $accessToken",
          "type": "doctor",
          "Language": currentLang,
        },
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
          'currentPage':
              responseBody['data']['pagination']['currentPage'] ?? page,
          'totalPages': responseBody['data']['pagination']['totalPages'] ?? 1,
          'totalTickets': tickets.length,
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

  Future<CustomResponse> getTicketCounts() async {
    String? accessToken = await LocalDataManager.getToken();
    String? doctorId = await LocalDataManager
        .getUserId(); // Assuming you have a method to get the doctor's ID
    print(doctorId);
    try {
      var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
        "${baseAuthUrl}ticket/get-all-tickets-count/$doctorId",
        headers: {"Authorization": "Bearer $accessToken", "type": "doctor"},
      );

      print("API Response Body: ${r.body}");
      var responseBody = jsonDecode(r.body);
      print("Decoded Response Body: $responseBody");

      bool success = responseBody['success'] ?? false;

      if (success) {
        ticketCounts =
            TicketCountsModel.fromJson(responseBody['data']['counts']);
        notifyListeners();

        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: ticketCounts,
        );
      } else {
        return CustomResponse(
          success: false,
          msg: responseBody['msg'] ?? 'Failed to fetch ticket counts',
          code: r.statusCode,
          data: null,
        );
      }
    } catch (e) {
      print("Error fetching ticket counts: $e");
      return CustomResponse(
        success: false,
        msg: "Failed to fetch ticket counts: $e",
        code: 400,
        data: null,
      );
    }
  }

  Future<CustomResponse> getTicketById({required String? ticketId}) async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();
    print(ticketId);
    String currentLang =
        LanguageProvider.getCurrentLanguage; // Get language directly
    try {
      var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
        "${baseAuthUrl}ticket/get-ticket-by-id/$ticketId",
        headers: {
          "Authorization": "Bearer $accessToken",
          "type": "doctor",
          "Language": currentLang,
        },
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
    String currentLang =
        LanguageProvider.getCurrentLanguage; // Get language directly
    try {
      var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
        "${baseAuthUrl}doctor/get-all-general-doctors",
        headers: {
          "Authorization": "Bearer $accessToken",
          "type": "doctor",
          "Language": currentLang
        },
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

  Future<CustomResponse> downloadFile(String url) async {
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var documentDirectory = await getApplicationDocumentsDirectory();

        String fileName = Uri.parse(url).pathSegments.last;

        File file = File('${documentDirectory.path}/$fileName');

        await file.writeAsBytes(response.bodyBytes);

        return CustomResponse(
          success: true,
          msg: "File downloaded successfully",
          code: response.statusCode,
          data: {'filePath': file.path},
        );
      } else {
        return CustomResponse(
          success: false,
          msg: "Failed to download file. Status code: ${response.statusCode}",
          code: response.statusCode,
        );
      }
    } catch (e) {
      print("Error: $e");
      return CustomResponse(
        success: false,
        msg: "Error occurred during file download: $e",
        code: 500, // General error code
      );
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

      log("Forward case :  ${r.body}");
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

  Future<CustomResponse> getComments({
    required String ticketid,
  }) async {
    String? accessToken = await LocalDataManager.getToken();
    isLoading = true;
    notifyListeners();

    try {
      var r = await NetworkDataManger(client: http.Client()).getResponseFromUrl(
        "${baseAuthUrl}comment/get-all-comments/$ticketid",
        headers: {"Authorization": "Bearer $accessToken", "type": "doctor"},
      );

      log(r.body);

      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;

      if (success) {
        List<CommentModel> commentList = responseBody['data']['comments']
            .map<CommentModel>((json) => CommentModel.fromJson(json))
            .toList();
        return CustomResponse(
          success: true,
          msg: responseBody['msg'],
          code: r.statusCode,
          data: commentList,
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

  Future<CustomResponse> createComment({
    required String doctorId,
    required String patientId,
    required String ticketId,
    required String message,
  }) async {
    String? accessToken = await LocalDataManager.getToken();
    commentLoading = true;
    notifyListeners();

    Map<String, dynamic> data = {
      "doctorId": doctorId,
      "patientId": patientId,
      "ticketId": ticketId,
      "message": message,
    };

    try {
      var r =
          await NetworkDataManger(client: http.Client()).postResponseFromUrl(
        "${baseAuthUrl}comment/create-comment",
        data: data,
        headers: {"Authorization": "Bearer $accessToken", "type": "doctor"},
      );

      print(r.body);
      var responseBody = jsonDecode(r.body);

      bool success = responseBody['success'] ?? false;

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
          msg: responseBody['msg'] ?? 'Failed to fetch diseases',
          code: r.statusCode,
          data: {},
        );
      }
    } catch (e) {
      commentLoading = false;
      notifyListeners();
      return CustomResponse(
          success: false, msg: "Failed to fetch diseases", code: 400);
    } finally {
      commentLoading = false;
      notifyListeners();
    }
  }
}
