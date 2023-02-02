import 'dart:convert';

import 'package:eduix/constant.dart';
import 'package:eduix/models/api_response.dart';
import 'package:eduix/models/requests.dart';
import 'package:eduix/services/user_service.dart';
import 'package:http/http.dart' as http;

//get all acknowledgement request
Future<ApiResponse> getAcknowledgement() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(pendingrequestsUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['pending']
            .map((p) => Requests.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = SomethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// delete a single acknowledgement request
Future<dynamic> updateAcknowledgement(
    {required int reqid,
    required String requestStatus,
    required String responseContent}) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response =
        await http.patch(Uri.parse('$updateRequestsUrl/$reqid'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'request_status': requestStatus,
      'response_content': responseContent,
    });

    print(' STATUS ${response.statusCode}');
    print('RESPONSE API ${jsonDecode(response.body)} ');
    switch (response.statusCode) {
      case 200:
<<<<<<< HEAD
        apiResponse.data = jsonDecode(response.body)['message']
            .map((p) => Requests.fromJson(p))
            .toList();

=======
        String message = jsonDecode(response.body)['message'];
        dynamic messageData = {
          'message': message,
          'statusCode': 200
        };
        return messageData;
>>>>>>> 80cf77152a716f0522fd1f5c5b6029e2893ba09e
        break;
      case 403:

        dynamic messageData = {
          'message': "Failed",
          'statusCode': 403
        };
        return messageData;
        break;
      case 401:
        apiResponse.error = unauthorized;
        dynamic messageData = {
          'message': "Failed",
          'statusCode': 401
        };
        return messageData;
        break;
      default:
        apiResponse.error = SomethingWentWrong;
        dynamic messageData = {
          'message': "Failed",
          'statusCode': 404
        };
        return messageData;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
    print(' CATCH ERROR $e');
    dynamic messageData = {
      'message': "Failed",
      'statusCode': 500
    };
    return messageData;
  }
}

// delete a single acknowledgement request
Future<ApiResponse> deleteAcknowledgement(int regid) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$deleteRequestsUrl/$regid'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message']
            .map((p) => Requests.fromJson(p))
            .toList();
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = SomethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}
