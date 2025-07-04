import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/api_response.dart';
import 'package:kuuwaa/model/wallet/operation_model.dart';
import 'package:kuuwaa/repository/wallet/wallet_repository.dart';
import 'package:kuuwaa/screens/add_wallet_success_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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

    await _repository.recharge(data: data, context: context, id: userId).then((value) async {
      setLoading(false);

      if (value['success'] == true) {
        final operation = value['operation'];
        final redirectUrl = operation?['redirectUrl'];
        final method = data['payment_method'];

        if (method == PaymentMethod.card && redirectUrl == null) {
          Utils.flushBarErrorMessage("Un probleme est survenu. veuillez ressayer plutard ou changez de mode de paiement", context);
        } else {
          if (method == PaymentMethod.card && redirectUrl != null) {
            final uri = Uri.parse(redirectUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              Utils.flushBarErrorMessage("Impossible d'ouvrir le lien de paiement.", context);
            }
          }
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AddWalletSuccessScreen()),
                (route) => false,
          );
        }
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      print("***************** ERROR ********************");
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