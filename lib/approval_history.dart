import 'package:eduix/request_details.dart';
import 'package:eduix/services/acknowledge_service.dart';
import 'package:eduix/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'constant.dart';
import 'dart:convert';

import 'models/api_response.dart';
import 'models/requests.dart';

class ApprovalHistoryPage extends StatefulWidget {
  const ApprovalHistoryPage({Key? key}) : super(key: key);
  static const String id = 'approval history page';

  @override
  State<ApprovalHistoryPage> createState() => _ApprovalHistoryPageState();
}

class _ApprovalHistoryPageState extends State<ApprovalHistoryPage> {
  var dated = DateFormat.yMMMMEEEEd();
  var newDate = DateFormat.yMMMMd();

  List<dynamic> reqs = [];
  List<dynamic> filteredList = [];
  bool isLoaded = false;

  void getRequestApprovedData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(approvedrequestsUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json as List<dynamic>;
      final trans = results.map((e) => Requests.fromJson(e)).toList();
      setState(() {
        reqs = trans;
        filteredList = reqs;
        filteredList != null ? isLoaded = true : '';
      });
    } else {
      throw Exception('Could not retrieve acknowledgement request');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequestApprovedData();
  }

  // DateTime initialDate = DateTime.now();
  var testDay = DateFormat.yMMMd().format(DateTime.now());
  var initialDay = DateFormat.yMMMd().format(DateTime.now());
  var endDay = DateFormat.yMMMd().format(DateTime.now());

  late num initialDayMilliseconds;
  late num endDayMilliseconds;

  selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2099),
    ).then((value) => {
          setState(() {
            var formattedTestDay = DateFormat.yMMMd().format(value!);
            testDay = formattedTestDay;
            filteredList = reqs.where((el) {
              var formattedCreatedAt = DateFormat.yMMMd().format(el.createdAt);
              if (formattedCreatedAt == testDay) {
                return true;
              }
              return false;
            }).toList();

            // var formattedCreatedAt =
            //     DateFormat.yMMMd().format(el.createdAt);
            // print('created $formattedCreatedAt');

            // print('el date ${el.createdAt}');

            //------ initial setup----//
            // print('form ${formattedNewDay}');
            // print('inital ${initialDay}');

            // print('before date is set $filteredList');
            // // print('initial date ${initialDate} and ');
            // print('after date is set $filteredList');
            //------end of initial setup --//
          })
        });
  }

  selectFromDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2099),
    ).then((value) => {
          setState(() {
            var formattedNewYear = DateFormat.y().format(value!);
            var formattedNewMonth = DateFormat.M().format(value);
            var formattedNewDay = DateFormat.d().format(value);

            // print(
            //     'print $formattedNewYear, $formattedNewMonth $formattedNewDay');

            //-- using button --//
            final DateTime date2 = DateTime(int.parse(formattedNewYear),
                int.parse(formattedNewMonth), int.parse(formattedNewDay));
            final timestamp1 = date2.millisecondsSinceEpoch;
            initialDayMilliseconds = timestamp1;
            var displayInitialDate = formattedNewYear +
                "-" +
                formattedNewMonth +
                "-" +
                formattedNewDay;

            print('start timestamp $timestamp1 (milliseconds)');
            initialDay = displayInitialDate;
          })
        });
  }

  selectEndDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2099),
    ).then((value) => {
          setState(() {
            // var formattedEndDay = DateFormat.yMMMd().format(value!);
            var formattedEndYear = DateFormat.y().format(value!);
            var formattedEndMonth = DateFormat.M().format(value);
            var formattedEndDay = DateFormat.d().format(value);

            print(
                'print $formattedEndYear, $formattedEndMonth $formattedEndDay');

            //-- using button --//
            final DateTime date3 = DateTime(int.parse(formattedEndYear),
                int.parse(formattedEndMonth), int.parse(formattedEndDay));
            final timestamp1 = date3.millisecondsSinceEpoch;
            print('end timestamp $timestamp1 (milliseconds)');

            var displayEndDate = formattedEndYear +
                "-" +
                formattedEndMonth +
                "-" +
                formattedEndDay;

            endDayMilliseconds = timestamp1;
            endDay = displayEndDate;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'Approval History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            /*
            GestureDetector(
              onTap: () {
                selectDate();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(),
                ),
                child: Text(testDay),
              ),
            ),

             */
            Text('Select From Date'),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                selectFromDate();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(),
                ),
                child: Text(initialDay),
              ),
            ),
            SizedBox(height: 15),
            Text('Select To Date'),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                selectEndDate();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(),
                ),
                child: Text(
                  endDay,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  filteredList = reqs.where((el) {
                    var formattedEndYear = DateFormat.y().format(el.createdAt!);
                    var formattedEndMonth = DateFormat.M().format(el.createdAt);
                    var formattedEndDay = DateFormat.d().format(el.createdAt);

                    // print(
                    //     'print $formattedEndYear, $formattedEndMonth $formattedEndDay');

                    //-- using button --//
                    final DateTime date3 = DateTime(
                      int.parse(formattedEndYear),
                      int.parse(formattedEndMonth),
                      int.parse(formattedEndDay),
                    );
                    final num timestamp1 = date3.millisecondsSinceEpoch;
                    print('created at $timestamp1 (milliseconds)');

                    if (timestamp1 >= initialDayMilliseconds &&
                        timestamp1 <= endDayMilliseconds) {
                      return true;
                    } else {
                      return false;
                    }
                  }).toList();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kMainColor,
              ),
              child: Text('Search Date Range'),
            ),
            Divider(),
            SizedBox(height: 15),
            Visibility(
              visible: isLoaded,
              replacement: Center(
                child: CircularProgressIndicator(),
              ),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final reqss = filteredList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestDetails(
                                id: reqss.id!,
                                subject: reqss.requestContentSubject,
                                requestSent: reqss.requestSent,
                                requestContent: reqss.requestContent,
                                requestResponded: reqss.requestResponded,
                                requestStatus: reqss.requestStatus,
                                responseContent: reqss.responseContent,
                                adminEmail: reqss.adminEmail,
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
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     ApiResponse response =
                            //         await deleteAcknowledgement(reqss.id);
                            //     getRequestApprovedData();
                            //   },
                            //   child: Text('Delete'),
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: kSubColor,
                            //   ),
                            // ),
                            Divider(
                              thickness: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

/*
  SizedBox(height: 5),
                            // delete a request
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kMainColor,
                                  shape: StadiumBorder(),
                                ),
                                onPressed: () async {
                                  ApiResponse response =
                                      await deleteAcknowledgement(reqss.id);

                                  if (response.error == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        content: Text(
                                            'Acknowledgement Request deleted Successfully'),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                )),
 */
