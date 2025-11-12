import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
bottom: !Platform.isIOS,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              backArrow: true,
              title: Strings.editProfile,
              appBarColor: appColors.appDarkColor,
              edit: false,
              editClick: () {},
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveFlutter.of(context).moderateScale(25),
                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(20)),
                  decoration: BoxDecoration(
                    color: appColors.appLightColor,
                    borderRadius: BorderRadius.circular(
                      ResponsiveFlutter.of(context).moderateScale(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextView(
                        Strings.yourName,
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.transactionText,
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(5)),
                      commonTestField(
                        context: context,
                        hintText: Strings.enterYourName,
                        icon: false,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(20)),
                  decoration: BoxDecoration(
                    color: appColors.appLightColor,
                    borderRadius: BorderRadius.circular(
                      ResponsiveFlutter.of(context).moderateScale(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextView(
                        Strings.yourFirstName,
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.transactionText,
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(5)),
                      commonTestField(
                        context: context,
                        hintText: Strings.enterYourName,
                        icon: false,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(20)),
                  decoration: BoxDecoration(
                    color: appColors.appLightColor,
                    borderRadius: BorderRadius.circular(
                      ResponsiveFlutter.of(context).moderateScale(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextView(
                        Strings.yourAddress,
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.transactionText,
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(5)),
                      commonTestField(
                        context: context,
                        hintText: Strings.yourAddress,
                        icon: false,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(20)),
                  decoration: BoxDecoration(
                    color: appColors.appLightColor,
                    borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).moderateScale(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextView(
                        Strings.yourPhoneNumber,
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.transactionText,
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(5)),
                      commonTestField(
                        context: context,
                        hintText: Strings.enterYourPhoneNumber,
                        icon: false,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveFlutter.of(context).moderateScale(25)),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CommonButton(
                    title: Strings.save,
                    context: context,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
