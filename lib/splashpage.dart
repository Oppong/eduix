import 'dart:async';

import 'package:eduix/constant.dart';
import 'package:eduix/homepage.dart';
import 'package:eduix/models/api_response.dart';
import 'package:eduix/services/user_service.dart';
import 'package:eduix/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'awaiting_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String id = 'splash page';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /*
  void loadUserInformation() async {
    String token = await getToken();
    if (token == '') {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(SignInPage.id, (route) => false);
    } else {
      ApiResponse response = await getUserDetail();
      if (response.error == null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.id, (route) => false);
      } else if (response.error == unauthorized) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(SignInPage.id, (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }
   */

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadUserInformation();
    Provider.of<AwaitingProvider>(context, listen: false)
        .allAwaitingApprovals();
  }

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(seconds: 3),
    //     () => Navigator.pushNamed(context, SignInPage.id));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Image.asset(
            'images/eduix.png',
            width: 200,
          ),
        ),
      ),
    );
  }
}
