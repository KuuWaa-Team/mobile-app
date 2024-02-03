import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/screens/auth/login_screen.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/complete_profile_screen.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class SplashService {
  Future<UserModel> getUserData() => UserViewModel().getUser();

  void checkAuthentication(BuildContext context) async {
    getUserData().then((value) {
      if (
        value.token.toString() == 'null' ||
        value.token == '' ||
        value.token == null ||
        value.otpVerified != true
      ) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
              (route) => false,
        );
      } else if (
        value.firstname == null ||
        value.firstname == 'null' ||
        value.firstname == '' ||
        value.lastname == null ||
        value.lastname == 'null' ||
        value.lastname == '' ||
        value.address == null ||
        value.address == 'null' ||
        value.address == ''
      ) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const CompleteProfileScreen(),
          ),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomBarScreen(),
          ),
              (route) => false,
        );
      }
    }).onError((error, stackTrace) {
      if(kDebugMode) {
        print(error.toString());
      }
    });
  }
}