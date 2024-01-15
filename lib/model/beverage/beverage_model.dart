import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_pack_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';

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
        invitations?.add(InvitationModel.fromJson(element));
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