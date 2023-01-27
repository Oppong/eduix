/*
TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Search by title or content',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {
                  filteredList = reqs
                      .where((el) => (el.requestContentSubject!
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          el.requestContent!
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                });
              },
            ),
 */

/*
 Text('Select Date'),
            SizedBox(height: 2),
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
                child: Text(
                  dated.format(
                    DateTime.parse(initialDate.toString()),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Divider(),
 */

/*
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
                                        backgroundColor: Colors.teal,
                                        content: Text(
                                            'Acknowledgement Request deleted Successfully'),
                                      ),
                                    );
                                  }
                                },
                                child: Text('delete')),
 */

/*
 List pend = [];
  Future<List> getAllPendingRequest() async {
    String token = await getToken();
    final response = await http
        .get(Uri.parse('http://192.168.43.87:8000/api/allrequests'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      pend = jsonDecode(response.body);
      print(pend);
      return pend.map((el) => Requests()).toList();
    } else {
      throw Exception('Could not retrieve acknowledgement request');
    }
  }
 */

/* server errors
  Future<void> getRequests() async {
    userId = await getUserId();
    ApiResponse response = await getAcknowledgement();

    if (response.error == null) {
      setState(() {
        pendingList = response.data as List<dynamic>;
        print(pendingList);
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(SignInPage.id, (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

   */

/*
ListView.builder(
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
                                DateTime.parse(reqss.requestSent.toString()),
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
              }),
 */

/*
 Future<List<Pending>> getAllPendingRequest() async {
    try {
      final response = await http.get(Uri.parse(pendingrequestsUrl), headers: {
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        List pending = jsonDecode(response.body);
        return pending.map((pd) => Pending.fromJson(pd)).toList();
      } else {
        throw Exception('Could not retrieve acknowledgement request');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

   getAllPendingRequest().then((value) => {
          setState(() {
            pendingList = value;
          })
        });

  Visibility(
            visible: isLoaded,
            replacement: Center(
              child: CircularProgressIndicator(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: requestList?.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(requestList![index].requestContentSubject!),
                      ],
                    );
                  }),
            ),
          ),
 */

/*
Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Search by title or content',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  )),
              onChanged: (string) {
                setState(() {
                  filteredList = reqs
                      .where((el) => (el.requestContentSubject!
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          el.requestContent!
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                });
              },
            ),
          ),
 */
/*
void getRequestPendingData() async {
    String token = await getToken();
    final response = await http.get(
        Uri.parse('http://192.168.43.87:8000/api/pendingrequests'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        reqs = json;
        // filteredList = reqs;
      });
    } else {
      throw Exception('Could not retrieve acknowledgement request');
    }
  }
 */

/*
TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Search by title or content',
                  hintStyle: TextStyle(
                    fontSize: 12,
                  ),
                  enabledBorder: OutlineInputBorder()),
              onChanged: (string) {
                setState(() {
                  filteredList = reqs
                      .where((el) => (el.requestContentSubject!
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          el.requestContent!
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                });
              },
            ),
 */
