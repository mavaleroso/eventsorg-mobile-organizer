import 'package:eventsorg_mobile_organizer/data/img.dart';
import 'package:eventsorg_mobile_organizer/model/bottom_nav.dart';
import 'package:eventsorg_mobile_organizer/view/screens/attendance_screen.dart';
import 'package:eventsorg_mobile_organizer/view/screens/check_in_screen.dart';
import 'package:eventsorg_mobile_organizer/view/screens/event_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/my_colors.dart';
import '../widgets/my_toast.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  final List<BottomNav> itemsNav = <BottomNav>[
    BottomNav('Events', Icons.event, null),
    BottomNav('Check-in', Icons.qr_code, null),
    BottomNav('Attendance', Icons.person, null)
  ];

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late BuildContext context;
  int currentIndex = 0;
  @override
  final List<Widget> _screens = [
    EventScreen(),
    CheckInScreen(),
    AttendanceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[900],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.blue[900],
        ),
        leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Navigator.pop(context);
              scaffoldKey.currentState!.openDrawer();
            }),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(height: 30),
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: MyColors.grey_20,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage(Img.get("photo_male_6.jpg")),
                      ),
                    ),
                    Container(height: 7),
                    Text("Evans Collins",
                        style: MyText.body2(context)!.copyWith(
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.w500)),
                    Container(height: 2),
                    Text("evan.collins@mail.com",
                        style: MyText.caption(context)!.copyWith(
                            color: MyColors.grey_20,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Container(height: 8),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.domain,
                          color: MyColors.grey_20, size: 20),
                      Container(width: 20),
                      Expanded(
                          child: Text("Home",
                              style: MyText.body2(context)!
                                  .copyWith(color: MyColors.grey_80))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.menu, color: MyColors.grey_20, size: 20),
                      Container(width: 20),
                      Expanded(
                          child: Text("Settings",
                              style: MyText.body2(context)!
                                  .copyWith(color: MyColors.grey_80))),
                    ],
                  ),
                ),
              ),
              Container(height: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.power_settings_new,
                          color: MyColors.grey_20, size: 20),
                      Container(width: 20),
                      Expanded(
                          child: Text("Logout",
                              style: MyText.body2(context)!
                                  .copyWith(color: MyColors.grey_80))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: MyColors.primary,
        unselectedItemColor: MyColors.grey_40,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: widget.itemsNav.map((BottomNav d) {
          return BottomNavigationBarItem(
            icon: Icon(d.icon),
            label: d.title,
          );
        }).toList(),
      ),
    );
  }
}
