// To parse this JSON data, do
//
//     final requests = requestsFromJson(jsonString);

import 'dart:convert';

// List<Requests> requestsFromJson(String str) =>
//     List<Requests>.from(json.decode(str).map((x) => Requests.fromJson(x)));
//
// String requestsToJson(List<Requests> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Requests {
  Requests({
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
  DateTime? requestSent;
  String? requestContent;
  String? requestContentSubject;
  DateTime? requestResponded;
  String? responseContent;
  String? requestStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? adminEmail;

  factory Requests.fromJson(Map<String, dynamic> json) => Requests(
        id: json["id"],
        user: json["user"],
        adminEmail: json["admin_email"],
        requestSent: json["request_sent"] == null
            ? null
            : DateTime.parse(json["request_sent"]),
        requestContent: json["request_content"],
        requestContentSubject: json["request_content_subject"],
        requestResponded: json["request_responded"] == null
            ? null
            : DateTime.parse(json["request_responded"]),
        responseContent: json["response_content"],
        requestStatus: json["request_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "admin_email": adminEmail,
        "request_sent": requestSent?.toIso8601String(),
        "request_content": requestContent,
        "request_content_subject": requestContentSubject,
        "request_responded": requestResponded?.toIso8601String(),
        "response_content": responseContent,
        "request_status": requestStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
