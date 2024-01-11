import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterService with ChangeNotifier {

  Future<String?> getSearch() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('filter_search');
  }

  Future<void> updateSearch(value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (value == null) {
      sp.remove('filter_search');
    } else {
      sp.setString('filter_search', value);
    }
    notifyListeners();
  }

  Future<DateTime?> getStartDate() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? dateString = sp.getString('filter_start_date');
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  Future<void> updateStartDate(value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (value == null) {
      sp.remove('filter_start_date');
    } else {
      sp.setString('filter_start_date', value);
    }
    notifyListeners();
  }

  Future<DateTime?> getEndDate() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? dateString = sp.getString('filter_end_date');
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  Future<void> updateEndDate(value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (value == null) {
      sp.remove('filter_end_date');
    } else {
      sp.setString('filter_end_date', value);
    }
    notifyListeners();
  }

  Future<bool?> hasDateFilter() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('filter_has_date');
  }

  Future<void> updateHasDateFilter(value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (value == null) {
      sp.remove('filter_has_date');
      sp.remove('filter_end_date');
      sp.remove('filter_start_date');
    } else {
      sp.setBool('filter_has_date', value);
    }
    notifyListeners();
  }

}