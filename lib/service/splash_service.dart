import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/screens/auth/login_screen.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class SplashService {
  Future<UserModel> getUserData() => UserViewModel().getUser();

  void checkAuthentication(BuildContext context) async {
    getUserData().then((user) {
      if (user.token == null || user.token!.isEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomBarScreen()),
              (route) => false,
        );
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print("Erreur lors de la récupération de l'utilisateur : $error");
      }
    });
  }
}
