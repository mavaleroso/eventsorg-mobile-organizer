class EventsModel {
  int? id;
  String? name;
  String? location;
  String? startDate;
  String? endDate;

  EventsModel(
      {this.id, this.name, this.location, this.startDate, this.endDate});

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      name: json['name'],
      location: json['location'],
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }

  void reset() {
    id = 0;
    name = '';
    location = '';
    startDate = '';
    endDate = '';
  }
}
