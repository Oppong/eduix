import 'dart:convert';
import 'package:eduix/models/requests.dart';
import 'package:eduix/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'awaiting_details.dart';
import 'awaiting_provider.dart';
import 'constant.dart';
import 'package:http/http.dart' as http;

class AwaitingApprovals extends StatefulWidget {
  const AwaitingApprovals({Key? key}) : super(key: key);
  static const String id = 'awaiting approvals';

  @override
  State<AwaitingApprovals> createState() => _AwaitingApprovalsState();
}

class _AwaitingApprovalsState extends State<AwaitingApprovals> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequestPendingData();
  }

  var dated = DateFormat.yMMMMEEEEd();
  List<dynamic> reqs = [];
  // List<dynamic> filteredList = [];
  bool isLoaded = false;

  void getRequestPendingData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(pendingrequestsUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An Error Occurred whiles fetching request')));
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json as List<dynamic>;
      final trans = results.map((e) => Requests.fromJson(e)).toList();

      setState(() {
        reqs = trans;
        reqs != null ? isLoaded = true : '';
      });
    } else {
      throw Exception('Could not retrieve acknowledgement request');
    }
  }

  @override
  Widget build(BuildContext context) {
    AwaitingProvider awaitingProvider = Provider.of(context);
    awaitingProvider.allAwaitingApprovals();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'Awaiting Approvals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          shrinkWrap: true,
          children: [
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
                                      .requestContentSubject!,
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
}

/*

 */

/*
Visibility(
            visible: isLoaded,
            replacement: Center(child: CircularProgressIndicator()),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reqs.length,
                  itemBuilder: (context, index) {
                    final reqss = reqs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AwaitingDetails(
                                id: reqss.id!,
                                subject: reqss.requestContentSubject,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reqss.requestContentSubject!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              reqss.requestContent!,
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
                                    DateTime.parse(
                                        reqss.requestSent.toString()),
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
                                  "Read more...",
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
                  }),
            ),
          ),
 */
