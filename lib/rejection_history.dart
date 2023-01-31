import 'dart:convert';

import 'package:eduix/request_details.dart';
import 'package:eduix/services/acknowledge_service.dart';
import 'package:eduix/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'models/api_response.dart';
import 'models/requests.dart';

class RejectionHistory extends StatefulWidget {
  const RejectionHistory({Key? key}) : super(key: key);
  static const String id = 'rejection history';

  @override
  State<RejectionHistory> createState() => _RejectionHistoryState();
}

class _RejectionHistoryState extends State<RejectionHistory> {
  var dated = DateFormat.yMMMMEEEEd();

  List<dynamic> reqs = [];
  List<dynamic> filteredList = [];
  bool isLoaded = false;

  void getRequestRejectedData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(rejectedrequestsUrl), headers: {
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

  var testDay = DateFormat.yMMMd().format(DateTime.now());
  var initialDay = DateFormat.yMMMd().format(DateTime.now());
  var endDay = DateFormat.yMMMd().format(DateTime.now());

  late num initialDayMilliseconds;
  late num endDayMilliseconds;

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

            final DateTime date2 = DateTime(int.parse(formattedNewYear),
                int.parse(formattedNewMonth), int.parse(formattedNewDay));
            final timestamp1 = date2.millisecondsSinceEpoch;
            initialDayMilliseconds = timestamp1;
            var displayInitialDate = formattedNewYear +
                "-" +
                formattedNewMonth +
                "-" +
                formattedNewDay;

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

            final DateTime date3 = DateTime(int.parse(formattedEndYear),
                int.parse(formattedEndMonth), int.parse(formattedEndDay));
            final timestamp1 = date3.millisecondsSinceEpoch;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequestRejectedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'Rejection History',
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
                child: Text(initialDay
                    // dated.format(
                    //   DateTime.parse(initialDay.toString()),
                    // ),
                    ),
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
                            //     getRequestRejectedData();
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
