import 'package:eventsorg_mobile_organizer/context/api.dart';
import 'package:eventsorg_mobile_organizer/view/screens/event_screen.dart';

class EventsData {
  getEventsList(page) async {
    var res = await CallApi().getData('events?page=$page&limit=10');
    print(res);
    return res;
  }
}
