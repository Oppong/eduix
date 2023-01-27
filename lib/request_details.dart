import 'package:eduix/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:quill_html_editor/quill_html_editor.dart';
import 'constant.dart';
import 'models/requests.dart';
import 'dart:convert';
import 'package:flutter_super_html_viewer/flutter_super_html_viewer.dart';

class RequestDetails extends StatefulWidget {
  const RequestDetails(
      {this.id,
      this.subject,
      this.requestContent,
      this.adminEmail,
      this.requestStatus,
      this.requestResponded,
      this.requestSent,
      this.responseContent,
      Key? key})
      : super(key: key);
  static const String ids = 'request details';

  final DateTime? requestSent, requestResponded;
  final String? subject,
      requestContent,
      requestStatus,
      adminEmail,
      responseContent;
  final int? id;

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  var dated = DateFormat.yMMMMEEEEd();

  Future<Requests> getSingleRequestsData() async {
    String token = await getToken();
    final response = await http
        .get(Uri.parse('$showSingleRequestUrl/${widget.id}'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Requests.fromJson(json);
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getSingleRequestsData();
  }

  final QuillEditorController controller = QuillEditorController();

  getString(text) async {
    await controller.setText(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          widget.subject!,
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
          children: [
            Text(
              widget.requestContent!,
              style: TextStyle(
                fontSize: 14,
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
                  'Request submitted date',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    // color: kSubColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
                Spacer(),
                Text(
                  dated.format(
                    DateTime.parse(widget.requestSent.toString()),
                  ),
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
            widget.requestStatus! == 'approved'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Request Approved date',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Gilroy',
                          // color: kSubColor,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Spacer(),
                      Text(
                        dated.format(
                          DateTime.parse(widget.requestResponded.toString()),
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Gilroy',
                          color: kSubColor,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )
                : Container(),
            widget.requestStatus! == 'rejected'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Request Rejected date',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Gilroy',
                          // color: kSubColor,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Spacer(),
                      Text(
                        dated.format(
                          DateTime.parse(widget.requestResponded.toString()),
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Gilroy',
                          color: kSubColor,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 20),
            Text(
              'Response Message',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Gilroy',
                color: Colors.grey.shade900,
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            Container(
              height: 300,
              child: HtmlContentViewer(
                htmlContent: widget.responseContent!,
                initialContentHeight: MediaQuery.of(context).size.height,
                initialContentWidth: MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(height: 10),
            widget.requestStatus! == 'approved'
                ? Text('Approved By: ${widget.adminEmail}')
                : Text('Rejected By: ${widget.adminEmail}'),
          ],
        ),
      ),
    );
  }
}

/*
Text(
// req?.responseContent ?? ' ',
getString(req.responseContent).toString(),
style: TextStyle(
fontSize: 12,
fontFamily: 'Gilroy',
color: Colors.grey.shade900,
height: 1.5,
),
textAlign: TextAlign.justify,
),
 */
