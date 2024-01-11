class FeatureModel {
  int? id;
  String? name;
  double? price;
  String? description;

  FeatureModel({
    this.id,
    this.name,
    this.price,
    this.description,
  });

  FeatureModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = double.parse(json['price'].toString());
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['description'] = description;
    return data;
  }
}