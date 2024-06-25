import 'package:eventsorg_mobile_organizer/context/api.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/view/screens/main_screen.dart';
import 'package:flutter/material.dart';
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
  bool isHidePassword = true;

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
      prefs.setString('email', email);
      prefs.setString('token', token);
      Get.to(() => MainScreen(
            currentIndex: 0,
            eventId: 0,
          ));
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
      backgroundColor: MyColors.grey_3,
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
                color: MyColors.primary,
              ),
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: TextButton(
                style:
                    TextButton.styleFrom(foregroundColor: Colors.transparent),
                child: const Text(
                  "MiataClubPh",
                  style: TextStyle(
                    color: MyColors.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
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
              style: const TextStyle(color: Colors.black),
              controller: emailController,
              enabled: !isLoading,
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                prefixIconColor: MyColors.primary,
                filled: true,
                fillColor: MyColors.grey_10,
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Container(height: 25),
            TextField(
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.black),
              obscureText: isHidePassword,
              controller: passwordController,
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: "Password",
                filled: true,
                fillColor: MyColors.grey_10,
                prefixIcon: const Icon(Icons.password),
                prefixIconColor: MyColors.primary,
                labelStyle: const TextStyle(color: Colors.black),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: () => {
                    setState(() {
                      isHidePassword = !isHidePassword;
                    })
                  },
                  icon: Icon(isHidePassword
                      ? Icons.remove_red_eye_outlined
                      : Icons.remove_red_eye),
                ),
              ),
            ),
            const SizedBox(height: 45),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth:
                              2.0, // Optional: Adjust the thickness of the progress indicator
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 15,
                            color: MyColors.grey_3,
                            fontWeight: FontWeight.bold),
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
