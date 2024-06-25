import 'dart:convert';

import 'package:eventsorg_mobile_organizer/controller/state_controller.dart';
import 'package:eventsorg_mobile_organizer/data/events_data.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/model/users_model.dart';
import 'package:eventsorg_mobile_organizer/view/screens/event_view_search_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  int paginationFrom = 0;
  int paginationTo = 0;
  int paginationTotal = 0;
  String paginationPrevLink = '';
  String paginationNextLink = '';
  int paginationCurrentPage = 1;

  late Future<List<UsersModel>> usersFuture;

  @override
  void initState() {
    fetchEvent();
    fetchEventUsers(1);
    super.initState();
  }

  Future<void> fetchEventUsers(page) async {
    setState(() {
      usersFuture = getUsers(page);
    });
  }

  fetchEvent() async {
    StateController stateController = Get.find();

    var response = await EventsData().getEvent(widget.id);

    if (response == '') return;

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

  Future<List<UsersModel>> getUsers(page) async {
    var response = await EventsData().getEventUsers(widget.id, page);
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
              Get.back();
              // Navigator.pop(context);
            }),
      ),
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
                                    style: MyText.body1(context)!
                                        .copyWith(color: MyColors.grey_80)),
                                const Spacer(),
                                Expanded(
                                  flex: 6,
                                  child: Text(name,
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.visible,
                                      style: MyText.body1(context)!
                                          .copyWith(color: MyColors.grey_100_)),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("Location:",
                                    style: MyText.body1(context)!
                                        .copyWith(color: MyColors.grey_80)),
                                const Spacer(),
                                Expanded(
                                  flex: 6,
                                  child: Text(location,
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.visible,
                                      style: MyText.body1(context)!
                                          .copyWith(color: MyColors.grey_100_)),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("Start date:",
                                    style: MyText.body1(context)!
                                        .copyWith(color: MyColors.grey_80)),
                                const Spacer(),
                                Expanded(
                                  flex: 6,
                                  child: Text(startDate,
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.visible,
                                      style: MyText.body1(context)!
                                          .copyWith(color: MyColors.grey_100_)),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("End date:",
                                    style: MyText.body1(context)!
                                        .copyWith(color: MyColors.grey_80)),
                                const Spacer(),
                                Expanded(
                                  flex: 6,
                                  child: Text(endDate,
                                      softWrap: true,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.visible,
                                      style: MyText.body1(context)!
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
                            fetchEventUsers(paginationCurrentPage);
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
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isEmpty) {
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (paginationCurrentPage > 1 && paginationPrevLink != '') {
                      fetchEventUsers(paginationCurrentPage - 1);
                    }
                  },
                  icon: const Icon(Icons.arrow_left),
                  iconSize: 35,
                ),
                Text(
                  '$paginationFrom - $paginationTo of $paginationTotal items',
                  style:
                      MyText.body2(context)!.copyWith(color: MyColors.grey_90),
                ),
                IconButton(
                  onPressed: () {
                    if (paginationNextLink != '') {
                      fetchEventUsers(paginationCurrentPage + 1);
                    }
                  },
                  icon: const Icon(Icons.arrow_right),
                  iconSize: 35,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      Get.to(() => EventViewSearchScreen(id: widget.id));
                    });
                  },
                  icon: const Icon(Icons.person_add),
                  iconSize: 35,
                ),
              ],
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
}
