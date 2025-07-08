import 'package:flutter/material.dart';
import 'package:kuuwaa/data/network/base_api_service.dart';
import 'package:kuuwaa/data/network/network_api_service.dart';
import 'package:kuuwaa/resource/config/app_url.dart';

class InvitationRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getEventInvitationsApi ({required BuildContext context, required int id, bool withMusicRequest = false}) async {
    try  {
      String url = AppUrl.eventEndPoint + "/$id/invitations";
      if (withMusicRequest) {
        url += "?wm=1";
      }
      dynamic response = await _apiServices.getGetResponse(url, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getMyInvitationsApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.invitationEndPoint, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> invitationDetailApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.invitationEndPoint + "/$id", context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> addInvitationsApi ({required BuildContext context, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.invitationEndPoint, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> selectInvitationsApi ({required BuildContext context, required int id, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.invitationEndPoint + "/$id/beverage", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> sendInvitationsApi ({required BuildContext context, required Map data, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.invitationEndPoint + "/$id/send", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> editInvitationsApi ({required BuildContext context, required Map data, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.invitationEndPoint + "/$id/edit", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> checkInvitationsCodeApi ({required BuildContext context, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.invitationEndPoint + "/check-code", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> sendAllInvitationsApi ({required BuildContext context, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.invitationEndPoint + "/send-all", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> validateInvitationApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.invitationEndPoint + "/$id/validate", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}