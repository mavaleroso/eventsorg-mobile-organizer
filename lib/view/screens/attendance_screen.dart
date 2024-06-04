import 'dart:convert';

import 'package:eventsorg_mobile_organizer/data/attendance_data.dart';
import 'package:eventsorg_mobile_organizer/data/events_data.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/model/attendance_model.dart';
import 'package:eventsorg_mobile_organizer/model/events_model.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  late BuildContext context;
  int paginationFrom = 0;
  int paginationTo = 0;
  int paginationTotal = 0;
  String paginationPrevLink = '';
  String paginationNextLink = '';
  int paginationCurrentPage = 1;
  EventsModel? _selectedValue;
  int? eventIdVar;

  late Future<List<EventsModel>> eventsFuture;
  Future<List<AttendanceModel>>? attendanceFuture;

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

  Future<List<AttendanceModel>> getAttendance(page, eventId) async {
    var response = await AttendanceData().getAttendanceList(page, eventId);
    var data = json.decode(response['data']);
    List body = data['data'];
    setState(() {
      paginationFrom = data['meta']['from'] ?? 0;
      paginationTo = data['meta']['to'] ?? 0;
      paginationTotal = data['meta']['total'] ?? 0;
      paginationPrevLink = data['links']['prev'] ?? '';
      paginationNextLink = data['links']['next'] ?? '';
      paginationCurrentPage = data['meta']['current_page'] ?? 1;
      eventIdVar = eventId;
    });
    return body.map((e) => AttendanceModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: eventsFuture,
          builder: (context, eventSnapshot) {
            if (eventSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (eventSnapshot.hasData) {
              var events = eventSnapshot.data!;
              _selectedValue ??= eventSnapshot.data!.first;
              attendanceFuture ??=
                  getAttendance(paginationCurrentPage, _selectedValue?.id);
              return Column(
                children: [
                  Card(
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: DropdownButtonFormField<EventsModel>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.event_note),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Event',
                          isDense: true,
                        ),
                        items: events.map<DropdownMenuItem<EventsModel>>(
                            (EventsModel item) {
                          return DropdownMenuItem<EventsModel>(
                            value: item,
                            child: Text(item.name!),
                          );
                        }).toList(),
                        onChanged: (EventsModel? value) {
                          setState(() {
                            _selectedValue = value;
                            attendanceFuture = getAttendance(
                                paginationCurrentPage, _selectedValue?.id);
                          });
                        },
                        value: _selectedValue,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FutureBuilder(
                        future: attendanceFuture,
                        builder: (context, attendanceSnapshot) {
                          if (attendanceSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (attendanceSnapshot.hasData &&
                              attendanceSnapshot.data!.isNotEmpty) {
                            var attendance = attendanceSnapshot.data!;
                            return buildAttendance(attendance);
                          } else {
                            return const Text("No attendance currently");
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    color: MyColors.grey_3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (paginationCurrentPage > 1 &&
                                paginationPrevLink != '') {
                              getAttendance(
                                  paginationCurrentPage - 1, eventIdVar);
                            }
                          },
                          icon: const Icon(Icons.arrow_left),
                          iconSize: 35,
                        ),
                        Text(
                          '$paginationFrom - $paginationTo of $paginationTotal items',
                          style: MyText.body2(context)!
                              .copyWith(color: MyColors.grey_90),
                        ),
                        IconButton(
                          onPressed: () {
                            if (paginationNextLink != '') {
                              getAttendance(
                                  paginationCurrentPage + 1, eventIdVar);
                            }
                          },
                          icon: const Icon(Icons.arrow_right),
                          iconSize: 35,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("No events available"));
            }
          }),
    );
  }

  Widget buildAttendance(List<AttendanceModel> attendance) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: attendance.length,
            itemBuilder: (context, index) {
              final attend = attendance[index];
              return Container(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Card(
                    margin: const EdgeInsets.all(0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Text("Name:",
                                            style: MyText.body2(context)!
                                                .copyWith(
                                                    color: MyColors.grey_80)),
                                        const Spacer(),
                                        Expanded(
                                          flex: 6,
                                          child: Text(attend.name ?? '',
                                              softWrap: true,
                                              textAlign: TextAlign.right,
                                              overflow: TextOverflow.visible,
                                              style: MyText.body2(context)!
                                                  .copyWith(
                                                      color:
                                                          MyColors.grey_100_)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("Status:",
                                            style: MyText.body2(context)!
                                                .copyWith(
                                                    color: MyColors.grey_80)),
                                        const Spacer(),
                                        Expanded(
                                          flex: 6,
                                          child: Text(attend.status ?? '',
                                              softWrap: true,
                                              textAlign: TextAlign.right,
                                              overflow: TextOverflow.visible,
                                              style: MyText.body2(context)!
                                                  .copyWith(
                                                      color:
                                                          MyColors.grey_100_)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("Nickname:",
                                            style: MyText.body2(context)!
                                                .copyWith(
                                                    color: MyColors.grey_80)),
                                        const Spacer(),
                                        Expanded(
                                          flex: 6,
                                          child: Text(attend.nickname ?? '',
                                              softWrap: true,
                                              textAlign: TextAlign.right,
                                              overflow: TextOverflow.visible,
                                              style: MyText.body2(context)!
                                                  .copyWith(
                                                      color:
                                                          MyColors.grey_100_)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text("Check-in Time:",
                                            style: MyText.body2(context)!
                                                .copyWith(
                                                    color: MyColors.grey_80)),
                                        const Spacer(),
                                        Expanded(
                                          flex: 6,
                                          child: Text(attend.checkinTime ?? '',
                                              softWrap: true,
                                              textAlign: TextAlign.right,
                                              overflow: TextOverflow.visible,
                                              style: MyText.body2(context)!
                                                  .copyWith(
                                                      color:
                                                          MyColors.grey_100_)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    )),
              );
            },
          ),
        ),
      ],
    );
  }
}
