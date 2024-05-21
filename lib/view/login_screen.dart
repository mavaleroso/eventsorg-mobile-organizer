import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/img.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              width: double.infinity,
              child: TextButton(
                style:
                    TextButton.styleFrom(foregroundColor: Colors.transparent),
                child: Text(
                  "MiataClubPh",
                  style: TextStyle(color: Colors.grey[300]),
                ),
                onPressed: () {},
              ),
            ),
            TextField(
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
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
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {},
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
