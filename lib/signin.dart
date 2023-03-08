import 'package:eduix/models/api_response.dart';
import 'package:eduix/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constant.dart';
import 'homepage.dart';
import 'models/user.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = ' signin page';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String email = '';
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: SpinKitDoubleBounce(
                color: kMainColor,
                size: 30.0,
              ),
            )
          : Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      'images/eduix.png',
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'Admin Sign In',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                      color: kMainColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              email = val;
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 11,
                              ),
                              labelText: 'Email Address',
                              contentPadding: EdgeInsets.all(10),
                              hintStyle: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade400),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade600),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            controller: _emailController,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kSubColor,
                            shape: StadiumBorder(),
                            minimumSize: Size(320, 50),
                            elevation: 0.0,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                isLoading = true;
                              });

                              // loginUser();

                              login(email: email).then((response) async {
                                if (response['status'] == 200) {
                                  String token = response['token'];

                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setString('token', token);

                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      HomePage.id, (route) => false);

                                  setState(() {
                                    isLoading = false;
                                  });
                                  _emailController.clear();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text('${response['message']}'),
                                    ),
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              });
                            }
                          },
                          child: Text('Sign In'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/*
void loginUser() async {
    ApiResponse response = await login(_emailController.text);

    if (response.error == null) {
      saveUserInfoAndRedirect(response.data as User);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }


  void saveUserInfoAndRedirect(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('id', user.id ?? 0);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomePage.id, (route) => false);
  }
 */
