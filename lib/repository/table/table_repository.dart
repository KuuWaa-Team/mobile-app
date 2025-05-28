import 'package:flutter/material.dart';
import 'package:kuuwaa/data/network/base_api_service.dart';
import 'package:kuuwaa/data/network/network_api_service.dart';
import 'package:kuuwaa/resource/config/app_url.dart';

class TableRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getEventTablesApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.eventEndPoint + "/$id/tables", context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> addTablesApi ({required BuildContext context, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.tableEndPoint, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  // Future<dynamic> sendInvitationsApi ({required BuildContext context, required Map data, required int id}) async {
  //   try  {
  //     dynamic response = await _apiServices.getPostApiResponse(AppUrl.invitationEndPoint + "/$id/send", data, context: context, auth: true);
  //     return response;
  //   } catch(e) {
  //     rethrow;
  //   }
  // }
}