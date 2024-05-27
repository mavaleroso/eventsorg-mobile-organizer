class EventsModel {
  int? id;
  String? name;
  String? location;
  String? startDate;
  String? endDate;

  EventsModel({this.id, this.name, this.startDate, this.endDate});

  EventsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }
}
