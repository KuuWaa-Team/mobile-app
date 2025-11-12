import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:flutter/material.dart';

class PaymentSuccessedScreen extends StatefulWidget {
  const PaymentSuccessedScreen({Key? key}) : super(key: key);
  @override
  _PaymentSuccessedScreenState createState() => _PaymentSuccessedScreenState();
}

class _PaymentSuccessedScreenState extends State<PaymentSuccessedScreen> {
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.btnColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImagePath.successFull,
                height: ResponsiveFlutter.of(context).moderateScale(350),
              ),
              SizedBox(
                height: ResponsiveFlutter.of(context).moderateScale(40),
              ),
              MyTextView(
                Strings.paymentSuccessed,
                textAligntNew: TextAlign.center,
                maxLineWrap: true,
                styleNew: MyTextStyle(
                  colorNew: appColors.white,
                  fontWeightNew: FontWeight.w600,
                  size: ResponsiveFlutter.of(context).fontSize(3.7),
                ),
              ),
              SizedBox(
                height: ResponsiveFlutter.of(context).moderateScale(20),
              ),
              MyTextView(
                Strings.youHaveSuccessfullyMade,
                textAligntNew: TextAlign.center,
                maxLineWrap: true,
                styleNew: MyTextStyle(
                  colorNew: appColors.white,
                  fontWeightNew: FontWeight.w500,
                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                ),
              ),
              SizedBox(
                height: ResponsiveFlutter.of(context).moderateScale(35),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).moderateScale(95)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomBarScreen(),
                      ),
                    );
                  },
                  child: CommonButton(
                    context: context,
                    title: Strings.backToHome,
                    btnColor: appColors.white,
                    textColor: appColors.btnColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
