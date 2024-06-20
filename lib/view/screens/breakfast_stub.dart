import 'package:eventsorg_mobile_organizer/controller/state_controller.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/view/screens/main_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

class BreakfastStub extends StatefulWidget {
  String code;
  BreakfastStub({super.key, required this.code});

  @override
  // ignore: library_private_types_in_public_api
  _BreakfastStubState createState() => _BreakfastStubState();
}

class _BreakfastStubState extends State<BreakfastStub> {
  ScreenshotController screenshotController = ScreenshotController();
  StateController stateController = Get.find();

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
              Get.back();
              // Navigator.pop(context);
            }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Screenshot(
              controller: screenshotController,
              child: Column(
                children: [
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
                    'BREAKFAST STUB',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  QrImageView(
                    data: widget.code,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  Text(
                    (stateController.userFullname).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stateController.eventName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    stateController.eventLocation,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    stateController.eventStartDate,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 300, // Set the desired width here
              child: ElevatedButton(
                onPressed: () {
                  screenshotController
                      .capture(delay: const Duration(milliseconds: 10))
                      .then((capturedImage) async {
                    printDoc(capturedImage!);
                  }).catchError((onError) {
                    print(onError);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Print',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> printDoc(image) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Expanded(
            child: pw.Center(child: pw.Image(pw.MemoryImage(image))),
          ); //getting error here
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }
}
