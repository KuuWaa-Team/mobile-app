class EventAdminModel {
  int? id;
  String? phoneNumber;
  String? status;
  String? invitationCode;
  String? roles;
  String? name;

  EventAdminModel({
    this.id,
    this.phoneNumber,
    this.name,
    this.roles,
    this.invitationCode,
  });

  EventAdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    status = json['status'];
    roles = json['roles'];
    invitationCode = json['invitationCode'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['status'] = status;
    data['roles'] = roles;
    data['invitationCode'] = invitationCode;
    data['name'] = name;
    return data;
  }
}