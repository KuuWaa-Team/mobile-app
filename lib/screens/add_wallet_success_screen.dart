import 'package:flutter/services.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:flutter/material.dart';

class AddWalletSuccessScreen extends StatefulWidget {
  const AddWalletSuccessScreen({Key? key}) : super(key: key);

  @override
  _AddWalletSuccessScreenState createState() => _AddWalletSuccessScreenState();
}

class _AddWalletSuccessScreenState extends State<AddWalletSuccessScreen> {
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: appColors.btnColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: appColors.btnColor,
        systemNavigationBarDividerColor: appColors.btnColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
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
                ImagePath.successFull,
                height: ResponsiveFlutter.of(context).moderateScale(280),
              ),
              SizedBox(
                height: ResponsiveFlutter.of(context).moderateScale(40),
              ),
              MyTextView(
                Strings.addedMoneyPending,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyTextView(
                  Strings.yourAmountSuccessfullyAdded,
                  textAligntNew: TextAlign.center,
                  maxLineWrap: true,
                  styleNew: MyTextStyle(
                    colorNew: appColors.white,
                    fontWeightNew: FontWeight.w500,
                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                  ),
                ),
              ),
              SizedBox(
                height: ResponsiveFlutter.of(context).moderateScale(35),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).moderateScale(80)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomBarScreen(),
                      ),
                        (route) => false
                    );
                  },
                  child: CommonButton(
                    context: context,
                    title: Strings.backToHome.toUpperCase(),
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
