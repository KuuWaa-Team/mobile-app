import 'package:flutter/material.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/repository/auth/auth_repository.dart';
import 'package:kuuwaa/screens/home_page_screen.dart';
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
        print("************");
        UserModel user = UserModel.fromJson(value['user']);
        user.token = value['token'];
        print(value);
        print(user.toJson());
        print(user.displayName);
        UserViewModel().updateUser(user).then((value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
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
}