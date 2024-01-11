import 'dart:async';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('user__id', user.id!.toInt());
    sp.setString('token', user.token.toString());
    notifyListeners();
    return true;
  }

  Future<bool> updateUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (user.id != null) {
      sp.setInt('user__id', user.id!.toInt());
    }
    if (user.token != null) {
      sp.setString('user__token', user.token.toString());
    }
    if (user.otpVerified != null) {
      sp.setBool('user__otp_verified', user.otpVerified == true);
    }
    if (user.firstname != null) {
      sp.setString('user__firstname', user.firstname.toString());
    }
    if (user.lastname != null) {
      sp.setString('user__lastname', user.lastname.toString());
    }
    if (user.phoneNumber != null) {
      sp.setString('user__phone_number', user.phoneNumber.toString());
    }
    if (user.address != null) {
      sp.setString('user__address', user.address.toString());
    }

    notifyListeners();
    return true;
  }

  Future<bool> otpVerified() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('user__otp_verified', true);
    notifyListeners();
    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? id = sp.getInt('user__id');
    String? token = sp.getString('user__token');
    String? firstname = sp.getString('user__firstname');
    String? lastname = sp.getString('user__lastname');
    String? phoneNumber = sp.getString('user__phone_number');
    String? address = sp.getString('user__address');
    bool? otpVerified = sp.getBool('user__otp_verified');

    UserModel account = UserModel(
      id: id,
      token: token,
      phoneNumber: phoneNumber,
      firstname: firstname,
      lastname: lastname,
      address: address,
      otpVerified: otpVerified
    );

    return account;
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    await sp.setBool('initScreen', true);
    return true;
  }
}