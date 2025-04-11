import 'package:flutter/material.dart';
import 'package:kuuwaa/data/network/base_api_service.dart';
import 'package:kuuwaa/data/network/network_api_service.dart';
import 'package:kuuwaa/resource/config/app_url.dart';

class WalletRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> recharge ({required BuildContext context, required int id, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.userEndPoint + "/$id/recharge", data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getOperations ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.userEndPoint + "/$id/operations", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> checkPaymentStatus ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.operationEndPoint + "/$id/check-payment-status", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}