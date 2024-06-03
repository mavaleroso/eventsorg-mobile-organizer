import 'package:eventsorg_mobile_organizer/context/api.dart';

class AttendanceData {
  getAttendanceList(page, eventId) async {
    var res = await CallApi().getData(
        'attendance?page=$page&limit=10&event_id=$eventId&status=today');
    print(res);
    return res;
  }
}
