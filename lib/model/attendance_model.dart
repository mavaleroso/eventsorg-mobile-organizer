class AttendanceModel {
  String? name;
  String? nickname;
  String? checkinTime;
  String? status;

  AttendanceModel({this.name, this.nickname, this.checkinTime, this.status});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      name: json['name'],
      nickname: json['nickname'],
      checkinTime: json['checkin_time'],
      status: json['status'],
    );
  }
}
