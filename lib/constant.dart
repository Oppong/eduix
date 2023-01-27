import 'package:flutter/material.dart';

const kMainColor = Color(0xff212529);
const kSubColor = Color(0xffEC7405);

const baseUrl = 'https://eduapi.fastroidigital.com/api';
// const baseUrl = 'http://192.168.43.87:8000/api';
const loginUrl = baseUrl + '/login';
const requestapprovalsUrl = baseUrl + '/requestapprovals';
const pendingrequestsUrl = baseUrl + '/pendingrequests';
const approvedrequestsUrl = baseUrl + '/approvedrequests';
const rejectedrequestsUrl = baseUrl + '/rejectedrequests';
const allrequestsUrl = baseUrl + '/allrequests';
const deleteRequestsUrl = baseUrl + '/requests';
const updateRequestsUrl = baseUrl + '/requests';
const showSingleRequestUrl = baseUrl + '/requests';
const userUrl = baseUrl + '/user';
const logoutUrl = baseUrl + '/logout';

//errors
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const SomethingWentWrong = 'Something went wrong, please try again ';
