import 'package:eventsorg_mobile_organizer/context/api.dart';
import 'package:eventsorg_mobile_organizer/view/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/img.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool invalidCredentials = false;
  bool invalidEntries = false;
  bool isLoading = false;

  _login(ctxOvly) async {
    String email = emailController.text;
    String password = passwordController.text;

    setState(() {
      isLoading = true;
      invalidEntries = false;
      invalidCredentials = false;
    });

    if (email == '' || password == '') {
      setState(() {
        invalidEntries = true;
        isLoading = false;
      });
      return;
    }

    var data = {
      'email': email,
      'password': password,
      'device_name': 'mobile',
    };

    var res = await CallApi().postData(data, 'login');

    if (res['code'] == 200) {
      Map<String, dynamic> decodedResponse = jsonDecode(res['data']);
      String token = decodedResponse['token'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('email', email);
      prefs.setString('token', token);
      Get.to(() => MainScreen());
      setState(() {
        invalidEntries = false;
        invalidCredentials = false;
        emailController.text = '';
        passwordController.text = '';
      });
    } else {
      setState(() {
        invalidCredentials = true;
        emailController.text = '';
        passwordController.text = '';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.blueGrey[900]),
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Spacer(),
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                Img.get('logo_small_round.png'),
                color: Colors.blue[300],
              ),
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: TextButton(
                style:
                    TextButton.styleFrom(foregroundColor: Colors.transparent),
                child: Text(
                  "MiataClubPh",
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 17,
                  ),
                ),
                onPressed: () {},
              ),
            ),
            if (invalidCredentials)
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Invalid credentials! Please try again.',
                    style: TextStyle(
                      color: Colors.red[300],
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            if (invalidEntries)
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Please fill-in all fields to proceed.',
                    style: TextStyle(
                      color: Colors.red[300],
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              controller: emailController,
              enabled: !isLoading,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.blueGrey[400]),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.blueGrey[400]!, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.blueGrey[400]!, width: 2),
                ),
              ),
            ),
            Container(height: 25),
            TextField(
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              controller: passwordController,
              enabled: !isLoading,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.blueGrey[400]),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.blueGrey[400]!, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.blueGrey[400]!, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 45),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: isLoading
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth:
                                  2.0, // Optional: Adjust the thickness of the progress indicator
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                onPressed: () {
                  _login(context);
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
