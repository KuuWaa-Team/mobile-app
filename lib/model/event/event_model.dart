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
  bool? shared;
  int? beveragesCount;
  int? adminsCount;
  int? adminId;
  String? details;
  String? status;
  String? adminStatus;
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
    this.shared,
    this.adminId,
    this.status,
    this.adminStatus,
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
    adminStatus = json['adminStatus'];
    paymentStatus = json['paymentStatus'];
    status = json['status'];
    imagePath = json['imagePath'];
    paidEvent = json['paidEvent'];
    shared = json['shared'];
    tablesCount = json['tablesCount'];
    beveragesCount = json['beveragesCount'];
    adminsCount = json['adminsCount'];
    invitationsCount = json['invitationsCount'];
    adminId = json['adminId'];
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
    data['adminStatus'] = adminStatus;
    data['adminId'] = adminId;
    data['eventPack'] = eventPack;
    data['features'] = features;
    data['shared'] = shared;
    data['tablesCount'] = tablesCount;
    data['beveragesCount'] = beveragesCount;
    data['invitationsCount'] = invitationsCount;
    data['adminsCount'] = adminsCount;

    return data;
  }
}