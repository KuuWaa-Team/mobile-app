import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/api_response.dart';
import 'package:kuuwaa/model/invitation/invitation_model.dart';
import 'package:kuuwaa/repository/invitation/invitation_repository.dart';

class InvitationViewModel with ChangeNotifier{
  final _repository = InvitationRepository();

  bool _loading = false;
  bool get loading => _loading;
  ApiResponse<dynamic> invitationsList = ApiResponse.loading();
  ApiResponse<InvitationModel> invitation = ApiResponse.loading();

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }


  setInvitationsList (ApiResponse<dynamic> response) {
    invitationsList = response;
    notifyListeners();
  }
  
  setInvitation (ApiResponse<InvitationModel> response) {
    invitation = response;
    notifyListeners();
  }

  Future<bool> listingApi(BuildContext context, int id) async {
    setInvitationsList(ApiResponse.loading());
    setLoading(true);
    await _repository.getEventInvitationsApi(context: context, id: id).then((value) {
      print(value);
      setLoading(false);
      if (value['success'] == true  ) {
        List invitationsJson = value['data'];
        List<InvitationModel> invitationsData = [];
        if (invitationsJson.isNotEmpty) {
          for (var element in invitationsJson) {
            invitationsData.add(InvitationModel.fromJson(element));
          }
        }
        setInvitationsList(ApiResponse.completed(invitationsData));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> myInvitationsListingApi(BuildContext context) async {
    setInvitationsList(ApiResponse.loading());
    setLoading(true);
    await _repository.getMyInvitationsApi(context: context).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List invitationsJson = value['data'];
        List<InvitationModel> invitationsData = [];
        if (invitationsJson.isNotEmpty) {
          for (var element in invitationsJson) {
            invitationsData.add(InvitationModel.fromJson(element));
          }
        }
        setInvitationsList(ApiResponse.completed(invitationsData));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> invitationDetailApi(BuildContext context, int id) async {
    setInvitationsList(ApiResponse.loading());
    setLoading(true);
    await _repository.invitationDetailApi(context: context, id: id).then((value) {
      setLoading(false);
      setInvitation(ApiResponse.completed(InvitationModel.fromJson(value)));
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> addInvitation(BuildContext context, Map data) async {
    setLoading(true);
    await _repository.addInvitationsApi(context: context, data: data).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List invitationsJson = value['invitations'];
        List<InvitationModel> invitationsData = [];
        if (invitationsJson.isNotEmpty) {
          for (var element in invitationsJson) {
            invitationsData.add(InvitationModel.fromJson(element));
          }
        }
        setInvitationsList(ApiResponse.completed(invitationsData));
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

  Future<bool> sendInvitation(BuildContext context, Map data, int id) async {
    setLoading(true);
    await _repository.sendInvitationsApi(context: context, data: data, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List invitationsJson = value['invitations'];
        List<InvitationModel> invitationsData = [];
        if (invitationsJson.isNotEmpty) {
          for (var element in invitationsJson) {
            invitationsData.add(InvitationModel.fromJson(element));
          }
        }
        setInvitationsList(ApiResponse.completed(invitationsData));
        Utils.toastMessage(value['message']);
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

  Future<bool> sendAllInvitations(BuildContext context, Map data) async {
    setLoading(true);
    await _repository.sendAllInvitationsApi(context: context, data: data).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List invitationsJson = value['invitations'];
        List<InvitationModel> invitationsData = [];
        if (invitationsJson.isNotEmpty) {
          for (var element in invitationsJson) {
            invitationsData.add(InvitationModel.fromJson(element));
          }
        }
        setInvitationsList(ApiResponse.completed(invitationsData));
        Utils.toastMessage(value['message']);
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