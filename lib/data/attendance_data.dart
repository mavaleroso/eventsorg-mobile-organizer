import 'package:eventsorg_mobile_organizer/context/api.dart';

class AttendanceData {
  getAttendanceList(page, eventId) async {
    var res = await CallApi().getData(
        'attendance?page=$page&limit=10&event_id=$eventId&status=today');
    return res;
  }

  admitUser(type, eventId, code, isPaid) async {
    var data = {
      'event_id': eventId,
      'id_no': type == 'qr' ? code : null,
      'plate_no': type != 'qr' ? code : null,
      'is_paid': isPaid
    };

    print(data);

    var res = await CallApi().postData(data, 'admit');

    return res;
  }
}
