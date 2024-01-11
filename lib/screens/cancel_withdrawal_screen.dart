import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:flutter/material.dart';

class CancelWithdrawalScreen extends StatefulWidget {
  const CancelWithdrawalScreen({Key? key}) : super(key: key);

  @override
  _CancelWithdrawalScreenState createState() => _CancelWithdrawalScreenState();
}

class _CancelWithdrawalScreenState extends State<CancelWithdrawalScreen> {
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.btnColor,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImagePath.cancelled,
                height: ResponsiveFlutter.of(context).moderateScale(350),
              ),
              SizedBox(
                height: ResponsiveFlutter.of(context).moderateScale(40),
              ),
              MyTextView(
                Strings.withdrawMoney,
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
                Strings.yourAmountCanAdded,
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
                    title: Strings.tryAgain,
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
