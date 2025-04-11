import 'package:kuuwaa/model/user/user_model.dart';

class OperationModel {
  int? id;
  String? type;
  int? credits;
  String? amount;
  DateTime? date;
  String? title;
  String? paymentMethod;
  String? phoneNumber;
  String? reference;
  String? orderNumber;
  String? status;
  UserModel? user;

  OperationModel({
    this.id,
    this.type,
    this.credits,
    this.amount,
    this.date,
    this.title,
    this.paymentMethod,
    this.phoneNumber,
    this.reference,
    this.orderNumber,
    this.status,
    this.user,
  });

  factory OperationModel.fromJson(Map<String, dynamic> json) {
    return OperationModel(
      id: json['id'],
      type: json['type'],
      credits: json['credits'],
      amount: json['amount'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      title: json['title'],
      paymentMethod: json['paymentMethod'],
      phoneNumber: json['phoneNumber'],
      reference: json['reference'],
      orderNumber: json['orderNumber'],
      status: json['status'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'credits': credits,
      'amount': amount,
      'date': date?.toIso8601String(),
      'title': title,
      'paymentMethod': paymentMethod,
      'phoneNumber': phoneNumber,
      'status': status,
      'reference': reference,
      'orderNumber': orderNumber,
      'user': user?.toJson(),
    };
  }
}
