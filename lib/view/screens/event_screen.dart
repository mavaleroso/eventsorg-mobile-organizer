import 'dart:convert';

import 'package:eventsorg_mobile_organizer/data/events_data.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/model/events_model.dart';
import 'package:eventsorg_mobile_organizer/view/screens/event_form_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  late BuildContext context;
  int paginationFrom = 0;
  int paginationTo = 0;
  int paginationTotal = 0;
  String paginationPrevLink = '';
  String paginationNextLink = '';
  int paginationCurrentPage = 1;

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
    setState(() {
      paginationFrom = data['meta']['from'] ?? 0;
      paginationTo = data['meta']['to'] ?? 0;
      paginationTotal = data['meta']['total'] ?? 0;
      paginationPrevLink = data['links']['prev'] ?? '';
      paginationNextLink = data['links']['next'] ?? '';
      paginationCurrentPage = data['meta']['current_page'] ?? 1;
    });
    return body.map((e) => EventsModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  fetchEventsData(paginationCurrentPage);
                },
                child: Center(
                  child: FutureBuilder(
                    future: eventsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        var events = snapshot.data!;
                        return buildEvents(events);
                      } else {
                        return const Text("No data available");
                      }
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              color: MyColors.grey_3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (paginationCurrentPage > 1 &&
                          paginationPrevLink != '') {
                        fetchEventsData(paginationCurrentPage - 1);
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
                        fetchEventsData(paginationCurrentPage + 1);
                      }
                    },
                    icon: const Icon(Icons.arrow_right),
                    iconSize: 35,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Get.to(const EventFormScreen());
                      });
                    },
                    icon: const Icon(Icons.add),
                    iconSize: 35,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildEvents(List<EventsModel> events) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
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
                                        Text("Event name:",
                                            style: MyText.body2(context)!
                                                .copyWith(
                                                    color: MyColors.grey_80)),
                                        const Spacer(),
                                        Expanded(
                                          flex: 6,
                                          child: Text(event.name ?? '',
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
                                        Text("Location:",
                                            style: MyText.body2(context)!
                                                .copyWith(
                                                    color: MyColors.grey_80)),
                                        const Spacer(),
                                        Expanded(
                                          flex: 6,
                                          child: Text(event.location ?? '',
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
                                        Text("Start date:",
                                            style: MyText.body2(context)!
                                                .copyWith(
                                                    color: MyColors.grey_80)),
                                        const Spacer(),
                                        Expanded(
                                          flex: 6,
                                          child: Text(event.startDate ?? '',
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
                                        Text("End date:",
                                            style: MyText.body2(context)!
                                                .copyWith(
                                                    color: MyColors.grey_80)),
                                        const Spacer(),
                                        Expanded(
                                          flex: 6,
                                          child: Text(event.endDate ?? '',
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
                                IconButton(
                                    onPressed: () {
                                      showSheet(context);
                                    },
                                    icon: const Icon(
                                        Icons.format_list_bulleted_rounded))
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

  void showSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.calendar_view_month),
                title: const Text("View"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.edit_calendar_outlined),
                title: const Text("Edit"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete"),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
