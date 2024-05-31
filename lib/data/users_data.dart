import 'package:eventsorg_mobile_organizer/context/api.dart';
import 'package:intl/intl.dart';

class UsersData {
  getNonParticipatingUsersList() async {
    var res =
        await CallApi().getData('non-participating-users?page=1&limit=10');
    return res;
  }

  getEventsUsers(id) async {
    var res = await CallApi().getData('events/$id/users');
    return res;
  }
}
