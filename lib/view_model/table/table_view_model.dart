import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/api_response.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/table/table_model.dart';
import 'package:kuuwaa/repository/table/table_repository.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';

class TableViewModel with ChangeNotifier{
  final _repository = TableRepository();

  bool _loading = false;
  bool get loading => _loading;
  ApiResponse<dynamic> tablesList = ApiResponse.loading();
  List<TableModel> tables = [];

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setTablesList (ApiResponse<dynamic> response) {
    tablesList = response;
    notifyListeners();
  }

  setTables (List<TableModel> response) {
    tables = response;
    notifyListeners();
  }

  Future<bool> listingApi(BuildContext context, int id) async {
    setTablesList(ApiResponse.loading());
    setLoading(true);
    await _repository.getEventTablesApi(context: context, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List tablesJson = value['data'];
        List<TableModel> tablesData = [];
        if (tablesJson.isNotEmpty) {
          for (var element in tablesJson) {
            tablesData.add(TableModel.fromJson(element));
          }
        }
        setTablesList(ApiResponse.completed(tablesData));
        setTables(tablesData);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> addTable(BuildContext context, Map data) async {
    setLoading(true);
    await _repository.addTablesApi(context: context, data: data).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List tablesJson = value['tables'];
        List<TableModel> tablesData = [];
        if (tablesJson.isNotEmpty) {
          for (var element in tablesJson) {
            tablesData.add(TableModel.fromJson(element));
          }
        }
        setTablesList(ApiResponse.completed(tablesData));
        Navigator.pop(context);
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