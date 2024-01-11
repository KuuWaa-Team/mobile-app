import 'dart:ffi';

class EventPackModel {
  int? id;
  String? name;
  double? price;
  int? maxTickets;

  EventPackModel({
    this.id,
    this.name,
    this.price,
    this.maxTickets,
  });

  EventPackModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = double.parse(json['price'].toString());
    maxTickets = json['maxTickets'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['maxTickets'] = maxTickets;
    return data;
  }
}