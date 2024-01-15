class EventAdminModel {
  int? id;
  String? phoneNumber;
  String? status;
  String? name;

  EventAdminModel({
    this.id,
    this.phoneNumber,
    this.name,
  });

  EventAdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    status = json['status'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['status'] = status;
    data['name'] = name;
    return data;
  }
}