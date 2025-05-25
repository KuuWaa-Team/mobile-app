import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/check_dialog.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/edit_event_screen.dart';
import 'package:kuuwaa/view_model/invitation/invitation_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InformationsScreen extends StatefulWidget {
  EventModel event;
  InformationsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _InformationsScreenState createState() => _InformationsScreenState();
}

class _InformationsScreenState extends State<InformationsScreen> {
  AppColors appColors = AppColors();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          backgroundColor: appColors.appMediumColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              commonAppBar(
                context: context,
                title: "Details de l'événement",
                backArrow: true,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextView(
                        "Informations générales",
                        textAligntNew: TextAlign.start,
                        styleNew: MyTextStyle(
                          colorNew: appColors.btnColor,
                          fontWeightNew: FontWeight.w500,
                          size: ResponsiveFlutter.of(context).fontSize(2),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      MyTextView(
                        "Titre",
                        textAligntNew: TextAlign.start,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                      MyTextView(
                        widget.event.title.toString(),
                        maxLinesNew: 2,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          fontWeightNew: FontWeight.w600,
                          size: ResponsiveFlutter.of(context).fontSize(2),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                      MyTextView(
                        "Catégorie",
                        textAligntNew: TextAlign.start,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                      MyTextView(
                        widget.event.category!.name.toString(),
                        maxLinesNew: 2,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          fontWeightNew: FontWeight.w600,
                          size: ResponsiveFlutter.of(context).fontSize(2),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                      MyTextView(
                        "Details",
                        textAligntNew: TextAlign.start,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                      MyTextView(
                        widget.event.details.toString(),
                        maxLinesNew: 20,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          fontWeightNew: FontWeight.w500,
                          size: ResponsiveFlutter.of(context).fontSize(1.6),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(8)),
                      const Divider(),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(8)),
                      MyTextView(
                        "Date, heure et addresse",
                        textAligntNew: TextAlign.start,
                        styleNew: MyTextStyle(
                          colorNew: appColors.btnColor,
                          fontWeightNew: FontWeight.w500,
                          size: ResponsiveFlutter.of(context).fontSize(2),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      MyTextView(
                        "Date",
                        textAligntNew: TextAlign.start,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(2)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            ImagePath.calender,
                            color: appColors.lightColor,
                            height: ResponsiveFlutter.of(context).moderateScale(15),
                          ),
                          SizedBox(width: ResponsiveFlutter.of(context).moderateScale(5)),
                          MyTextView(
                            widget.event.formattedDate(),
                            textAligntNew: TextAlign.start,
                            maxLineWrap: true,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      MyTextView(
                        "Heure",
                        textAligntNew: TextAlign.start,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(2)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            ImagePath.time,
                            color: appColors.lightColor,
                            height: ResponsiveFlutter.of(context).moderateScale(15),
                          ),
                          SizedBox(width: ResponsiveFlutter.of(context).moderateScale(5)),
                          MyTextView(
                            widget.event.formattedHour(),
                            textAligntNew: TextAlign.start,
                            maxLineWrap: true,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                      Container(
                        // height: ResponsiveFlutter.of(context).moderateScale(55),
                        width: double.infinity,
                        padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(10)),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(
                            ResponsiveFlutter.of(context).moderateScale(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                            Image.asset(
                              ImagePath.location,
                              color: appColors.lightColor,
                              height: ResponsiveFlutter.of(context).moderateScale(15),
                            ),
                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                            Flexible(
                              child: MyTextView(
                                widget.event.address.toString() + " (" + widget.event.placeName.toString() + ")",
                                textAligntNew: TextAlign.start,
                                maxLinesNew: 5,
                                maxLineWrap: true,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor,
                                  fontWeightNew: FontWeight.w500,
                                  size: ResponsiveFlutter.of(context).fontSize(2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                      if (widget.event.shared != true)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEventScreen(id: widget.event.id!),
                              ),
                            );
                          },
                          child: CommonButton(
                            loading: false,
                            title: "Modifier les details",
                          ),
                        ),
                    ],
                  ),
                ),
              )
              // Expanded(flex: 4, child: _buildQrView(context)),
            ],
          ),
        )
    );
  }
}
