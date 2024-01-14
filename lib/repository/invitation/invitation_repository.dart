import 'package:flutter/material.dart';
import 'package:kuuwaa/data/network/base_api_service.dart';
import 'package:kuuwaa/data/network/network_api_service.dart';
import 'package:kuuwaa/resource/config/app_url.dart';

class InvitationRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getEventInvitationsApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.eventEndPoint + "/$id/invitations", context: context, auth: true);
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

  Future<dynamic> sendInvitationsApi ({required BuildContext context, required Map data, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.invitationEndPoint + "/$id/send", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}