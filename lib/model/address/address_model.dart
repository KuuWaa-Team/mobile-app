import 'package:kuuwaa/model/address/country_model.dart';
import 'package:kuuwaa/model/address/province_model.dart';

class AddressModel {
  int? id;
  String? number;
  String? ref;
  String? street;
  ProvinceModel? province;
  CountryModel? country;

  AddressModel({
    this.id,
    this.number,
    this.country,
    this.province,
    this.street,
    this.ref,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    ref = json['ref'];
    street = json['street'];
    if (json['province'] != null) {
      print(json["province"]);
      province = ProvinceModel.fromJson(json['province']);
    }
    if (json['country'] != null) {
      country = CountryModel.fromJson(json['country']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['street'] = street;
    data['number'] = number;
    data['ref'] = ref;

    return data;
  }
}