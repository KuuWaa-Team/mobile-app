import 'dart:convert';

import 'package:kuuwaa/model/address/address_model.dart';
import 'package:kuuwaa/model/beverage/beverage_model.dart';
import 'package:kuuwaa/model/book/book_model.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_pack_model.dart';
import 'package:kuuwaa/model/event/event_specification_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';

class EventModel {
  int? id;
  String? name;
  DateTime? date;
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
  String? thumbPath;
  String? paymentStatus;
  List? featureSlugs;
  EventCategoryModel? category;
  EventPackModel? eventPack;
  bool? paidEvent;
  List<FeatureModel>? features;
  List<EventSpecificationModel>? specifications;
  List<BeverageModel>? beverages;
  List<BookModel>? books;
  AddressModel? address;

  EventModel({
    this.id,
    this.name,
    this.date,
    this.beverages,
    this.featureSlugs,
    this.books,
    this.specifications,
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
    this.thumbPath,
    this.features,
    this.invitationsCount,
    this.beveragesCount,
    this.tablesCount
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = DateTime.parse(json['date'].toString());
    details = json['details'];
    adminStatus = json['adminStatus'];
    paymentStatus = json['paymentStatus'];
    status = json['status'];
    imagePath = json['imagePath'];
    thumbPath = json['thumbPath'];
    paidEvent = json['paidEvent'];
    shared = json['shared'];
    if (json['featureslugs'] != null) {
      featureSlugs = jsonDecode(json['featureslugs']);
    }
    if (json['eventSpecifications'] != null) {
      specifications = jsonDecode(json['eventSpecifications']);
    }
    tablesCount = json['tablesCount'];
    beveragesCount = json['beveragesCount'];
    adminsCount = json['adminsCount'];
    invitationsCount = json['invitationsCount'];
    adminId = json['adminId'];
    if (json['category'] != null) {
      category = EventCategoryModel.fromJson(json['category']);
    }
    if (json['address'] != null) {
      address = AddressModel.fromJson(json['address']);
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
    if (json['beverages'] != null) {
      beverages = [];
      json['beverages'].forEach((element) {
        beverages!.add(BeverageModel.fromJson(element));
      });
    }

    if (json['books'] != null) {
      books = [];
      json['books'].forEach((element) {
        books?.add(BookModel.fromJson(element));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['date'] = date;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['details'] = details;
    data['imagePath'] = imagePath;
    data['thumbPath'] = thumbPath;
    data['status'] = status;
    data['status'] = paymentStatus;
    data['paidEvent'] = paidEvent;
    data['category'] = category;
    data['adminStatus'] = adminStatus;
    data['adminId'] = adminId;
    data['eventPack'] = eventPack;
    data['features'] = features;
    data['eventSpecifications'] = specifications;
    data['shared'] = shared;
    data['tablesCount'] = tablesCount;
    data['beveragesCount'] = beveragesCount;
    data['invitationsCount'] = invitationsCount;
    data['adminsCount'] = adminsCount;

    return data;
  }
}