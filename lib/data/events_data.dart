import 'package:eventsorg_mobile_organizer/context/api.dart';
import 'package:intl/intl.dart';

class EventsData {
  getEventsList(page) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    var res = await CallApi().getData(
        'events?start_date=$formattedDate&end_date=$formattedDate&page=$page&limit=10');
    return res;
  }

  createEvent(data) async {
    var res = await CallApi().postData(data, 'events');
    return res;
  }
}
