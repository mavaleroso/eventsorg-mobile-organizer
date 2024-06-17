import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/view/screens/main_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckInBreakfastStub extends StatefulWidget {
  const CheckInBreakfastStub({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckInBreakfastStubState createState() => _CheckInBreakfastStubState();
}

class _CheckInBreakfastStubState extends State<CheckInBreakfastStub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Breakfast Stub",
          style: MyText.title(context)!.copyWith(color: MyColors.grey_3),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[900],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.blue[900],
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Get.offAll(() => MainScreen(currentIndex: 1));
              // Navigator.pop(context);
            }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'MIATA',
              style: TextStyle(
                fontFamily: 'MazdaTypeRegular',
                fontSize: 90.4,
                fontWeight: FontWeight.bold,
                height: .8,
              ),
            ),
            const Text(
              'CLUB PHILIPPINES',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                height: .8,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'BREAKFAST STAB',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            QrImageView(
              data: '667f9581-ccf5-478a-8fcc-8bd448292d93',
              version: QrVersions.auto,
              size: 200.0,
            ),
            Text(
              ('John Doe').toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'June 2024 Monthly Meeting',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'Makati City',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Text(
              'Jun-17-2024',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Add print functionality
              },
              child: const Text(
                'Print',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
