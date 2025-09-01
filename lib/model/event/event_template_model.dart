class EventTemplateModel {
  int? id;
  String? name;
  String? code;
  String? eventsAdapted;
  double? price;
  bool? hasAnimations;
  bool? imageRequired;
  String? imagePath;
  String? primaryColor;
  String? secondaryColor;

  EventTemplateModel({
    this.id,
    this.name,
    this.code,
    this.price,
    this.hasAnimations,
    this.eventsAdapted,
    this.imageRequired,
    this.imagePath,
    this.primaryColor,
    this.secondaryColor
  });

  EventTemplateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventsAdapted = json['eventsAdapted'];
    name = json['name'];
    hasAnimations = json['hasAnimations'];
    code = json['code'];
    price = double.parse(json['price'].toString());
    imagePath = json['imagePath'];
    imagePath = json['imagePath'];
    imageRequired = json['imageRequired'];
    primaryColor = json['primaryColor'];
    secondaryColor = json['secondaryColor'];
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
    data['imageRequired'] = imageRequired;
    data['primaryColor'] = primaryColor;
    data['secondaryColor'] = secondaryColor;
    return data;
  }
}