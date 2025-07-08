import 'package:kuuwaa/model/invitation/invitation_model.dart';

class BookModel {
  int? id;
  String? message;
  bool? public;
  String? audioPath;
  InvitationModel? invitation;

  BookModel({
    this.id,
    this.message,
    this.audioPath,
    this.public,
    this.invitation
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    audioPath = json['audioPath'];
    public = json['public'];
    invitation = InvitationModel.fromJson(json['invitation']);
  }
}