import 'dart:convert';

import 'package:eduix/constant.dart';
import 'package:eduix/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

//Login
Future<dynamic> login({required String email}) async {
  try {
    final response = await http.post(Uri.parse(loginUrl),
        headers: {'Accept': 'application/json'}, body: {'email': email});

    print('response login ${response.body}');
    if (response.statusCode == 200) {
      dynamic userInfo = jsonDecode(response.body);
      return userInfo;
    } else {
      if (response.statusCode == 403) {
        String message = jsonDecode(response.body)['message'];
        dynamic messageData = {'message': message, 'statusCode': 403};
        return messageData;
      } else {
        String message = jsonDecode(response.body)['message'];
        dynamic messageData = {'message': message};
        return messageData;
      }
    }
  } catch (e) {
    dynamic messageData = {
      'message': "Failed to load from server",
      'statusCode': 500
    };
    return messageData;
  }
}

//getting user information
Future<dynamic> getUserDetail() async {
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      dynamic userinfo = jsonDecode(response.body);
      return userinfo;
    } else {}
  } catch (e) {
    dynamic messageData = {
      'message': "Failed to load from server",
      'statusCode': 500
    };
    return messageData;
  }
}

//get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

//get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('id') ?? 0;
}

//logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

