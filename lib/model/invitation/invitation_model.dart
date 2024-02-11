import 'package:kuuwaa/model/beverage/beverage_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';

import '../table/table_model.dart';

class InvitationModel {
  int? id;
  String? name;
  String? civility;
  String? status;
  int? count;
  String? phoneNumber;
  String? message;
  bool? bookSent;
  String? codePath;
  String? code;
  String? decryptKey;
  BeverageModel? beverage;
  TableModel? table;
  EventModel? event;

  InvitationModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.bookSent,
    this.beverage,
    this.message,
    this.decryptKey,
    this.count,
    this.civility,
    this.table,
    this.code,
    this.codePath,
    this.event
  });

  InvitationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    civility = json['civility'];
    bookSent = json['bookSent'];
    if (json['beverage'] != null) {
      beverage = BeverageModel.fromJson(json['beverage']);
    }
    decryptKey = json['decryptKey'];
    count = json['count'];
    code = json['code'];
    message = json['message'];
    status = json['status'];
    codePath = json['codePath'];
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
    data['code'] = code;
    data['bookSent'] = bookSent;
    data['decryptKey'] = decryptKey;
    data['codePath'] = codePath;
    data['count'] = count;
    data['status'] = status;
    data['phoneNumber'] = phoneNumber;
    data['message'] = message;

    return data;
  }
}