import 'package:get/get.dart';

class StateController extends GetxController {
  int eventId = 0;

  void updateEventId(id) {
    eventId = id;
  }
}
