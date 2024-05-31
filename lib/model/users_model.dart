class UsersModel {
  int? id;
  String? idNo;
  String? email;
  String? firstName;
  String? middleName;
  String? lastName;
  String? suffix;
  String? nickname;
  String? gender;
  String? birthdate;
  String? viberNo;
  String? city;
  String? status;
  String? position;
  int? endorserId;
  String? membershipDate;
  String? photo;

  UsersModel(
      {this.id,
      this.idNo,
      this.email,
      this.firstName,
      this.middleName,
      this.lastName,
      this.suffix,
      this.nickname,
      this.gender,
      this.birthdate,
      this.viberNo,
      this.city,
      this.status,
      this.position,
      this.endorserId,
      this.photo});

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json['id'],
      idNo: json['id_no'],
      email: json['email'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      suffix: json['suffix'],
      nickname: json['nickname'],
      gender: json['gender'],
      birthdate: json['birthdate'],
      viberNo: json['viber_no'],
      city: json['city'],
      status: json['status'],
      position: json['position'],
      endorserId: json['endorser_id'],
      photo: json['photo'],
    );
  }
}

class SearchResult {
  final UsersModel users;
  final bool isMatch;

  SearchResult({required this.users, required this.isMatch});
}
