class GameAssertionModel {
  int? id;
  String? text;
  bool? isCorrect;

  GameAssertionModel({this.id, this.text, this.isCorrect});

  GameAssertionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    isCorrect = json['isCorrect'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isCorrect': isCorrect,
  };
}