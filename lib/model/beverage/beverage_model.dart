import '../invitation/invitation_model.dart';

class BeverageModel {
  int? id;
  String? name;
  int? countTaken;
  List<InvitationModel>? invitations;

  BeverageModel({
    this.id,
    this.name,
    this.countTaken,
    this.invitations,
  });

  BeverageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countTaken = json['countTaken'];
    if (json['invitations'] != null) {
      json['invitations'].forEach((element) {
        invitations ??= [];
        if (element.runtimeType != String) {
          invitations?.add(InvitationModel.fromJson(element));
        } else {
          invitations?.add(InvitationModel(
            name: element
          ));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['countTaken'] = countTaken;

    return data;
  }
}