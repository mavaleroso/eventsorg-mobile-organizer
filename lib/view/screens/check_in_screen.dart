import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eventsorg_mobile_organizer/data/attendance_data.dart';
import 'package:eventsorg_mobile_organizer/data/events_data.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/model/events_model.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  EventsModel? _selectedValue;
  late Future<List<EventsModel>> eventsFuture;

  @override
  void initState() {
    super.initState();
    fetchEventsData(1);
  }

  Future<void> fetchEventsData(page) async {
    setState(() {
      eventsFuture = getEvents(page);
    });
  }

  Future<List<EventsModel>> getEvents(page) async {
    var response = await EventsData().getEventsList(page);
    var data = json.decode(response['data']);
    List body = data['data'];
    return body.map((e) => EventsModel.fromJson(e)).toList();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 3, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: FutureBuilder(
                          future: eventsFuture,
                          builder: (context, eventSnapshot) {
                            if (eventSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (eventSnapshot.hasData) {
                              var events = eventSnapshot.data!;
                              _selectedValue ??= eventSnapshot.data!.first;
                              return DropdownButtonFormField<EventsModel>(
                                isExpanded: true,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.event_note),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: 'Event',
                                  isDense: true,
                                ),
                                items: events
                                    .map<DropdownMenuItem<EventsModel>>(
                                        (EventsModel item) {
                                  return DropdownMenuItem<EventsModel>(
                                    value: item,
                                    child: Text(item.name!),
                                  );
                                }).toList(),
                                onChanged: (EventsModel? value) {
                                  setState(() {
                                    _selectedValue = value;
                                  });
                                },
                                value: _selectedValue,
                              );
                            } else {
                              return const Center(
                                  child: Text("No events available"));
                            }
                          }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: Icon(
                            Icons.qr_code_scanner_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: Icon(Icons.car_repair),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
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

  Widget _buildPlateScanningView(BuildContext context) {
    return Scaffold(body: Text('test'));
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller?.pauseCamera();
      print(scanData?.code);

      admitUser('qr', scanData?.code);

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

  admitUser(type, code) async {
    var res =
        await AttendanceData().admitUser(type, _selectedValue?.id, code, 0);

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
    }

    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
