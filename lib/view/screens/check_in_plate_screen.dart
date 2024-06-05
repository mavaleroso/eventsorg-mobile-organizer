import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:eventsorg_mobile_organizer/controller/state_controller.dart';
import 'package:eventsorg_mobile_organizer/data/attendance_data.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CheckInPlateScreen extends StatefulWidget {
  const CheckInPlateScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckInPlateScreenState createState() => _CheckInPlateScreenState();
}

class _CheckInPlateScreenState extends State<CheckInPlateScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    return await _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: CameraPreview(_controller),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: _captureAndSendImage,
                    child: const Icon(Icons.camera),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  admitUser(code) async {
    final StateController stateController = Get.find();

    var res = await AttendanceData()
        .admitUser('plate', stateController.eventId, code, 0);

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
                Text(
                    data.length > 0 ? data[0]['message'] : "Error encountered!",
                    style: MyText.body1(context)!
                        .copyWith(color: MyColors.grey_5)),
                Container(width: 8),
              ],
            ),
          ));
    }
  }

  void _captureAndSendImage() async {
    try {
      await _initializeControllerFuture; // Wait for camera preview to initialize

      final XFile imageFile = await _controller.takePicture();
      _controller.pausePreview();

      final bytes = await imageFile.readAsBytes();
      final response = await sendImageToPlateRecognizer(bytes);
      // Handle the response here
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        String plate = data['results'][0]['plate'];
        admitUser(plate);

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
                  Text(plate,
                      style: MyText.body1(context)!
                          .copyWith(color: MyColors.grey_5)),
                  Container(width: 8),
                ],
              ),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to recognize plate'),
            backgroundColor: Colors.red,
          ),
        );
      }

      _controller.resumePreview();
    } catch (e) {
      print('Error capturing and sending image: $e');
    }
  }

  Future<http.Response> sendImageToPlateRecognizer(Uint8List imageBytes) async {
    const url = 'https://api.platerecognizer.com/v1/plate-reader/';
    final headers = {
      'Authorization': 'Token cb5950aca207e2eefdf93696fef6f30dea0e23dd',
      'Content-Type': 'multipart/form-data',
    };

    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..files.add(http.MultipartFile.fromBytes(
        'upload',
        imageBytes,
        filename: 'plate.jpg',
      ));

    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
