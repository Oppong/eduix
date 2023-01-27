// To parse this JSON data, do
//
//     final requests = requestsFromJson(jsonString);

import 'dart:convert';

// List<Requests> requestsFromJson(String str) =>
//     List<Requests>.from(json.decode(str).map((x) => Requests.fromJson(x)));
//
// String requestsToJson(List<Requests> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestsModel {
  RequestsModel({
    this.id,
    this.user,
    this.requestSent,
    this.requestContent,
    this.requestContentSubject,
    this.requestResponded,
    this.responseContent,
    this.requestStatus,
    this.createdAt,
    this.updatedAt,
    this.adminEmail,
  });

  int? id;
  String? user;
  dynamic requestSent;
  String? requestContent;
  String? requestContentSubject;
  dynamic requestResponded;
  String? responseContent;
  String? requestStatus;
  String? adminEmail;
  dynamic createdAt;
  DateTime? updatedAt;
}
