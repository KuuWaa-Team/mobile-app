import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/model/common_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/details_screen.dart';
import 'package:kuuwaa/screens/invitation_details_screen.dart';
import 'package:flutter/material.dart';

class InvitationEventScreen extends StatefulWidget {
  const InvitationEventScreen({Key? key}) : super(key: key);
  @override
  _InvitationEventScreenState createState() => _InvitationEventScreenState();
}

class _InvitationEventScreenState extends State<InvitationEventScreen> {
  AppColors appColors = AppColors();
  List<CommonModel>? select = [
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: 7,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                  vertical: ResponsiveFlutter.of(context).moderateScale(15),
                ),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InvitationDetailsScreen(),
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
                                        Strings.dummyText21,
                                        textAligntNew: TextAlign.start,
                                        maxLineWrap: true,
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.lightColor,
                                          fontWeightNew: FontWeight.w600,
                                          size: ResponsiveFlutter.of(context).fontSize(2),
                                        ),
                                      ),
                                      MyTextView(
                                        "Mariage Réligieux",
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
                                  const Icon(Icons.check_circle_outline_rounded, size: 18, color: Colors.green,),
                                ],
                              ),
                              const SizedBox(height: 5,),
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
                                  Icon(Icons.people_alt_outlined, size: 18, color: appColors.lightColor.withOpacity(.5),),
                                  SizedBox(
                                    width: ResponsiveFlutter.of(context).moderateScale(6),
                                  ),
                                  MyTextView(
                                    "13",
                                    textAligntNew: TextAlign.start,
                                    maxLineWrap: true,
                                    styleNew: MyTextStyle(
                                      colorNew: appColors.lightColor.withOpacity(.5),
                                      fontWeightNew: FontWeight.w500,
                                      size: ResponsiveFlutter.of(context).fontSize(1.4),
                                    ),
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
              height: ResponsiveFlutter.of(context).verticalScale(75),
            ),
          ],
        ),
      ),
    );
  }
}
