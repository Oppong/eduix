import 'dart:convert';
import 'package:eduix/constant.dart';
import 'package:eduix/models/requests.dart';
import 'package:eduix/requests_model.dart';
import 'package:eduix/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AwaitingProvider extends ChangeNotifier {
  List<RequestsModel> awaitingProviderList = [];
  List<dynamic> reqs = [];

  allAwaitingApprovals() async {
    List<RequestsModel> newAwaitingApprovalsList = [];
    String token = await getToken();
    final response = await http.get(Uri.parse(pendingrequestsUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json as List<dynamic>;
      results.forEach((ele) {
        RequestsModel requestsModel = RequestsModel(
          user: ele['user'],
          id: ele['id'],
          requestSent: ele['request_sent'],
          createdAt: ele['created_At'],
          requestResponded: ele['request_responded'],
          requestContentSubject: ele['request_content_subject'],
          requestContent: ele['request_content'],
          requestStatus: ele['request_status'],
          responseContent: ele['response_content'],
        );
        newAwaitingApprovalsList.add(requestsModel);
      });

      awaitingProviderList = newAwaitingApprovalsList;
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  int get totalAwaitingApprovals {
    return awaitingProviderList.length;
  }
}

//
// else {
// throw Exception('Could not retrieve acknowledgement request');
// }
