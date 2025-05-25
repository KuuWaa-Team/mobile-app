import 'dart:ffi';

class EventTemplateModel {
  int? id;
  String? name;
  String? code;
  String? eventsAdapted;
  double? price;
  bool? hasAnimations;
  String? imagePath;

  EventTemplateModel({
    this.id,
    this.name,
    this.code,
    this.price,
    this.hasAnimations,
    this.eventsAdapted,
    this.imagePath,
  });

  EventTemplateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventsAdapted = json['eventsAdapted'];
    name = json['name'];
    hasAnimations = json['hasAnimations'];
    code = json['code'];
    price = double.parse(json['price'].toString());
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hasAnimations'] = hasAnimations;
    data['name'] = name;
    data['eventsAdapted'] = eventsAdapted;
    data['code'] = code;
    data['price'] = price;
    data['imagePath'] = imagePath;
    return data;
  }
}