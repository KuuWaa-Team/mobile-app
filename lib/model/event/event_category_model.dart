class EventCategoryModel {
  int? id;
  String? name;

  EventCategoryModel({
    this.id,
    this.name,
  });

  EventCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EventCategoryModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}