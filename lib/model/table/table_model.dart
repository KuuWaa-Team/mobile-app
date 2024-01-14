import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_pack_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';

import '../invitation/invitation_model.dart';

class TableModel {
  int? id;
  String? name;
  int? count;
  int? countTaken;
  List<InvitationModel>? invitations;

    TableModel({
    this.id,
    this.name,
    this.count,
    this.countTaken,
    this.invitations,
  });

  TableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
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
    data['count'] = count;
    data['countTaken'] = countTaken;

    return data;
  }
}