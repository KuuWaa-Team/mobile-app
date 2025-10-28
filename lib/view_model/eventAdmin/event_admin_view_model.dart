import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/api_response.dart';
import 'package:kuuwaa/model/eventAdmin/event_admin_controller.dart';
import 'package:kuuwaa/repository/eventAdmin/event_admin_repository.dart';
import 'package:kuuwaa/screens/home_page_screen.dart';

class EventAdminViewModel with ChangeNotifier{
  final _repository = EventAdminRepository();

  bool _loading = false;
  bool get loading => _loading;
  ApiResponse<dynamic> adminsList = ApiResponse.loading();
  List<EventAdminRepository> admins = [];

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setAdminsList (ApiResponse<dynamic> response) {
    adminsList = response;
    notifyListeners();
  }

  Future<bool> listingApi(BuildContext context, int id) async {
    setAdminsList(ApiResponse.loading());
    setLoading(true);
    await _repository.getEventAdminsApi(context: context, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List adminsJson = value['data'];
        List<EventAdminModel> adminsData = [];
        if (adminsJson.isNotEmpty) {
          for (var element in adminsJson) {
            adminsData.add(EventAdminModel.fromJson(element));
          }
        }
        setAdminsList(ApiResponse.completed(adminsData));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> addAdmin(BuildContext context, Map data) async {
    setLoading(true);
    await _repository.addAdminApi(context: context, data: data).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List adminsJson = value['admins'];
        List<EventAdminModel> adminsData = [];
        if (adminsJson.isNotEmpty) {
          for (var element in adminsJson) {
            adminsData.add(EventAdminModel.fromJson(element));
          }
        }
        setAdminsList(ApiResponse.completed(adminsData));
        Navigator.pop(context);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      print("*************************** ERROR ***************************");
      print(error);
      setLoading(false);
    });
    return true;
  }

  Future<bool> acceptInvitationApi (BuildContext context, Map data) async {
    setLoading(true);
    await _repository.acceptInvitationApi(context: context, data: data).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(invitationAccepted: true,),
          ),
        );
        Utils.toastMessage(value['message']);
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

  Future<bool> refuseInvitationApi (BuildContext context, Map data, int id) async {
    setLoading(true);
    await _repository.refuseInvitationApi(context: context, data: data, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
        Utils.toastMessage(value['message']);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> removeApi (BuildContext context, int id) async {
    setLoading(true);
    bool returnValue = false;
    await _repository.removeApi(context: context, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        returnValue = true;
        Utils.toastMessage(value['message']);
        setLoading(false);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
      setLoading(false);
    });
    return returnValue;
  }

}