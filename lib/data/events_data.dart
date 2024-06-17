import 'package:eventsorg_mobile_organizer/context/api.dart';
import 'package:intl/intl.dart';

class EventsData {
  getEventsList(page) async {
    var res = await CallApi().getData('events?page=$page&limit=10');
    return res;
  }

  createEvent(data) async {
    var res = await CallApi().postData(data, 'events');
    return res;
  }

  getEvent(id) async {
    var res = await CallApi().getData('events/$id');
    return res;
  }

  getEventUsers(id) async {
    var res = await CallApi().getData('events/$id/users');
    return res;
  }

  updateEvent(id, data) async {
    var res = await CallApi().putData(data, 'events/$id');
    return res;
  }

  deleteEvent(id) async {
    var res = await CallApi().deleteData('events/$id');
    return res;
  }

  getNonParticipatingUsersList() async {
    var res =
        await CallApi().getData('non-participating-users?page=1&limit=10');
    return res;
  }

  joinMember(data) async {
    var res = await CallApi().postData(data, 'join');
    return res;
  }
}
