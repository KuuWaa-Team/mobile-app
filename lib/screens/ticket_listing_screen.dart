import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/model/common_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/details_screen.dart';
import 'package:kuuwaa/screens/ticket_detail_screen.dart';
import 'package:flutter/material.dart';

class TicketListingScreen extends StatefulWidget {
  const TicketListingScreen({Key? key}) : super(key: key);
  @override
  _TicketListingScreenState createState() => _TicketListingScreenState();
}

class _TicketListingScreenState extends State<TicketListingScreen> {
  AppColors appColors = AppColors();
  List<CommonModel>? select = [
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
bottom: !Platform.isIOS,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                  vertical: ResponsiveFlutter.of(context).moderateScale(15),
                ),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TicketDetailScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveFlutter.of(context).moderateScale(17),
                      vertical: ResponsiveFlutter.of(context).moderateScale(15),
                    ),
                    decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(
                        ResponsiveFlutter.of(context).moderateScale(15),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyTextView(
                                        "Concert Gael",
                                        textAligntNew: TextAlign.start,
                                        maxLineWrap: true,
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.lightColor,
                                          fontWeightNew: FontWeight.w600,
                                          size: ResponsiveFlutter.of(context).fontSize(2),
                                        ),
                                      ),
                                      MyTextView(
                                        "Concert Gospel",
                                        textAligntNew: TextAlign.start,
                                        maxLineWrap: true,
                                        styleNew: MyTextStyle(
                                          colorNew: Colors.orange.withOpacity(.4),
                                          fontWeightNew: FontWeight.w400,
                                          size: ResponsiveFlutter.of(context).fontSize(1.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Image.asset(
                                    ImagePath.calender,
                                    color: appColors.lightColor.withOpacity(.5),
                                    height: ResponsiveFlutter.of(context).moderateScale(14),
                                  ),
                                  SizedBox(
                                    width: ResponsiveFlutter.of(context).moderateScale(6),
                                  ),
                                  MyTextView(
                                    Strings.dummyText22,
                                    textAligntNew: TextAlign.start,
                                    maxLineWrap: true,
                                    styleNew: MyTextStyle(
                                      colorNew: appColors.lightColor.withOpacity(.5),
                                      fontWeightNew: FontWeight.w500,
                                      size: ResponsiveFlutter.of(context).fontSize(1.4),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ResponsiveFlutter.of(context).moderateScale(10),
                                  ),
                                  Image.asset(
                                    ImagePath.time,
                                    color: appColors.lightColor.withOpacity(.5),
                                    height: ResponsiveFlutter.of(context).moderateScale(14),
                                  ),
                                  SizedBox(
                                    width: ResponsiveFlutter.of(context).moderateScale(6),
                                  ),
                                  MyTextView(
                                    Strings.dummyText23,
                                    textAligntNew: TextAlign.start,
                                    maxLineWrap: true,
                                    styleNew: MyTextStyle(
                                      colorNew: appColors.lightColor.withOpacity(.5),
                                      fontWeightNew: FontWeight.w500,
                                      size: ResponsiveFlutter.of(context).fontSize(1.4),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ResponsiveFlutter.of(context).moderateScale(10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(
                  height: ResponsiveFlutter.of(context).moderateScale(20),
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveFlutter.of(context).verticalScale(65),
            ),
          ],
        ),
      ),
    );
  }
}
