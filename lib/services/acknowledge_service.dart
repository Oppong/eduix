import 'dart:convert';

import 'package:eduix/constant.dart';
import 'package:eduix/models/api_response.dart';
import 'package:eduix/models/requests.dart';
import 'package:eduix/services/user_service.dart';
import 'package:http/http.dart' as http;

// update a single acknowledgement request
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

    if (response.statusCode == 200) {
      dynamic message = jsonDecode(response.body);
      return message;
    } else {
      if (response.statusCode == 403) {
        String message = jsonDecode(response.body)['message'];
        dynamic messageData = {'message': message, 'statusCode': 403};
        return messageData;
      }
    }
  } catch (e) {
    print(' CATCH ERROR $e');
    dynamic messageData = {
      'message': "Failed to load from server",
      'statusCode': 500
    };
    return messageData;
  }
}

// delete a single acknowledgement request
Future<dynamic> deleteAcknowledgement(int regid) async {
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$deleteRequestsUrl/$regid'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      dynamic message = jsonDecode(response.body);
      return message;
    } else {
      if (response.statusCode == 403) {
        String message = jsonDecode(response.body)['message'];
        dynamic messageData = {'message': message, 'statusCode': 403};
        return messageData;
      }
    }
  } catch (e) {
    print(' CATCH ERROR $e');
    dynamic messageData = {
      'message': "Failed to load from server",
      'statusCode': 500
    };
    return messageData;
  }
}
