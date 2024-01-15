import 'package:kuuwaa/model/event/event_model.dart';

import '../table/table_model.dart';

class InvitationModel {
  int? id;
  String? name;
  String? civility;
  String? status;
  int? count;
  String? phoneNumber;
  TableModel? table;
  EventModel? event;

  InvitationModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.count,
    this.civility,
    this.table,
    this.event
  });

  InvitationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    civility = json['civility'];
    count = json['count'];
    status = json['status'];
    phoneNumber = json['phoneNumber'];
    if (json['invitationTable'] != null && json['invitationTable'].runtimeType.toString() != "String") {
      table = TableModel.fromJson(json['invitationTable']);
    }
    if (json['event'] != null) {
      event = EventModel.fromJson(json['event']);
    }
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