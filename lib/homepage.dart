import 'dart:async';
import 'dart:convert';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:eduix/awaiting_details.dart';
import 'package:eduix/awaiting_provider.dart';
import 'package:eduix/constant.dart';
import 'package:eduix/drawerlistItem.dart';
import 'package:eduix/models/api_response.dart';
import 'package:eduix/rejection_history.dart';
import 'package:eduix/services/user_service.dart';
import 'package:eduix/signin.dart';
import 'package:flutter/material.dart';
import 'package:eduix/awaiting_approvals.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'approval_history.dart';
import 'models/requests.dart';
import 'models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = 'homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequestPendingData();
    getUser();

    Timer.periodic(Duration(seconds: 1), (timer) {
      Provider.of<AwaitingProvider>(context, listen: false)
          .allAwaitingApprovals();
      // setState(() {
      //   testval++;
      // });
      print('timer for provider ${timer.tick}');
    });
  }

  var dated = DateFormat.yMMMMEEEEd();
  List<dynamic> reqs = [];

  void getRequestPendingData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(pendingrequestsUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json as List<dynamic>;
      final trans = results.map((e) => Requests.fromJson(e)).toList();

      setState(() {
        reqs = trans;
      });
    } else {
      throw Exception('Could not retrieve acknowledgement request');
    }
  }

  //getting a user email
  User? userEmail;
  User? userName;

  getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        userEmail = response.data as User;
        userName = response.data as User;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AwaitingProvider awaitingProvider = Provider.of(context);
    awaitingProvider.allAwaitingApprovals();

    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ConnectivityWidgetWrapper(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              // color: kMainColor,
              width: double.infinity,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      color: kMainColor,
                      width: 1000,
                      height: 210,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Text(
                      userEmail?.name == null ? '' : 'Hi ${userEmail!.name!}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 170,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kSubColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            // reqs == null ? '' : reqs.length.toString(),
                            Provider.of<AwaitingProvider>(context)
                                .totalAwaitingApprovals
                                .toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            'Awaiting Approval',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Consumer<AwaitingProvider>(
              builder: (context, reqss, child) {
                return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: reqss.awaitingProviderList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AwaitingDetails(
                                  id: reqss.awaitingProviderList[index].id!,
                                  subject: reqss.awaitingProviderList[index]
                                      .requestContentSubject,
                                  requestContent: reqss
                                      .awaitingProviderList[index]
                                      .requestContent!,
                                  requestSent: reqss
                                      .awaitingProviderList[index].requestSent!,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reqss.awaitingProviderList[index]
                                    .requestContentSubject!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                reqss.awaitingProviderList[index]
                                    .requestContent!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Gilroy',
                                  color: Colors.grey.shade600,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    dated.format(
                                      DateTime.parse(reqss
                                          .awaitingProviderList[index]
                                          .requestSent
                                          .toString()),
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Gilroy',
                                      color: Colors.grey.shade800,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                  Spacer(),
                                  Text(
                                    "Approve/Reject",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Gilroy',
                                      color: kSubColor,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: kMainColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, left: 18),
                  child: Text(
                    userEmail?.name == null ? '' : userEmail!.name!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    userEmail?.email == null ? '' : userEmail!.email!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DrawerListItem(
            label: 'Awaiting Approvals',
            icons: Icons.ac_unit_sharp,
            onPress: () {
              Navigator.pushNamed(context, AwaitingApprovals.id);
            },
          ),
          DrawerListItem(
            label: 'Approvals History',
            icons: Icons.explore,
            onPress: () {
              Navigator.pushNamed(context, ApprovalHistoryPage.id);
            },
          ),
          DrawerListItem(
            label: 'Rejection History',
            icons: Icons.bolt,
            onPress: () {
              Navigator.pushNamed(context, RejectionHistory.id);
            },
          ),
          DrawerListItem(
            label: 'Logout',
            icons: Icons.exit_to_app,
            onPress: () async {
              logout().then((value) => {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        SignInPage.id, (route) => false)
                  });
            },
          )
        ],
      ),
    );
  }
}

// Timer.periodic(Duration(seconds: 8), (timer) {
//   Provider.of<AwaitingProvider>(context, listen: false)
//       .allAwaitingApprovals();
//   print('timer for provider ${timer.tick}');
// });
