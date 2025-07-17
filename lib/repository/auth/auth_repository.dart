import 'package:flutter/material.dart';
import 'package:kuuwaa/data/network/base_api_service.dart';
import 'package:kuuwaa/data/network/network_api_service.dart';
import 'package:kuuwaa/resource/config/app_url.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginEndPoint, data, context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> otpVerificationApi (dynamic data, {required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.otpVerificationEndPoint, data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> completeProfileApi (dynamic data, {required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.userEndPoint + "/$id/complete-profile", data, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> deleteAccountApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.userEndPoint + "/$id/remove", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> restoreAccountApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.userEndPoint + "/$id/restore", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}