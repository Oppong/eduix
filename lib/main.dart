import 'package:eduix/approval_history.dart';
import 'package:eduix/awaiting_approvals.dart';
import 'package:eduix/awaiting_provider.dart';
import 'package:eduix/homepage.dart';
import 'package:eduix/rejection_history.dart';
import 'package:eduix/request_details.dart';
import 'package:eduix/signin.dart';
import 'package:eduix/splashpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'awaiting_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EduixApp());
}

class EduixApp extends StatelessWidget {
  const EduixApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AwaitingProvider()),
      ],
      child: ConnectivityAppWrapper(
        app: MaterialApp(
          home: SplashPage(),
          debugShowCheckedModeBanner: false,
          routes: {
            SplashPage.id: (context) => SplashPage(),
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
