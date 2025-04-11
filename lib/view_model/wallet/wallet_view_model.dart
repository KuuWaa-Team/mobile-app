import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/api_response.dart';
import 'package:kuuwaa/model/wallet/operation_model.dart';
import 'package:kuuwaa/repository/wallet/wallet_repository.dart';
import 'package:kuuwaa/screens/add_wallet_success_screen.dart';

class WalletViewModel with ChangeNotifier{
  final _repository = WalletRepository();

  bool _loading = false;
  bool get loading => _loading;
  ApiResponse<List<OperationModel>> operationsList = ApiResponse.loading();

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setOperationsList (ApiResponse<List<OperationModel>> response) {
    operationsList = response;
    notifyListeners();
  }

  Future<bool> recharge(BuildContext context, Map data, int userId) async {
    setLoading(true);
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    await _repository.recharge(data: data, context: context, id: userId).then((value) {
      print("bbbbbb");
      print(value);
      setLoading(false);
      if (value['success'] == true) {
        print("1111111111111");
        OperationModel operation = OperationModel.fromJson(value['operation']);
        print("222222222222222");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AddWalletSuccessScreen()),
              (route) => false,
        );
        print("3333333333333333333333333");
      } else {
        print("44444444444444444444444");
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      print("5555555555555555555555");
      print(error);
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });

    return true;
  }

  Future<bool> operations (BuildContext context, int id) async {
    setOperationsList(ApiResponse.loading());
    setLoading(true);
    await _repository.getOperations(context: context, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List operationsJson = value['data'];
        List<OperationModel> operationsData = [];
        if (operationsJson.isNotEmpty) {
          for (var element in operationsJson) {
            operationsData.add(OperationModel.fromJson(element));
          }
        }
        setOperationsList(ApiResponse.completed(operationsData));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      print(error);
    });
    return true;
  }

}