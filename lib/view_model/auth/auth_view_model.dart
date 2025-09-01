import 'package:flutter/material.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/repository/auth/auth_repository.dart';
import 'package:kuuwaa/screens/auth/deleted_account_screen.dart';
import 'package:kuuwaa/screens/auth/login_screen.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
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
      print("*************************** Data *****************************");
      print(value);
      setLoading(false);
      if (value['success'] == true  ) {
        UserModel user = UserModel.fromJson(value['user']);
        if (user.deletedAt == null) {
          user.token = value['token'];
          UserViewModel().updateUser(user).then((value) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomBarScreen()),
                  (route) => false,
            );
          });
        } else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (route) => DeletedAccountScreen(id: user.id!, deletedAt: user.deletedAt!)), (route)=>false);
        }
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      print("*************************** Err *****************************");
      print(error);
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> deleteAccountApi(BuildContext context, int id) async {
    setLoading(true);
    bool returnValue = false;
    await _repository.deleteAccountApi(context: context, id: id).then((value) {
      setLoading(false);

      if (value['success'] == true) {
        returnValue = true;
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      print("----------------------------------------------");
      print(error);
      print("----------------------------------------------");
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });

    return returnValue;
  }

  Future<bool> restoreApi(BuildContext context, int id) async {
    setLoading(true);
    bool returnValue = false;
    await _repository.restoreAccountApi(context: context, id: id).then((value) {
      setLoading(false);

      if (value['success'] == true) {
        returnValue = true;
        Utils.toastMessage("Compte restauré avec succès");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (route) => LoginScreen()
        ), (route) => false);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      print("----------------------------------------------");
      print(error);
      print("----------------------------------------------");
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });

    return returnValue;
  }

}