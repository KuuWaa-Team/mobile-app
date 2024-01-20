import 'package:flutter/material.dart';
import 'package:kuuwaa/data/network/base_api_service.dart';
import 'package:kuuwaa/data/network/network_api_service.dart';
import 'package:kuuwaa/resource/config/app_url.dart';

class EventRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> listingApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.eventEndPoint, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getCategoriesApi ({required BuildContext context, required bool paid}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.categoryEndPoint + "?paid=" + (paid ? "1" : "0"), context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getPacksApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.packEndPoint + "?paid=0", context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getFeaturesPacksApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.featureEndPoint, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> createEventApi ({required BuildContext context, required Map data}) async {
    try  {
      dynamic response = await _apiServices.getMultipartApiResponse(AppUrl.eventEndPoint, data, context: context, filename: 'image');
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> editEventImageApi ({required BuildContext context, required Map data, required int id}) async {
    try  {
      dynamic response = await _apiServices.getMultipartApiResponse(AppUrl.eventEndPoint + "/$id/image", data, context: context, filename: 'image');
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> editEventApi ({required BuildContext context, required Map data, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id", data, context: context, auth: true);

      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> addBookApi ({required BuildContext context, required Map data, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id/book", data, context: context, auth: true);

      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getEventDetailApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.eventEndPoint + "/$id", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}