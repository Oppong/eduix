import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:eduix/services/acknowledge_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constant.dart';
import 'homepage.dart';

class AwaitingDetails extends StatefulWidget {
  const AwaitingDetails(
      {this.id, this.subject, this.requestContent, this.requestSent, Key? key})
      : super(key: key);
  static const String ids = 'awaiting details';

  final String? subject;
  final int? id;
  final String? requestContent;
  final String? requestSent;

  @override
  State<AwaitingDetails> createState() => _AwaitingDetailsState();
}

class _AwaitingDetailsState extends State<AwaitingDetails> {
  final QuillEditorController controller = QuillEditorController();
  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.blockQuote,
    ToolBarStyle.codeBlock,
    ToolBarStyle.link,
  ];

  var dated = DateFormat.yMMMMEEEEd();
  var responseContent;
  final textController = TextEditingController();

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
                Spacer(),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Approve/Reject Message',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Gilroy',
                color: Colors.grey.shade900,
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 6),

            Container(
              color: Colors.cyan.shade50,
              child: ToolBar(
                  controller: controller, toolBarConfig: customToolBarList),
            ),
            Container(
              height: 250,
              child: QuillHtmlEditor(
                hintText: 'Enter Response Text',
                controller: controller,
                height: MediaQuery.of(context).size.height,
                onTextChanged: (text) {
                  responseContent = text;
                  print('${responseContent}');
                },
                isEnabled: true,
              ),
            ),

            // SizedBox(height: 6),

            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Approval'),
                        content: Text(
                          'Are you sure you want to approve this acknowledgment requests',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              responseContent = await controller.getText();

                              if (responseContent.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text(
                                        'Enter a response content/message'),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                await updateAcknowledgement(
                                        reqid: widget.id!,
                                        requestStatus: 'approved',
                                        responseContent: responseContent!)
                                    .then((response) {
                                  if (response['status'] == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.teal,
                                        content: Text('${response['message']}'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text('${response['message']}'),
                                      ),
                                    );
                                  }
                                });
                                controller.clear();
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, HomePage.id, (route) => false);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kMainColor,
                              shape: StadiumBorder(),
                              elevation: 0.0,
                            ),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kSubColor,
                              shape: StadiumBorder(),
                              elevation: 0.0,
                            ),
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kMainColor,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    elevation: 0.0,
                  ),
                  child: Text('Approve'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Reject'),
                        content: Text(
                          'Are you sure you want to reject this acknowledgment requests',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              responseContent = await controller.getText();

                              if (responseContent.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text(
                                        'Enter a response content/message'),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                await updateAcknowledgement(
                                        reqid: widget.id!,
                                        requestStatus: 'rejected',
                                        responseContent: responseContent!)
                                    .then((response) {
                                  // print('MY RESPONSE $response');
                                  if (response['status'] == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.teal,
                                        content: Text('${response['message']}'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text('${response['message']}'),
                                      ),
                                    );
                                  }
                                });
                                controller.clear();
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, HomePage.id, (route) => false);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kMainColor,
                              shape: StadiumBorder(),
                              elevation: 0.0,
                            ),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kSubColor,
                              shape: StadiumBorder(),
                              elevation: 0.0,
                            ),
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSubColor,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    elevation: 0.0,
                  ),
                  child: Text('Reject'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/*
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
 */
