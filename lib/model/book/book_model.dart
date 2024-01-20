import 'package:kuuwaa/model/invitation/invitation_model.dart';

class BookModel {
  int? id;
  String? message;
  InvitationModel? invitation;

  BookModel({
    this.id,
    this.message,
    this.invitation
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    invitation = InvitationModel.fromJson(json['invitation']);
  }
}