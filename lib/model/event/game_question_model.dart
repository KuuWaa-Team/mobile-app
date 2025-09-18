import 'game_assertion_model.dart';

class GameQuestionModel {
  int? id;
  String? title;
  int? position;
  List<GameAssertionModel>? assertions;

  GameQuestionModel({this.id, this.title, this.position, this.assertions});

  GameQuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    position = json['position'];
    if (json['assertions'] != null) {
      assertions = (json['assertions'] as List)
          .map((e) => GameAssertionModel.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'position': position,
        'assertions': assertions?.map((e) => e.toJson()).toList(),
      };
}

class GameResultModel {
  String? name;
  double? percentage;
  DateTime? date;

  GameResultModel({
    required this.name,
    required this.percentage,
    required this.date,
  });

  GameResultModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['percentage'] != null) {
      percentage = double.parse(json['percentage'].toString());
    }
    if (json['date'] != null && json['date']['date'] != null) {
      date = DateTime.parse(json['date']['date']);
    }
  }

  String get dateTimeFormatted {
    return "${date?.day}/${date?.month}/${date?.year} ${date?.hour}:${date?.minute.toString().padLeft(2, '0')}";
  }
}
