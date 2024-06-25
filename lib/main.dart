import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/view/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Connectivity connectivity = Connectivity();

  void initConnectivityListener(BuildContext context) {
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      // Handle connectivity change
      if (result == ConnectivityResult.none) {
        // No internet connection
        // Display a dialog or perform other actions
        showNoInternetDialog(context);
      } else {
        // Internet connection is available
        // Perform necessary actions
      }
    });
  }

  void showNoInternetDialog(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MyColors.primary),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
