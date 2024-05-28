import 'dart:async';

import 'package:eventsorg_mobile_organizer/data/events_data.dart';
import 'package:eventsorg_mobile_organizer/data/my_colors.dart';
import 'package:eventsorg_mobile_organizer/view/screens/main_screen.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_text.dart';
import 'package:eventsorg_mobile_organizer/utils/tools.dart';
import 'package:eventsorg_mobile_organizer/view/widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EventFormScreen extends StatefulWidget {
  const EventFormScreen({super.key});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  late Future<DateTime?> selectedDate;
  String date = "-";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Event",
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
              Get.to(MainScreen());
              // Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.event),
                  border: OutlineInputBorder(),
                  labelText: 'Event Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.pin_drop),
                  border: OutlineInputBorder(),
                  labelText: 'Location',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                controller: startDateController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                  labelText: 'Start Date',
                ),
                onTap: () {
                  showDialogPicker(context, startDateController);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                readOnly: true,
                controller: endDateController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                  border: OutlineInputBorder(),
                  labelText: 'End Date',
                ),
                onTap: () {
                  showDialogPicker(context, endDateController);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary, elevation: 0),
                  child: Text("SUBMIT",
                      style:
                          MyText.body1(context)!.copyWith(color: Colors.white)),
                  onPressed: () {
                    submit(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDialogPicker(BuildContext context, controller) {
    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    selectedDate.then((value) {
      setState(() {
        if (value == null) return;
        date = Tools.convertDateTimeDisplay(value.toString(), 'yyyy-MM-dd');
        setState(() {
          controller.text = date;
        });
      });
    }, onError: (error) {
      print(error);
    });
  }

  void submit(context) async {
    var data = {
      'name': nameController.text,
      'location': locationController.text,
      'start_date': startDateController.text,
      'end_date': endDateController.text
    };

    var res = await EventsData().createEvent(data);

    if (res['code'] == 201) {
      MyToast.showCustom(
          context,
          Container(
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
                Text("Success!",
                    style: MyText.body1(context)!
                        .copyWith(color: MyColors.grey_5)),
                Container(width: 8),
              ],
            ),
          ));

      Timer(const Duration(seconds: 1), () async {
        Get.offAll(() => MainScreen());
      });
    } else {
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
                    style: MyText.body1(context)!
                        .copyWith(color: MyColors.grey_5)),
                Container(width: 8),
              ],
            ),
          ));
    }
  }
}
