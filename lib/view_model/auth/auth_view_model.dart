import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/repository/auth/auth_repository.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/auth/complete_profile_screen.dart';
import 'package:kuuwaa/screens/home_page_screen.dart';
import 'package:kuuwaa/screens/auth/otp_screen.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class AuthViewModel with ChangeNotifier{
  final _repository = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> loginApi(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.loginApi(data, context: context).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        UserModel user = UserModel.fromJson(value['user']);
        user.token = value['token'];
        String message = value['message'];
        UserViewModel().updateUser(user).then((value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(message: message),
            ),
                (route) => false,
          );
        });
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> otpVerificationApi(dynamic data, BuildContext context) async {
    setLoading(true);
    await _repository.otpVerificationApi(data, context: context).then((value) {
      setLoading(false);
      if (value['success'] == true) {
        bool isNew = value['new'] == true;
        UserViewModel().otpVerified().then((value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => isNew ? CompleteProfileScreen() : BottomBarScreen(),
            ),
                (route) => false,
          );
        });

      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> completeProfileApi(dynamic data, int id,  BuildContext context) async {
    setLoading(true);
    await _repository.completeProfileApi(data, context: context, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true) {
        UserModel user = UserModel.fromJson(value['user']);
        UserViewModel().updateUser(user).then((value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBarScreen(),
            ),
                (route) => false,
          );
        });
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    });
    //     .onError((error, stackTrace) {
    //   Utils.flushBarErrorMessage(Utils.errorMessage, context);
    //   setLoading(false);
    // });
    return true;
  }

}