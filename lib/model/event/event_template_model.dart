import 'dart:ffi';

class EventTemplateModel {
  int? id;
  String? name;
  String? code;
  double? price;
  String? imagePath;

  EventTemplateModel({
    this.id,
    this.name,
    this.code,
    this.price,
    this.imagePath,
  });

  EventTemplateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    price = json['price'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['price'] = price;
    data['imagePath'] = imagePath;
    return data;
  }
}