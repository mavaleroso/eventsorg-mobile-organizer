import 'package:eventsorg_mobile_organizer/data/img.dart';
import 'package:eventsorg_mobile_organizer/model/bottom_nav.dart';
import 'package:eventsorg_mobile_organizer/view/screens/attendance_screen.dart';
import 'package:eventsorg_mobile_organizer/view/screens/check_in_screen.dart';
import 'package:eventsorg_mobile_organizer/view/screens/event_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String emailPref = '';

  @override
  void initState() {
    super.initState();
    _loadStoredValue();
  }

  Future<void> _loadStoredValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emailPref = prefs.getString('email') ?? 'No value stored';
    });
  }

  @override
  late BuildContext context;

  int currentIndex = 0;

  final List<Widget> _screens = [
    const EventScreen(),
    const CheckInScreen(),
    const AttendanceScreen(),
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
        width: 250,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(height: 10),
                    Text(emailPref,
                        style: MyText.caption(context)!.copyWith(
                            color: MyColors.primaryDark,
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
