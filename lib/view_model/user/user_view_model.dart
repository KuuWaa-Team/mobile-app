import 'dart:async';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('user__id', user.id ?? 0);
    sp.setString('user__uid', user.uid ?? '');
    sp.setString('user__display_name', user.displayName ?? '');
    sp.setString('user__email', user.email ?? '');
    sp.setInt('user__credits', user.credits ?? 0);
    sp.setString('user__photo_url', user.photoUrl ?? '');
    sp.setString('user__provider', user.provider ?? '');
    sp.setString('user__token', user.token ?? '');
    notifyListeners();
    return true;
  }

  Future<bool> updateUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (user.id != null) sp.setInt('user__id', user.id!);
    if (user.uid != null) sp.setString('user__uid', user.uid!);
    if (user.displayName != null) sp.setString('user__display_name', user.displayName!);
    if (user.credits != null) sp.setInt('user__credits', user.credits!);
    if (user.email != null) sp.setString('user__email', user.email!);
    if (user.photoUrl != null) sp.setString('user__photo_url', user.photoUrl!);
    if (user.provider != null) sp.setString('user__provider', user.provider!);
    if (user.token != null) sp.setString('user__token', user.token!);
    notifyListeners();
    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return UserModel(
      id: sp.getInt('user__id'),
      uid: sp.getString('user__uid'),
      displayName: sp.getString('user__display_name'),
      email: sp.getString('user__email'),
      credits: sp.getInt('user__credits'),
      photoUrl: sp.getString('user__photo_url'),
      provider: sp.getString('user__provider'),
      token: sp.getString('user__token'),
    );
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.clear();
    await sp.setBool('initScreen', true);
    return true;
  }
}
