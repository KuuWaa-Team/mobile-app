import 'package:flutter/material.dart';
import 'package:kuuwaa/data/network/base_api_service.dart';
import 'package:kuuwaa/data/network/network_api_service.dart';
import 'package:kuuwaa/resource/config/app_url.dart';

class BeverageRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getEventBeveragesApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.eventEndPoint + "/$id/beverages", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> addBeverageApi ({required BuildContext context, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.beverageEndPoint, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> removeBeverageApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.beverageEndPoint + "/$id/remove", {}, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}