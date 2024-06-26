import 'dart:async';

import 'package:eventsorg_mobile_organizer/view/screens/login_screen.dart';
import 'package:eventsorg_mobile_organizer/view/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/my_colors.dart';
import '../../data/img.dart';
import '../widgets/my_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () async {
      Get.to(() => const LoginScreen());
    });
    return Scaffold(
      backgroundColor: MyColors.grey_3,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Img.get('logo_small.png'),
                    color: MyColors.primary,
                    width: 70,
                    height: 70,
                  ),
                  Container(height: 10),
                  Text("MiataClubPh",
                      style: MyText.body1(context)!.copyWith(
                          color: MyColors.grey_60,
                          fontWeight: FontWeight.bold)),
                  Container(height: 2),
                  Text("2024",
                      style: MyText.body1(context)!
                          .copyWith(color: MyColors.grey_60)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 105,
                    height: 4,
                    child: LinearProgressIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                left: -100,
                bottom: -80,
                child: Image.asset(
                  Img.get('logo.png'),
                  color: MyColors.overlay_dark_10,
                  width: 300,
                  height: 300,
                ))
          ],
        ),
      ),
    );
  }
}
