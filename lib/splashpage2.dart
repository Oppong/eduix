import 'dart:async';

import 'package:eduix/homepage.dart';
import 'package:eduix/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'awaiting_provider.dart';

class SplashPage2 extends StatefulWidget {
  const SplashPage2({Key? key}) : super(key: key);
  static const String id = 'splash page2';

  @override
  State<SplashPage2> createState() => _SplashPage2State();
}

class _SplashPage2State extends State<SplashPage2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AwaitingProvider>(context, listen: false)
        .allAwaitingApprovals();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3), () => Navigator.pushNamed(context, HomePage.id));
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
