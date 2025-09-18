import 'package:flutter/material.dart';
import 'package:kuuwaa/data/network/base_api_service.dart';
import 'package:kuuwaa/data/network/network_api_service.dart';
import 'package:kuuwaa/resource/config/app_url.dart';

class EventRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  Future<dynamic> listingApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.userEndPoint + "/$id/events", context: context, auth: true);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getCategoriesApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.categoryEndPoint, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> openTablesApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id/open-tables", {}, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> openBeverageApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id/open-beverage", {}, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> openBookApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id/open-book", {}, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> openMusicApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id/open-music", {}, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> openGameApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id/open-game", {}, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> addGameQuestion ({required BuildContext context, required Map data, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id/add-game-question", data, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> editGameQuestion ({required BuildContext context, required Map data, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.gameQuestionEndPoint + "/$id/edit", data, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> removeGameQuestion ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.gameQuestionEndPoint + "/$id/remove", {}, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> addAssertionToQuestion ({required BuildContext context, required Map data, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.gameQuestionEndPoint + "/$id/add-assertion", data, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> setGameAssertionCorrect ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.gameAssertionEndPoint + "/$id/set-correct", {}, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> removeGameAssertion ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.gameAssertionEndPoint + "/$id/remove", {}, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getGameQuestions ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.eventEndPoint + "/$id/questions-list", context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getTemplatesApi ({required BuildContext context}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.templatesEndPoint, context: context, auth: false);
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

  Future<dynamic> downloadBookApi ({required BuildContext context, required int id}) async {
    try  {
      //dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id/generate-book", {}, context: context, auth: false);
      return true;
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
      dynamic response = await _apiServices.getMultipartApiResponse(AppUrl.eventEndPoint, data, context: context, filename: 'image', secondaryFilename: 'template_image');
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

  Future<dynamic> payPackApi ({required BuildContext context, required Map data, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id/pay-pack", data, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> deleteEventApi ({required BuildContext context, required int id}) async {
    try  {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.eventEndPoint + "/$id/delete", {}, context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> checkPayStatus ({required BuildContext context, required String orderNumber, required int id}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.eventEndPoint + "/$id/check-pay?on=$orderNumber", context: context, auth: false);
      return response;
    } catch(e) {
      rethrow;
    }
  }

  Future<dynamic> getEventDetailApi ({required BuildContext context, required int id, required int userId}) async {
    try  {
      dynamic response = await _apiServices.getGetResponse(AppUrl.eventEndPoint + "/$id?userId=$userId", context: context);
      return response;
    } catch(e) {
      rethrow;
    }
  }
}