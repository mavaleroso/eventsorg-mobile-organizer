import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eventsorg_mobile_organizer/controller/state_controller.dart';
import 'package:eventsorg_mobile_organizer/data/attendance_data.dart';
import 'package:eventsorg_mobile_organizer/data/events_data.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CheckInQrScreen extends StatefulWidget {
  const CheckInQrScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckInQrScreenState createState() => _CheckInQrScreenState();
}

class _CheckInQrScreenState extends State<CheckInQrScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  admitUser(code) async {
    final StateController stateController = Get.find();

    var res = await AttendanceData()
        .admitUser('qr', stateController.eventId, code, 0);

    var data;

    try {
      data = json.decode(res['data']);
    } catch (e) {
      data = [];
    }

    if (res['code'] == 200 || res['code'] == 201) {
      MyToast.showCustom(
          context,
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.green[500],
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.done, color: Colors.white, size: 20),
                Container(width: 10),
                Text("Successfully admitted!",
                    style: MyText.body1(context)!
                        .copyWith(color: MyColors.grey_5)),
                Container(width: 8),
              ],
            ),
          ));

      controller?.resumeCamera();
    } else {
      if (data['message'] == 'User has not joined yet.') {
        addMember(context, stateController.eventId, code);
      } else {
        MyToast.showCustom(
            context,
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.red[600],
                  borderRadius: const BorderRadius.all(Radius.circular(30))),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.close, color: Colors.white, size: 20),
                  Container(width: 10),
                  Text(data.length > 0 ? data['message'] : "Error encountered!",
                      style: MyText.body1(context)!
                          .copyWith(color: MyColors.grey_5)),
                  Container(width: 8),
                ],
              ),
            ));

        controller?.resumeCamera();
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();

      // print(scanData.code);

      admitUser(scanData.code);

      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void addMember(context, eventId, userIdNo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Admission Warning"),
          content: const Text(
              "Only enrolled users are allowed to admit in this event and it seems like the user is not."),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('JOIN'),
              onPressed: () async {
                var data = {
                  'event_id': eventId,
                  'id_no': userIdNo,
                  'is_paid': false
                };

                var response = await EventsData().joinMember(data);

                if (response['code'] == 200 || response['code'] == 201) {
                  MyToast.showCustom(
                      context,
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.green[500],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.done,
                                color: Colors.white, size: 20),
                            Container(width: 10),
                            Text("Successfully added!",
                                style: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_5)),
                            Container(width: 8),
                          ],
                        ),
                      ));
                } else {
                  MyToast.showCustom(
                      context,
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.red[600],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.close,
                                color: Colors.white, size: 20),
                            Container(width: 10),
                            Text("Error encountered!",
                                style: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_5)),
                            Container(width: 8),
                          ],
                        ),
                      ));
                }

                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
