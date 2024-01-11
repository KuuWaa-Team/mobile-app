class UserModel {
  int? id;
  String? phoneNumber;
  String? firstname;
  String? lastname;
  String? address;
  bool? otpVerified;
  String? token;

  UserModel({
    this.id,
    this.phoneNumber,
    this.firstname,
    this.lastname,
    this.address,
    this.token,
    this.otpVerified
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    address = json['address'];
    token = json['token'];
    otpVerified = json['otpVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['address'] = address;
    return data;
  }
}