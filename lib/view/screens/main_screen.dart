import 'package:eventsorg_mobile_organizer/context/api.dart';
import 'package:eventsorg_mobile_organizer/controller/state_controller.dart';
import 'package:eventsorg_mobile_organizer/data/img.dart';
import 'package:eventsorg_mobile_organizer/model/bottom_nav.dart';
import 'package:eventsorg_mobile_organizer/view/screens/attendance_screen.dart';
import 'package:eventsorg_mobile_organizer/view/screens/check_in_screen.dart';
import 'package:eventsorg_mobile_organizer/view/screens/event_screen.dart';
import 'package:eventsorg_mobile_organizer/view/screens/login_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/my_colors.dart';
import '../widgets/my_toast.dart';

class MainScreen extends StatefulWidget {
  int currentIndex = 0;
  int eventId = 0;
  MainScreen({super.key, required this.currentIndex, required this.eventId});

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

  _logout() async {
    var res = await CallApi().postData({}, 'logout');
    if (res['code'] == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('email');
      prefs.remove('token');
      Get.to(() => const LoginScreen());
    } else {
      logoutToastError();
    }
  }

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

  String title = 'Events';

  final List<Widget> _screens = [
    const EventScreen(),
    const CheckInScreen(),
    const AttendanceScreen(),
  ];

  static List<String> titles = <String>[
    'Events',
    'Check-in',
    'Attendance',
  ];

  @override
  Widget build(BuildContext context) {
    Get.put(StateController());

    final StateController stateController = Get.find();

    this.context = context;
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(
            titles[widget.currentIndex],
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
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Navigator.pop(context);
                scaffoldKey.currentState!.openDrawer();
              }),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
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
                          style: MyText.medium(context)!.copyWith(
                              color: MyColors.primaryDark,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Container(height: 8),
                InkWell(
                  onTap: () {
                    _logout();
                  },
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
        body: _screens[widget.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: MyColors.primary,
          unselectedItemColor: MyColors.grey_40,
          currentIndex: widget.currentIndex,
          onTap: (int index) {
            stateController.updateEventId(0);

            setState(() {
              widget.currentIndex = index;
            });
          },
          items: widget.itemsNav.map((BottomNav d) {
            stateController.updateEventId(widget.eventId);

            return BottomNavigationBarItem(
              icon: Icon(d.icon),
              label: d.title,
            );
          }).toList(),
        ),
      ),
    );
  }

  void logoutToastError() {
    MyToast.showCustom(
        context,
        Container(
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
              Text("Error encountered!",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_5)),
              Container(width: 8),
            ],
          ),
        ));
  }
}
