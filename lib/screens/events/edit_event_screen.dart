import 'package:intl/intl.dart';
import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/address/address_model.dart';
import 'package:kuuwaa/model/address/country_model.dart';
import 'package:kuuwaa/model/address/province_model.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  Widget section;
  EventModel event;
  EditEventScreen({required this.section, required this.event, Key? key}) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  AppColors appColors = AppColors();
  String? selectedDate = "Select date";
  String? selectedTime = "Select time";
  bool loading = false;
  bool loaded = false;
  String street = "";
  bool loadedStreet = false;

  double total = 0;

  bool showOtherCategory = false;

  TimeOfDay time = TimeOfDay.now();

  bool addingPrice = false;

  DateTime? date;

  Object dropDownValue = EventCategoryModel(
      id: 0,
      name: "Catégorie"
  );
  List items = [];

  bool paid = false;

  List<Map<String, dynamic>> prices = [];
  List<Widget> pricesList = [];

  EventViewModel eventViewModel = EventViewModel();

  @override
  void initState() {
    List<dynamic> fetchedCategories = [dropDownValue];
    eventViewModel.getCategories(context).then((value) {
      for (var element in eventViewModel.categories) {
        fetchedCategories.add(element);
      }
      fetchedCategories.add(EventCategoryModel(
          id: null,
          name: "Autre (À préciser)"
      ));
      setState(() {
        items = fetchedCategories;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.section;
  }

  selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: time,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != time) {
      time = timeOfDay;
      debugPrint("time ------------- >>>> $timeOfDay");
      selectedTime = timeOfDay.hour.toString() + " : " + timeOfDay.minute.toString();
      setState(() {});
    } else {
      debugPrint("<<<< ------------- Time Not Selected ------------- >>>>");
    }
  }
}
