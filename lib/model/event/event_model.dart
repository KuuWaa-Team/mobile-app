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
import 'package:kuuwaa/model/event/game_question_model.dart';

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
  bool? canSendInvitations;
  String? imagePath;
  String? thumbPath;
  String? placeLongitude;
  String? placeLatitude;
  EventCategoryModel? category;
  EventTemplateModel? template;
  bool? paidEvent;
  List<EventSpecificationModel>? specifications;
  List<BeverageModel>? beverages;
  List<BookModel>? books;
  List<GameQuestionModel>? questions;
  String? address;
  String? placeName;
  bool? hasTables;
  bool? hasBeverage;
  bool? hasBook;

  EventModel({
    this.id,
    this.title,
    this.startDate,
    this.canSendInvitations,
    this.endDate,
    this.beverages,
    this.books,
    this.specifications,
    this.address,
    this.details,
    this.shared,
    this.questions,
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
    this.placeLatitude,
    this.placeLongitude,
    this.hasBeverage,
    this.hasBook
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    title = json['title'];
    startDate = DateTime.parse(json['startDate'].toString());
    if (json['endDate'] != null && json['endDate'].toString().toUpperCase() != "null") {
      endDate = DateTime.parse(json['endDate'].toString());
    }
    details = json['details'];
    canSendInvitations = json['canSendInvitations'];
    placeName = json['placeName'];
    imagePath = json['imagePath'];
    thumbPath = json['thumbPath'];
    paidEvent = json['paidEvent'];
    hasBook = json['hasBook'];
    placeLongitude = json['placeLongitude'];
    placeLatitude = json['placeLatitude'];
    hasBeverage = json['hasBeverage'];
    hasTables = json['hasTables'];
    shared = json['shared'];
    if (json['eventSpecifications'] != null) {
      specifications ??= [];
      for (var spec in json['eventSpecifications']) {
        specifications!.add(EventSpecificationModel.fromJson(spec));
      }
    }
    if (json['questions'] != null) {
      questions ??= [];
      for (var question in json['questions']) {
        questions!.add(GameQuestionModel.fromJson(question));
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
    data['placeLongitude'] = placeLongitude;
    data['placeLongitude'] = placeLongitude;
    data['category'] = category;
    data['adminId'] = adminId;
    data['eventSpecifications'] = specifications;
    data['canSendInvitations'] = canSendInvitations;
    data['shared'] = shared;
    data['tablesCount'] = tablesCount;
    data['beveragesCount'] = beveragesCount;
    data['invitationsCount'] = invitationsCount;
    data['adminsCount'] = adminsCount;
    data['hasTables'] = hasTables;
    data['hasBeverage'] = hasBeverage;
    data['hasBook'] = hasBook;
    data['questions'] = questions;

    return data;
  }

  String formattedDate({String locale = 'fr_FR'}) {
    if (startDate == null && endDate == null) return "";

    final dayFormat = DateFormat.d(locale);
    final monthFormat = DateFormat.MMMM(locale);
    final yearFormat = DateFormat.y(locale);
    final fullDateFormat = DateFormat.yMMMMEEEEd(locale);
    final shortFormat = DateFormat.yMMMMd(locale);

    if (endDate != null) {
      if (startDate!.year == endDate!.year &&
          startDate!.month == endDate!.month &&
          startDate!.day == endDate!.day) {
        return fullDateFormat.format(startDate!);
      } else if (startDate!.year == endDate!.year &&
          startDate!.month == endDate!.month) {
        return 'Du ${dayFormat.format(startDate!)} au ${dayFormat.format(endDate!)} ${monthFormat.format(startDate!)} ${yearFormat.format(startDate!)}';
      } else if (startDate!.year == endDate!.year) {
        return 'Du ${dayFormat.format(startDate!)} ${monthFormat.format(startDate!)} au ${dayFormat.format(endDate!)} ${monthFormat.format(endDate!)} ${yearFormat.format(startDate!)}';
      } else {
        return 'Du ${shortFormat.format(startDate!)} au ${shortFormat.format(endDate!)}';
      }
    } else {
      return dayFormat.format(startDate!) + " " + monthFormat.format(startDate!) + " " + yearFormat.format(startDate!);
    }
  }


  String formattedHour() {
    if (startDate == null || endDate == null) return "";

    final hourFormat = DateFormat.Hm();
    return 'De ${hourFormat.format(startDate!)} à ${hourFormat.format(endDate!)}';
  }

}