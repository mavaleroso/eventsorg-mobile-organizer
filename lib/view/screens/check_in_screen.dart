import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:eventsorg_mobile_organizer/controller/state_controller.dart';
import 'package:eventsorg_mobile_organizer/data/attendance_data.dart';
import 'package:eventsorg_mobile_organizer/data/events_data.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/model/events_model.dart';
import 'package:eventsorg_mobile_organizer/view/screens/check_in_plate_screen.dart';
import 'package:eventsorg_mobile_organizer/view/screens/check_in_qr_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

// ignore: must_be_immutable
class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  EventsModel? _selectedValue;
  late Future<List<EventsModel>> eventsFuture;
  bool isQrView = true;

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
  Widget build(BuildContext context) {
    final StateController stateController = Get.find();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child:
                isQrView ? const CheckInQrScreen() : const CheckInPlateScreen(),
          ),
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
                              if (stateController.eventId != 0) {
                                _selectedValue = eventSnapshot.data
                                    ?.where((test) =>
                                        test.id == stateController.eventId)
                                    .first;
                              } else {
                                _selectedValue = eventSnapshot.data!.first;
                                stateController
                                    .updateEventId(_selectedValue?.id);
                              }
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
                                    stateController.updateEventId(value?.id);
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
                            backgroundColor:
                                isQrView ? Colors.blue : Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              isQrView = true;
                            });
                          },
                          child: Icon(
                            Icons.qr_code_scanner_rounded,
                            color: isQrView ? Colors.white : MyColors.grey_90,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                !isQrView ? Colors.blue : Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              isQrView = false;
                            });
                          },
                          child: Icon(
                            Icons.car_repair,
                            color: !isQrView ? Colors.white : MyColors.grey_90,
                          ),
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
}
