import 'dart:async';
import 'dart:convert';

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
  int id;

  EventFormScreen({super.key, required this.id});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  late Future<DateTime?> selectedDate;
  bool isLoading = false;

  String date = "-";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.id != 0) fetchEvent();
    super.initState();
  }

  fetchEvent() async {
    setState(() {
      isLoading = true;
    });

    var response = await EventsData().getEvent(widget.id);
    var data = json.decode(response['data']);

    setState(() {
      nameController.text = data['data']['name'];
      locationController.text = data['data']['location'];
      startDateController.text = data['data']['start_date'];
      endDateController.text = data['data']['end_date'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id != 0 ? 'Update Event' : "Create Event",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        child: Align(
          alignment: Alignment.topCenter,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: isLoading,
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.event),
                    border: OutlineInputBorder(),
                    labelText: 'Event Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  readOnly: isLoading,
                  controller: locationController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.pin_drop),
                    border: OutlineInputBorder(),
                    labelText: 'Location',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary, elevation: 0),
                    child: isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth:
                                      2.0, // Optional: Adjust the thickness of the progress indicator
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                  widget.id != 0
                                      ? 'UPDATING...'
                                      : 'SUBMITTING...',
                                  style: MyText.body1(context)!
                                      .copyWith(color: Colors.white)),
                            ],
                          )
                        : Text(widget.id != 0 ? "UPDATE" : "SUBMIT",
                            style: MyText.body1(context)!
                                .copyWith(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        submit(context);
                      }
                    },
                  ),
                )
              ],
            ),
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
    setState(() {
      isLoading = true;
    });

    var data = {
      'name': nameController.text,
      'location': locationController.text,
      'start_date': startDateController.text,
      'end_date': endDateController.text
    };

    var res = widget.id != 0
        ? await EventsData().updateEvent(widget.id, data)
        : await EventsData().createEvent(data);

    if (res['code'] == 200 || res['code'] == 201) {
      MyToast.showCustom(
          context,
          Container(
            height: 50,
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
                Text("Successfully created!",
                    style: MyText.body1(context)!
                        .copyWith(color: MyColors.grey_5)),
                Container(width: 8),
              ],
            ),
          ));

      Timer(const Duration(seconds: 1), () async {
        Get.offAll(() => MainScreen(
              currentIndex: 0,
              eventId: 0,
            ));
      });
    } else {
      MyToast.showCustom(
          context,
          Container(
            height: 50,
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

      if (res['code'] == 422) {}
    }

    setState(() {
      isLoading = false;
    });
  }
}
