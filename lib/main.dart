import 'package:eduix/approval_history.dart';
import 'package:eduix/awaiting_approvals.dart';
import 'package:eduix/awaiting_provider.dart';
import 'package:eduix/homepage.dart';
import 'package:eduix/rejection_history.dart';
import 'package:eduix/request_details.dart';
import 'package:eduix/signin.dart';
import 'package:eduix/splashpage.dart';
import 'package:eduix/splashpage2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'awaiting_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.get('token');

  runApp(EduixApp(token as dynamic));
}

class EduixApp extends StatelessWidget {
  // const EduixApp({Key? key}) : super(key: key);

  EduixApp(this.token);
  final String? token;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AwaitingProvider()),
      ],
      child: ConnectivityAppWrapper(
        app: MaterialApp(
          home: token == null ? SignInPage() : SplashPage2(),
          debugShowCheckedModeBanner: false,
          routes: {
            SplashPage.id: (context) => SplashPage(),
            SplashPage2.id: (context) => SplashPage2(),
            SignInPage.id: (context) => SignInPage(),
            HomePage.id: (context) => HomePage(),
            AwaitingApprovals.id: (context) => AwaitingApprovals(),
            ApprovalHistoryPage.id: (context) => ApprovalHistoryPage(),
            RejectionHistory.id: (context) => RejectionHistory(),
            AwaitingDetails.ids: (context) => AwaitingDetails(),
            RequestDetails.ids: (context) => RequestDetails(),
          },
          builder: (buildContext, widget) {
            return ConnectivityWidgetWrapper(
              disableInteraction: true,
              height: 80,
              child: widget!,
            );
          },
        ),
      ),
    );
  }
}
