import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:kuuwaa/model/address/address_model.dart';
import 'package:kuuwaa/model/beverage/beverage_model.dart';
import 'package:kuuwaa/model/book/book_model.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_pack_model.dart';
import 'package:kuuwaa/model/event/event_specification_model.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';

class EventModel {
  int? id;
  String? title;
  DateTime? startDate;
  DateTime? endDate;
  int? tablesCount;
  int? invitationsCount;
  bool? shared;
  int? beveragesCount;
  int? adminsCount;
  int? adminId;
  String? details;
  String? imagePath;
  String? thumbPath;
  EventCategoryModel? category;
  EventTemplateModel? template;
  bool? paidEvent;
  List<EventSpecificationModel>? specifications;
  List<BeverageModel>? beverages;
  List<BookModel>? books;
  String? address;
  String? placeName;
  bool? hasTables;
  bool? hasBeverage;
  bool? hasBook;

  EventModel({
    this.id,
    this.title,
    this.startDate,
    this.endDate,
    this.beverages,
    this.books,
    this.specifications,
    this.address,
    this.details,
    this.shared,
    this.adminId,
    this.category,
    this.adminsCount,
    this.paidEvent,
    this.imagePath,
    this.thumbPath,
    this.invitationsCount,
    this.beveragesCount,
    this.tablesCount,
    this.template,
    this.placeName,
    this.hasTables,
    this.hasBeverage,
    this.hasBook
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startDate = DateTime.parse(json['startDate'].toString());
    endDate = DateTime.parse(json['endDate'].toString());
    details = json['details'];
    placeName = json['placeName'];
    imagePath = json['imagePath'];
    thumbPath = json['thumbPath'];
    paidEvent = json['paidEvent'];
    hasBook = json['hasBook'];
    hasBeverage = json['hasBeverage'];
    hasTables = json['hasTables'];
    shared = json['shared'];
    if (json['eventSpecifications'] != null) {
      specifications ??= [];
      for (var spec in json['eventSpecifications']) {
        specifications!.add(EventSpecificationModel.fromJson(spec));
      }
    }
    tablesCount = json['tablesCount'];
    beveragesCount = json['beveragesCount'];
    adminsCount = json['adminsCount'];
    invitationsCount = json['invitationsCount'];
    adminId = json['adminId'];
    address = json['address'];
    if (json['category'] != null) {
      category = EventCategoryModel.fromJson(json['category']);
    }
    if (json['template'] != null) {
      template = EventTemplateModel.fromJson(json['template']);
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
    data['title'] = title;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['details'] = details;
    data['address'] = address;
    data['placeName'] = placeName;
    data['imagePath'] = imagePath;
    data['thumbPath'] = thumbPath;
    data['paidEvent'] = paidEvent;
    data['category'] = category;
    data['adminId'] = adminId;
    data['eventSpecifications'] = specifications;
    data['shared'] = shared;
    data['tablesCount'] = tablesCount;
    data['beveragesCount'] = beveragesCount;
    data['invitationsCount'] = invitationsCount;
    data['adminsCount'] = adminsCount;
    data['hasTables'] = hasTables;
    data['hasBeverage'] = hasBeverage;
    data['hasBook'] = hasBook;

    return data;
  }

  String formattedDate({String locale = 'fr_FR'}) {
    if (startDate == null || endDate == null) return "";

    final dateFormat = DateFormat.yMMMMEEEEd(locale);
    final shortFormat = DateFormat.yMMMMd(locale);

    if (startDate!.year == endDate!.year &&
        startDate!.month == endDate!.month &&
        startDate!.day == endDate!.day) {
      return dateFormat.format(startDate!);
    } else {
      return 'Du ${shortFormat.format(startDate!)} au ${shortFormat.format(endDate!)}';
    }
  }

  String formattedHour() {
    if (startDate == null || endDate == null) return "";

    final hourFormat = DateFormat.Hm();
    return 'De ${hourFormat.format(startDate!)} à ${hourFormat.format(endDate!)}';
  }

}