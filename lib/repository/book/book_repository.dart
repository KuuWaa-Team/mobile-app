import 'package:flutter/material.dart';
import 'package:kuuwaa/data/network/base_api_service.dart';
import 'package:kuuwaa/data/network/network_api_service.dart';
import 'package:kuuwaa/resource/config/app_url.dart';

class BookRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> deleteBookApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.booksEndPoint + "/$id/delete", {}, context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}