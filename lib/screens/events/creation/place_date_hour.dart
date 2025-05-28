  import 'dart:io';

  import 'package:flutter/cupertino.dart';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
  import 'package:google_maps_flutter/google_maps_flutter.dart';
  import 'package:intl/intl.dart';
  import 'package:kuuwaa/common/app_colors.dart';
  import 'package:kuuwaa/common/common_button.dart';
  import 'package:kuuwaa/common/common_widget.dart';
  import 'package:kuuwaa/common/image_path.dart';
  import 'package:kuuwaa/responsive/responsive_flutter.dart';
  import 'package:kuuwaa/screens/events/creation/map_picker_view.dart';
  import 'package:kuuwaa/screens/events/creation/map_view.dart';

  class PlaceDateHour extends StatefulWidget {
    DateTime? startDate;
    DateTime? endDate;
    Function(DateTime)? onStartDateConfirm;
    Function(DateTime)? onEndDateConfirm;
    final TextEditingController addressController;
    final TextEditingController placeNameController;
    final void Function(LatLng? coords)? onCoordinatesPicked;

    PlaceDateHour({
      Key? key,
      required this.startDate,
      required this.endDate,
      required this.onStartDateConfirm,
      required this.onEndDateConfirm,
      required this.addressController,
      required this.placeNameController,
      required this.onCoordinatesPicked,
    }) : super(key: key);

    @override
    State<StatefulWidget> createState() => _PlaceDateHourState();
  }

  class _PlaceDateHourState extends State<PlaceDateHour> {
    AppColors appColors = AppColors();

    LatLng? _selectedCoordinates;

    Future<void> _pickCoordinatesOnMap() async {
      final LatLng? picked = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPickerPage(
            initialAddress: widget.addressController.text,
          ),
        ),
      );

      if (picked != null) {
        if (widget.onCoordinatesPicked != null) {
          widget.onCoordinatesPicked!(picked);
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return ListView(
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
                  onConfirm: (value) {
                    widget.onStartDateConfirm!(value);
                  },
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
                      widget.startDate == null ? "Date et heure du début" : DateFormat(
                          'dd/MM/yyyy à kk:mm').format(widget.startDate!),
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
          GestureDetector(
            onTap: () async {
              DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                minTime: widget.startDate ?? DateTime.now(),
                onConfirm: (value) {
                  widget.onEndDateConfirm!(value);
                },
                currentTime: widget.startDate ?? DateTime.now(),
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
                      widget.endDate == null ? "Date et heure de la fin" : DateFormat(
                          'dd/MM/yyyy à kk:mm').format(widget.endDate!),
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
              controller: widget.addressController,
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
              controller: widget.placeNameController,
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
          GestureDetector(
            onTap: _pickCoordinatesOnMap,
            child: CommonButton(
              icon: Icons.map,
              title: "Confirmer sur Maps",
              btnColor: appColors.white,
              textColor: appColors.black,
            ),
          )
        ],
      );
    }
  }