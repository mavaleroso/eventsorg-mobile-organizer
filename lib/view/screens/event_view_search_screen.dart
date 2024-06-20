import 'dart:convert';

import 'package:eventsorg_mobile_organizer/controller/state_controller.dart';
import 'package:eventsorg_mobile_organizer/data/events_data.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/data/users_data.dart';
import 'package:eventsorg_mobile_organizer/model/users_model.dart';
import 'package:eventsorg_mobile_organizer/view/screens/breakfast_stub.dart';
import 'package:eventsorg_mobile_organizer/view/screens/event_view_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EventViewSearchScreen extends StatefulWidget {
  int id;
  EventViewSearchScreen({super.key, required this.id});

  @override
  _EventViewSearchScreenState createState() => _EventViewSearchScreenState();
}

class _EventViewSearchScreenState extends State<EventViewSearchScreen> {
  bool finishLoading = true;
  bool showClear = false;
  TextEditingController inputController = TextEditingController();

  late Future<List<UsersModel>> usersFuture;
  List<UsersModel> users = [];
  List<SearchResult> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchUsersData();
  }

  Future<void> fetchUsersData() async {
    setState(() {
      usersFuture = getUsers();
      usersFuture.then((data) {
        setState(() {
          users = data;
          searchResults = data
              .map((users) => SearchResult(users: users, isMatch: true))
              .toList();
        });
      });
    });
  }

  void search(String query) {
    final results = searchPeople(users, query);
    setState(() {
      searchResults = results;
    });
  }

  List<SearchResult> searchPeople(List<UsersModel> users, String query) {
    final pattern = RegExp(query, caseSensitive: false);
    return users
        .map((users) {
          final fullName = '${users.firstName} ${users.lastName}'.toLowerCase();
          final isMatch = pattern.hasMatch(fullName);
          return SearchResult(users: users, isMatch: isMatch);
        })
        .where((result) => result.isMatch)
        .toList();
  }

  Future<List<UsersModel>> getUsers() async {
    var response = await UsersData().getNonParticipatingUsersList();
    var data = json.decode(response['data']);
    List body = data['data'];
    return body.map((e) => UsersModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.grey[400]),
        backgroundColor: Colors.white,
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: TextStyle(color: Colors.grey[800], fontSize: 18),
          keyboardType: TextInputType.text,
          onSubmitted: (term) {
            setState(() {
              finishLoading = false;
            });
            delayShowingContent();
          },
          onChanged: (term) {
            search(term);
            setState(() {
              showClear = (term.length > 2);
            });
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(fontSize: 20.0),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyColors.grey_90),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          showClear
              ? IconButton(
                  icon: const Icon(Icons.close, color: MyColors.grey_90),
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    fetchUsersData();
                  },
                )
              : Container(),
        ],
      ),
      body: FutureBuilder(
        future: usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoading(context);
          } else if (snapshot.hasData && searchResults.isNotEmpty) {
            var users = snapshot.data!;
            return buildContent(users);
          } else if (searchResults.isEmpty) {
            return buildContentEmpty(context);
          } else {
            return buildContentEmpty(context);
          }
        },
      ),
    );
  }

  Widget buildContent(List<UsersModel> users) {
    StateController stateController = Get.find();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final result = searchResults[index];
              return Card(
                  color: MyColors.grey_3,
                  elevation: 1.0,
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                onTap: () {
                                  stateController.updateScannedUserInfo(
                                      '${result.users.firstName} ${result.users.lastName}');
                                  addMember(
                                      context, widget.id, result.users.idNo);
                                },
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                leading: const Icon(Icons.person),
                                title: Text(
                                    '${result.users.firstName ?? ''} ${result.users.lastName ?? ''}',
                                    style: MyText.body1(context)!
                                        .copyWith(color: Colors.grey[800])),
                              ),
                            ],
                          )),
                    ],
                  ));
            },
          ),
        ),
      ],
    );
  }

  Widget buildLoading(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget buildContentEmpty(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 180,
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("No result",
                style: MyText.headline(context)!.copyWith(
                    color: Colors.grey[500], fontWeight: FontWeight.bold)),
            Container(height: 5),
            Text("Try input more general keyword",
                textAlign: TextAlign.center,
                style:
                    MyText.body1(context)!.copyWith(color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  void delayShowingContent() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        finishLoading = true;
      });
    });
  }

  void addMember(context, eventId, userIdNo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm action"),
          content: const Text("Are you sure you want to add this user?"),
          actions: <Widget>[
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('YES'),
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
                Get.to(() => BreakfastStub(code: userIdNo));
              },
            )
          ],
        );
      },
    );
  }
}
