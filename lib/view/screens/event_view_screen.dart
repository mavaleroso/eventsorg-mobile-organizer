import 'dart:convert';

import 'package:eventsorg_mobile_organizer/controller/state_controller.dart';
import 'package:eventsorg_mobile_organizer/data/events_data.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/model/users_model.dart';
import 'package:eventsorg_mobile_organizer/view/screens/event_view_search_screen.dart';
import 'package:eventsorg_mobile_organizer/view/screens/main_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

class EventViewScreen extends StatefulWidget {
  int id;

  EventViewScreen({super.key, required this.id});

  @override
  _EventViewScreenState createState() => _EventViewScreenState();
}

class _EventViewScreenState extends State<EventViewScreen> {
  String name = '';
  String location = '';
  String startDate = '';
  String endDate = '';

  late Future<List<UsersModel>> usersFuture = getUsers();

  @override
  void initState() {
    fetchEvent();
    // fetchEventUsers();
    super.initState();
  }

  fetchEvent() async {
    StateController stateController = Get.find();

    var response = await EventsData().getEvent(widget.id);
    var data = json.decode(response['data']);

    setState(() {
      name = data['data']['name'];
      location = data['data']['location'];
      startDate = data['data']['start_date'];
      endDate = data['data']['end_date'];
    });

    stateController.updateEventInfo(data['data']['name'],
        data['data']['location'], data['data']['start_date']);
  }

  Future<List<UsersModel>> getUsers() async {
    var response = await EventsData().getEventUsers(widget.id);
    var data = json.decode(response['data']);
    List body = data['data'];
    return body.map((e) => UsersModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "View Event",
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
              Get.to(() => MainScreen(
                    currentIndex: 0,
                    eventId: 0,
                  ));
              // Navigator.pop(context);
            }),
      ),
      floatingActionButton: buildSpeedDial(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            child: Card(
              color: MyColors.grey_3,
              margin: const EdgeInsets.all(0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Details",
                                textAlign: TextAlign.left,
                                style: MyText.body2(context)!
                                    .copyWith(color: MyColors.grey_100_),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text("Event name:",
                                    style: MyText.body2(context)!
                                        .copyWith(color: MyColors.grey_80)),
                                const Spacer(),
                                Expanded(
                                  flex: 6,
                                  child: Text(name,
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.visible,
                                      style: MyText.body2(context)!
                                          .copyWith(color: MyColors.grey_100_)),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("Location:",
                                    style: MyText.body2(context)!
                                        .copyWith(color: MyColors.grey_80)),
                                const Spacer(),
                                Expanded(
                                  flex: 6,
                                  child: Text(location,
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.visible,
                                      style: MyText.body2(context)!
                                          .copyWith(color: MyColors.grey_100_)),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("Start date:",
                                    style: MyText.body2(context)!
                                        .copyWith(color: MyColors.grey_80)),
                                const Spacer(),
                                Expanded(
                                  flex: 6,
                                  child: Text(startDate,
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.visible,
                                      style: MyText.body2(context)!
                                          .copyWith(color: MyColors.grey_100_)),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("End date:",
                                    style: MyText.body2(context)!
                                        .copyWith(color: MyColors.grey_80)),
                                const Spacer(),
                                Expanded(
                                  flex: 6,
                                  child: Text(endDate,
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.visible,
                                      style: MyText.body2(context)!
                                          .copyWith(color: MyColors.grey_100_)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(3),
              child: Card(
                color: MyColors.grey_3,
                margin: const EdgeInsets.all(0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Members",
                          textAlign: TextAlign.left,
                          style: MyText.body2(context)!
                              .copyWith(color: MyColors.grey_100_),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            getUsers();
                          },
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: FutureBuilder(
                              future: usersFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  var user = snapshot.data!;
                                  return buildContent(user);
                                } else if (snapshot.data!.isEmpty) {
                                  return const Center(
                                      child: Text("No user member"));
                                } else {
                                  return const Center(
                                      child: Text("No data available"));
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent(List<UsersModel> users) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: const Icon(Icons.person),
                title: Text('${user.firstName} ${user.lastName}',
                    style: MyText.body1(context)!
                        .copyWith(color: Colors.grey[800])),
              ),
              const Divider(height: 0)
            ],
          );
        });
  }

  Widget buildSpeedDial() {
    return SpeedDial(
      elevation: 2,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(color: Colors.white),
      curve: Curves.linear,
      overlayColor: Colors.black,
      overlayOpacity: 0.2,
      backgroundColor: MyColors.primary,
      children: [
        SpeedDialChild(
          elevation: 2,
          label: "Add member",
          child: const Icon(Icons.person_add, color: MyColors.grey_80),
          backgroundColor: Colors.white,
          onTap: () {
            Get.to(() => EventViewSearchScreen(id: widget.id));
          },
        ),
      ],
    );
  }
}
