import 'package:get/get.dart';

class StateController extends GetxController {
  int eventId = 0;
  String eventStartDate = '';
  String eventName = '';
  String eventLocation = '';
  String userFullname = '';

  void updateEventId(id) {
    eventId = id;
  }

  void updateEventInfo(name, location, startDate) {
    eventName = name;
    eventLocation = location;
    eventStartDate = startDate;
  }

  void updateScannedUserInfo(fullname) {
    userFullname = fullname;
  }
}
