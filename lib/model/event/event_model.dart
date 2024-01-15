import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_pack_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';

class EventModel {
  int? id;
  String? name;
  DateTime? date;
  String? address;
  int? tablesCount;
  int? invitationsCount;
  int? beveragesCount;
  int? adminsCount;
  String? details;
  String? status;
  String? imagePath;
  String? paymentStatus;
  EventCategoryModel? category;
  EventPackModel? eventPack;
  bool? paidEvent;
  List<FeatureModel>? features;

  EventModel({
    this.id,
    this.name,
    this.date,
    this.address,
    this.details,
    this.status,
    this.eventPack,
    this.paymentStatus,
    this.category,
    this.adminsCount,
    this.paidEvent,
    this.imagePath,
    this.features,
    this.invitationsCount,
    this.beveragesCount,
    this.tablesCount
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = DateTime.parse(json['date'].toString());
    address = json['address'];
    details = json['details'];
    paymentStatus = json['paymentStatus'];
    status = json['status'];
    imagePath = json['imagePath'];
    paidEvent = json['paidEvent'];
    tablesCount = json['tablesCount'];
    beveragesCount = json['beveragesCount'];
    adminsCount = json['adminsCount'];
    invitationsCount = json['invitationsCount'];
    if (json['category'] != null) {
      category = EventCategoryModel.fromJson(json['category']);
    }
    if (json['eventPack'] != null) {
      eventPack = EventPackModel.fromJson(json['eventPack']);
    }
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((element) {
        features!.add(FeatureModel.fromJson(element));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['date'] = date;
    data['address'] = address;
    data['details'] = details;
    data['imagePath'] = imagePath;
    data['status'] = status;
    data['status'] = paymentStatus;
    data['paidEvent'] = paidEvent;
    data['category'] = category;
    data['eventPack'] = eventPack;
    data['features'] = features;
    data['tablesCount'] = tablesCount;
    data['beveragesCount'] = beveragesCount;
    data['invitationsCount'] = invitationsCount;
    data['adminsCount'] = adminsCount;

    return data;
  }
}