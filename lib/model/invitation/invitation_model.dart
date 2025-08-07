import 'package:kuuwaa/model/beverage/beverage_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';

import '../table/table_model.dart';

class InvitationModel {
  int? id;
  String? name;
  String? civility;
  String? status;
  String? musicChoice;
  int? count;
  String? phoneNumber;
  String? slug;
  String? message;
  bool? bookSent;
  bool? willBePresent;
  bool? musicPlayed;
  String? codePath;
  String? code;
  String? decryptKey;
  BeverageModel? beverage;
  TableModel? table;
  EventModel? event;

  InvitationModel({
    this.id,
    this.name,
    this.musicChoice,
    this.phoneNumber,
    this.slug,
    this.bookSent,
    this.willBePresent,
    this.beverage,
    this.message,
    this.decryptKey,
    this.musicPlayed,
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
    willBePresent = json['willBePresent'];
    slug = json['slug'];
    musicPlayed = json['musicPlayed'];
    civility = json['civility'];
    musicChoice = json['musicChoice'];
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
    data['slug'] = slug;
    data['code'] = code;
    data['musicPlayed'] = musicPlayed;
    data['musicChoice'] = musicChoice;
    data['bookSent'] = bookSent;
    data['decryptKey'] = decryptKey;
    data['codePath'] = codePath;
    data['count'] = count;
    data['willBePresent'] = willBePresent;
    data['status'] = status;
    data['phoneNumber'] = phoneNumber;
    data['message'] = message;

    return data;
  }
}