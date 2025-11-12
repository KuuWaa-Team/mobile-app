import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: SafeArea(
        child: Column(
          children: [
            commonAppBar(
              context: context,
              backArrow: true,
              title: Strings.aboutUs,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                  vertical: ResponsiveFlutter.of(context).moderateScale(15),
                ),
                children: [
                  SizedBox(
                    height: ResponsiveFlutter.of(context).moderateScale(210),
                    width: double.infinity,
                    child: Image.asset(ImagePath.aboutUs),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(20),
                  ),
                  MyTextView(
                    Strings.dummyText14,
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(2.2),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(10),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveFlutter.of(context).moderateScale(100),
                      vertical: ResponsiveFlutter.of(context).moderateScale(40)
                    ),
                    child: Image.asset(
                      ImagePath.logo,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
