import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/creation/map_picker_view.dart';
import 'package:kuuwaa/screens/events/informations_screen.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class EditPlaceDateHour extends StatefulWidget {
  EventModel event;

  EditPlaceDateHour({
    Key? key,
    required this.event
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditPlaceDateHourState();
}

class _EditPlaceDateHourState extends State<EditPlaceDateHour> {
  AppColors appColors = AppColors();
  UserModel? user;
  EventViewModel eventViewModel = EventViewModel();
  bool loading = false;
  DateTime? startDate;
  DateTime? endDate;
  LatLng? placeCoords;
  final addressController = TextEditingController();
  final placeNameController = TextEditingController();
  bool showEndDate = true;
  bool useGoogleMaps = true;
  LatLng? picked;

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    setState(() {
      startDate = widget.event.startDate;
      endDate = widget.event.endDate;
      addressController.text = widget.event.address ?? "";
      placeNameController.text = widget.event.placeName ?? "";

      if (widget.event.placeLatitude != null && widget.event.placeLongitude != null) {
        placeCoords = LatLng(double.parse(widget.event.placeLatitude!), double.parse(widget.event.placeLongitude!));
        useGoogleMaps = true;
      } else {
        useGoogleMaps = false;
      }

      showEndDate = widget.event.endDate != null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
          systemNavigationBarDividerColor: appColors.white
      ),
    );
    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: SafeArea(
        top: false,
        bottom: !Platform.isIOS,
        child: Column(
          children: [
            commonAppBar(
                context: context,
                title: "Modifier le lieu, la date et l'heure",
                backArrow: true,
                backClick: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (route) => InformationsScreen(event: widget.event)));
                }
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveFlutter.of(context).moderateScale(15),
                  horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                ),
                children: [
                  GestureDetector(
                    onTap: () async {
                      DatePicker.showDateTimePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          onConfirm: (value) => setState(() => startDate = value),
                          currentTime: DateTime.now(),
                          locale: LocaleType.fr
                      );
                    },
                    child: Container(
                      height: ResponsiveFlutter.of(context).verticalScale(50),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                      ),
                      decoration: BoxDecoration(
                        color: appColors.appLightColor,
                        borderRadius: BorderRadius.circular(
                          ResponsiveFlutter.of(context).moderateScale(20),
                        ),
                        border: Border.all(
                          color: appColors.borderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: MyTextView(
                              startDate == null ? "Date et heure du début" : DateFormat(
                                  'dd/MM/yyyy à kk:mm').format(startDate!),
                              styleNew: MyTextStyle(
                                colorNew: appColors.lightColor,
                                fontWeightNew: FontWeight.w400,
                                size: ResponsiveFlutter.of(context).fontSize(1.8),
                              ),
                            ),
                          ),
                          Image.asset(
                            ImagePath.pinkCalendar,
                            color: appColors.lightPinkColor,
                            height: ResponsiveFlutter.of(context).moderateScale(23),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(10),
                  ),
                  Opacity(
                    opacity: showEndDate ? 1.0 : 0.3,
                    child: GestureDetector(
                      onTap: showEndDate ? null : () async {
                        DatePicker.showDateTimePicker(
                          context,
                          showTitleActions: true,
                          minTime: startDate ?? DateTime.now(),
                          onConfirm: (value) => setState(() => endDate = value),
                          currentTime: startDate ?? DateTime.now(),
                          locale: LocaleType.fr,
                        );
                      },
                      child: Container(
                        height: ResponsiveFlutter.of(context).verticalScale(50),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                        ),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(
                            ResponsiveFlutter.of(context).moderateScale(20),
                          ),
                          border: Border.all(
                            color: appColors.borderColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MyTextView(
                                endDate == null
                                    ? "Date et heure de la fin"
                                    : DateFormat('dd/MM/yyyy à kk:mm')
                                    .format(endDate!),
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor,
                                  fontWeightNew: FontWeight.w400,
                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                ),
                              ),
                            ),
                            Image.asset(
                              ImagePath.pinkCalendar,
                              color: appColors.lightPinkColor,
                              height: ResponsiveFlutter.of(context).moderateScale(23),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: showEndDate,
                    onChanged: (val) => setState(() {
                      showEndDate = val == true;
                      if (!showEndDate) {
                        endDate = null;
                      }
                    }),
                    title: MyTextView(
                      "Afficher la date et l'heure de la fin",
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.7),
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: appColors.btnColor,
                  ),

                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(15),
                  ),
                  MyTextView(
                    "Adresse",
                    textAligntNew: TextAlign.center,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context)
                          .fontSize(1.8),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    height: ResponsiveFlutter.of(context)
                        .verticalScale(40),
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveFlutter.of(context)
                          .moderateScale(6),
                      horizontal: ResponsiveFlutter.of(context)
                          .moderateScale(15),
                    ),
                    decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(
                        ResponsiveFlutter.of(context)
                            .moderateScale(25),
                      ),
                    ),
                    child: commonTestField(
                      context: context,
                      controller: addressController,
                      hintText: "Adresse complète",
                      keyboardType: TextInputType.text,
                      icon: true,
                    ),
                  ),
                  Container(
                    height: ResponsiveFlutter.of(context)
                        .verticalScale(40),
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveFlutter.of(context)
                          .moderateScale(6),
                      horizontal: ResponsiveFlutter.of(context)
                          .moderateScale(15),
                    ),
                    margin: EdgeInsets.only(
                        bottom: ResponsiveFlutter.of(context)
                            .moderateScale(5), top: 10),
                    decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(
                        ResponsiveFlutter.of(context)
                            .moderateScale(25),
                      ),
                    ),
                    child: commonTestField(
                      context: context,
                      controller: placeNameController,
                      hintText: "Lieu de l'évenement (optionnel)",
                      keyboardType: TextInputType.text,
                      icon: true,
                    ),
                  ),
                  MyTextView(
                    "Ex : Salle de fête creative",
                    textAligntNew: TextAlign.center,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context)
                          .fontSize(1.3),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Opacity(
                    opacity: useGoogleMaps ? 1.0 : 0.3,
                    child: IgnorePointer(
                      ignoring: !useGoogleMaps,
                      child: GestureDetector(
                        onTap: _pickCoordinatesOnMap,
                        child: CommonButton(
                          icon: picked == null ? Icons.map : Icons.check_circle_outline,
                          title: "Confirmer sur Maps",
                          btnColor: picked == null ? appColors.white : appColors.btnColor,
                          textColor: picked == null ? appColors.black : appColors.white,
                        ),
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: useGoogleMaps,
                    onChanged: (val) => setState(() {
                      useGoogleMaps = val == true;
                      if (!useGoogleMaps) {
                        placeCoords = null;
                      }
                    }),
                    title: MyTextView(
                      "Utiliser Google Maps",
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.7),
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: appColors.btnColor,
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () async {
                      if (startDate == null || (endDate == null && showEndDate) || (placeCoords == null && useGoogleMaps)) {
                        Utils.flushBarErrorMessage("Veuillez compléter les informations de lieu/date", context);
                      } else {
                        setState(() {
                          loading = true;
                        });
                        final data = {
                          "start_date": startDate.toString(),
                          "end_date": endDate?.toString(),
                          "address": addressController.text,
                          "place_name": placeNameController.text,
                          "place_longitude": placeCoords?.longitude.toString(),
                          "place_latitude": placeCoords?.latitude.toString(),
                          "step": "PLACE_DATE_HOUR"
                        };
                        await eventViewModel.editEventApi(context, data, widget.event.id!).then((value) {
                          if (value.isNotEmpty) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (r) => InformationsScreen(event: value['event'])));
                          }
                        });
                      }
                    },
                    child: CommonButton(
                      loading: loading,
                      title: "Modifier",
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCoordinatesOnMap() async {
    final LatLng? pick = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerPage(
          initialAddress: addressController.text,
        ),
      ),
    );

    if (pick != null) {
      setState(() => placeCoords = pick);
      setState(() {
        picked = pick;
      });
    }
    print(picked);
  }
}