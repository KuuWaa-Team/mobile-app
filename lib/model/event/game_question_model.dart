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