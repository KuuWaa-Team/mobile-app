import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/api_response.dart';
import 'package:kuuwaa/model/beverage/beverage_model.dart';
import 'package:kuuwaa/repository/beverage/beverage_repository.dart';

class BeverageViewModel with ChangeNotifier{
  final _repository = BeverageRepository();

  bool _loading = false;
  bool get loading => _loading;
  ApiResponse<dynamic> beveragesList = ApiResponse.loading();
  List<BeverageModel> beverages = [];

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setBeveragesList (ApiResponse<dynamic> response) {
    beveragesList = response;
    notifyListeners();
  }

  Future<bool> listingApi(BuildContext context, int id) async {
    setBeveragesList(ApiResponse.loading());
    setLoading(true);
    await _repository.getEventBeveragesApi(context: context, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List beveragesJson = value['data'];
        List<BeverageModel> beveragesData = [];
        if (beveragesJson.isNotEmpty) {
          for (var element in beveragesJson) {
            beveragesData.add(BeverageModel.fromJson(element));
          }
        }
        setBeveragesList(ApiResponse.completed(beveragesData));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> addBeverage(BuildContext context, Map data) async {
    setLoading(true);
    await _repository.addBeverageApi(context: context, data: data).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List beveragesJson = value['beverages'];
        List<BeverageModel> beveragesData = [];
        if (beveragesJson.isNotEmpty) {
          for (var element in beveragesJson) {
            beveragesData.add(BeverageModel.fromJson(element));
          }
        }
        setBeveragesList(ApiResponse.completed(beveragesData));
        Navigator.pop(context);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> removeBeverage(BuildContext context, int id) async {
    setLoading(true);
    await _repository.removeBeverageApi(context: context, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List beveragesJson = value['beverages'];
        List<BeverageModel> beveragesData = [];
        if (beveragesJson.isNotEmpty) {
          for (var element in beveragesJson) {
            beveragesData.add(BeverageModel.fromJson(element));
          }
        }
        setBeveragesList(ApiResponse.completed(beveragesData));
        Navigator.pop(context);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      print(error);
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return true;
  }

}