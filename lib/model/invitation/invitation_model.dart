class InvitationModel {
  int? id;
  String? name;
  String? civility;
  String? status;
  int? count;
  String? phoneNumber;

  InvitationModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.count,
    this.civility,
  });

  InvitationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    civility = json['civility'];
    count = json['count'];
    status = json['status'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['civility'] = civility;
    data['count'] = count;
    data['status'] = status;
    data['phoneNumber'] = phoneNumber;

    return data;
  }
}