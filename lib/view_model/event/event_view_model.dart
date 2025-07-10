import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/api_response.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/event/event_pack_model.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';
import 'package:kuuwaa/repository/event/event_repository.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/events/details_screen.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class EventViewModel with ChangeNotifier{
  final _repository = EventRepository();

  bool _loading = false;
  bool get loading => _loading;
  ApiResponse<dynamic> eventsList = ApiResponse.loading();
  ApiResponse<dynamic> packList = ApiResponse.loading();
  ApiResponse<EventModel> event = ApiResponse.loading();
  List<EventCategoryModel> categories = [];
  List<EventTemplateModel> templates = [];
  List<FeatureModel> features = [];

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setEventsList (ApiResponse<dynamic> response) {
    eventsList = response;
    notifyListeners();
  }

  setEvent (ApiResponse<EventModel> response) {
    event = response;
    notifyListeners();
  }

  setPacksList (ApiResponse<dynamic> response) {
    packList = response;
    notifyListeners();
  }

  setFeatures (List<FeatureModel> data) {
    features = data;
    notifyListeners();
  }

  setCategories (List<EventCategoryModel> data) {
    categories = data;
    notifyListeners();
  }

  setTemplates (List<EventTemplateModel> data) {
    templates = data;
    notifyListeners();
  }

  Future<bool> listingApi(BuildContext context, int id) async {
    setEventsList(ApiResponse.loading());
    setLoading(true);
    await _repository.listingApi(context: context, id: id).then((value) {
      print(value);
      setLoading(false);
      if (value['success'] == true  ) {
        List eventsJson = value['data'];
        List<EventModel> eventsData = [];
        if (eventsJson.isNotEmpty) {
          for (var element in eventsJson) {
            eventsData.add(EventModel.fromJson(element));
          }
        }
        setEventsList(ApiResponse.completed(eventsData));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> getCategories(BuildContext context) async {
    await _repository.getCategoriesApi(context: context).then((value) {
      print(value);

      if (value['success'] == true  ) {
        List categoriesJson = value['data'];
        List<EventCategoryModel> categoriesData = [];
        for (var element in categoriesJson) {
          categoriesData.add(EventCategoryModel.fromJson(element));
        }
        setCategories(categoriesData);
      } else {
        Utils.flushBarErrorMessage(Utils.errorMessage, context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      print(error);
      setLoading(false);
    });
    return true;
  }

  Future<bool> openTables(BuildContext context, int id) async {
    bool success = false;
    await _repository.openTablesApi(context: context, id: id).then((value) {
      if (value['success'] == true  ) {
        success = true;
        Utils.toastMessage(value['message']);
        UserViewModel().updateCredits(value['credits']);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return success;
  }

  Future<bool> openBeverage(BuildContext context, int id) async {
    bool success = false;
    await _repository.openBeverageApi(context: context, id: id).then((value) {
      if (value['success'] == true  ) {
        success = true;
        Utils.toastMessage(value['message']);
        UserViewModel().updateCredits(value['credits']);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return success;
  }

  Future<bool> openBook(BuildContext context, int id) async {
    bool success = false;
    await _repository.openBookApi(context: context, id: id).then((value) {
      if (value['success'] == true  ) {
        success = true;
        Utils.toastMessage(value['message']);
        UserViewModel().updateCredits(value['credits']);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return success;
  }

  Future<bool> getTemplates(BuildContext context) async {
    await _repository.getTemplatesApi(context: context).then((value) {
      print(value);
      if (value['success'] == true  ) {
        print("************** TEMPLATE **************");
        print(value);
        List templatesJson = value['templates'];
        List<EventTemplateModel> templatesData = [];
        for (var element in templatesJson) {
          templatesData.add(EventTemplateModel.fromJson(element));
        }
        setTemplates(templatesData);
      } else {
        Utils.flushBarErrorMessage(Utils.errorMessage, context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      print(error);
      setLoading(false);
    });
    return true;
  }

  Future<bool> getPacksApi (BuildContext context) async {
    setPacksList(ApiResponse.loading());
    setLoading(true);
    await _repository.getPacksApi(context: context).then((value) {
      if (value['success'] == true  ) {
        List packsJson = value['data'];
        List<EventPackModel> packsData = [];
        if (packsJson.isNotEmpty) {
          for (var element in packsJson) {
            packsData.add(EventPackModel.fromJson(element));
          }
        }
        setPacksList(ApiResponse.completed(packsData));
        setLoading(false);
      } else {
        Utils.flushBarErrorMessage(Utils.errorMessage, context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> downloadBookApi (BuildContext context, int id) async {
    setPacksList(ApiResponse.loading());
    setLoading(true);
    await _repository.downloadBookApi(context: context, id: id).then((value) {});
    return true;
  }

  Future<bool> getFeaturesApi (BuildContext context) async {
    setLoading(true);
    await _repository.getFeaturesPacksApi(context: context).then((value) {
      if (value['success'] == true  ) {
        List featuresJson = value['data'];
        List<FeatureModel> featuresData = [];
        for (var element in featuresJson) {
          featuresData.add(FeatureModel.fromJson(element));
        }
        setFeatures(featuresData);
        setLoading(false);
      } else {
        Utils.flushBarErrorMessage(Utils.errorMessage, context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<dynamic> createEventApi (BuildContext context, Map data) async {
    setLoading(true);

    await _repository.createEventApi(context: context, data: data).then((value) {
      if (value['success'] == true) {
        setLoading(false);
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (route) => BottomBarScreen()), (route) => false);
      } else {
        print(value);
        Utils.flushBarErrorMessage(Utils.errorMessage, context);
      }
    }).onError((error, stackTrace) {
      print(error);
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
  }

  Future<bool> editEventImageApi (BuildContext context, var image, int id) async {
    setLoading(true);
    Map data = {
      "image": image
    };

    await _repository.editEventImageApi(context: context, data: data, id: id).then((value) {
      if (value['success'] == true  ) {
        setEvent(ApiResponse.completed(EventModel.fromJson(value['event'])));
        Utils.toastMessage("Image modifiée avec succès");
        setLoading(false);
      } else {
        Utils.flushBarErrorMessage(Utils.errorMessage, context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> addBookApi (BuildContext context, Map data, int id) async {
    setLoading(true);

    await _repository.addBookApi(context: context, data: data, id: id).then((value) {
      if (value['success'] == true  ) {
        setLoading(false);
      } else {
        Utils.flushBarErrorMessage(Utils.errorMessage, context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<dynamic> payPackApi (BuildContext context, Map data, EventModel event) async {
    setLoading(true);
    dynamic response;
    await _repository.payPackApi(context: context, data: data, id: event.id!).then((value) {
      if (value['success'] == true  ) {
        response = value;
        // setLoading(false);
      } else {
        Utils.flushBarErrorMessage(Utils.errorMessage, context);
      }
    });
    // .onError((error, stackTrace) {
    //   Utils.flushBarErrorMessage(Utils.errorMessage, context);
    //   setLoading(false);
    // });
    return response;
  }

  Future<dynamic> deleteEventApi (BuildContext context, EventModel event) async {
    setLoading(true);
    dynamic response;
    await _repository.deleteEventApi(context: context, id: event.id!).then((value) {
      if (value['success'] == true  ) {
        response = value;
        Utils.toastMessage(value['message']);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>  BottomBarScreen(),
          ),
              (route) => false,
        );
        // setLoading(false);
      } else {
        Utils.flushBarErrorMessage(Utils.errorMessage, context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return response;
  }

  Future<dynamic> checkPayStatus (BuildContext context, String orderNumber, EventModel event) async {
    setLoading(true);
    dynamic response;
    await _repository.checkPayStatus(context: context, id: event.id!, orderNumber: orderNumber).then((value) {
      response = value;
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return response;
  }

  Future<bool> editEventApi (BuildContext context, Map data, int id) async {
    setLoading(true);

    await _repository.editEventApi(context: context, data: data, id: id).then((value) {
      if (value['success'] == true  ) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomBarScreen(),
          ),
        );
        Utils.toastMessage("Évenement modifié avec succès");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(id: id),
          ),
              (route) => false,
        );
        setLoading(false);
      } else {
        Utils.flushBarErrorMessage(Utils.errorMessage, context);
        setLoading(false);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> getEventDetailApi (BuildContext context, int id) async {
    setEvent(ApiResponse.loading());
    setLoading(true);
    await _repository.getEventDetailApi(context: context, id: id).then((value) {
      setLoading(false);
      setEvent(ApiResponse.completed(EventModel.fromJson(value)));
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }
}