import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/home_page_screen.dart';
import 'package:kuuwaa/screens/settings/profile_screen.dart';
import 'package:kuuwaa/screens/setting_screen.dart';
import 'package:kuuwaa/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomBarScreen extends StatefulWidget {
  final String isFrom;
  const BottomBarScreen({Key? key, this.isFrom = ""}) : super(key: key);

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  AppColors appColors = AppColors();
  ImagePath imagePath = ImagePath();
  Widget? tabBar;

  bool? home = true;
  bool? profile = false;
  bool? wallet = false;
  bool? setting = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFrom == "Setting") {
      tabBar = const SettingScreen();
      home = false;
      profile = false;
      wallet = false;
      setting = true;
      setState(() {});
    }
    if (widget.isFrom == "Wallet") {
      tabBar = const WalletScreen();
      home = false;
      profile = false;
      wallet = true;
      setting = false;
      setState(() {});
    } else {
      tabBar = HomeScreen();
      home = true;
      profile = false;
      wallet = false;
      setting = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: appColors.white,
          systemNavigationBarIconBrightness: Brightness.dark,

          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,

          systemNavigationBarDividerColor: appColors.white
      ),
    );
    return SafeArea(
      top: false,
      bottom: !Platform.isIOS,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            tabBar!,
            Stack(
              children: [
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(72),
                  margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).moderateScale(10)),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage(imagePath.bottomBar),
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: ResponsiveFlutter.of(context).moderateScale(20),
                    left: ResponsiveFlutter.of(context).moderateScale(20),
                  ),
                  child: SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tabBar = HomeScreen();
                                home = true;
                                profile = false;
                                wallet = false;
                                setting = false;
                              });
                            },
                            child: Container(
                              height: ResponsiveFlutter.of(context).verticalScale(40),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(home! ? Icons.grid_view_rounded : Icons.grid_view, color: home! ? appColors.btnColor : appColors.iconColor.withOpacity(.5), size: 30,),
                                  MyTextView(
                                    "Accueil",
                                    textAligntNew: TextAlign.start,
                                    maxLinesNew: 3,
                                    styleNew: MyTextStyle(
                                      colorNew: home! ? appColors.btnColor : appColors.iconColor.withOpacity(.5),
                                      size: ResponsiveFlutter.of(context).fontSize(1.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tabBar = const WalletScreen();
                                home = false;
                                profile = false;
                                wallet = true;
                                setting = false;
                              });
                            },
                            child: Container(
                              height: ResponsiveFlutter.of(context).verticalScale(40),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(wallet! ? CupertinoIcons.money_dollar_circle_fill : CupertinoIcons.money_dollar_circle, color: wallet! ? appColors.btnColor : appColors.iconColor.withOpacity(.5), size: 30,),
                                  MyTextView(
                                    "Recharges",
                                    textAligntNew: TextAlign.start,
                                    maxLinesNew: 3,
                                    styleNew: MyTextStyle(
                                      colorNew: wallet! ? appColors.btnColor : appColors.iconColor.withOpacity(.5),
                                      size: ResponsiveFlutter.of(context).fontSize(1.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                 tabBar = const ProfileScreen();
                                 home = false;
                                 profile = true;
                                 wallet = false;
                                 setting = false;
                               });
                            },
                            child: Container(
                              height: ResponsiveFlutter.of(context).verticalScale(40),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Icon(profile! ? Icons.manage_accounts_rounded : Icons.manage_accounts_outlined, color: profile! ? appColors.btnColor : appColors.iconColor.withOpacity(.5), size: 30,),
                                      MyTextView(
                                        "Mon compte",
                                        textAligntNew: TextAlign.start,
                                        maxLinesNew: 3,
                                        styleNew: MyTextStyle(
                                          colorNew: profile! ? appColors.btnColor : appColors.iconColor.withOpacity(.5),
                                          size: ResponsiveFlutter.of(context).fontSize(1.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tabBar = const SettingScreen();
                                home = false;
                                profile = false;
                                wallet = false;
                                setting = true;
                              });
                            },
                            child: Container(
                              height: ResponsiveFlutter.of(context).verticalScale(40),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(setting! ? CupertinoIcons.gear_solid : CupertinoIcons.gear, color: setting! ? appColors.btnColor : appColors.iconColor.withOpacity(.5), size: 30,),
                                  MyTextView(
                                    "Parametres",
                                    textAligntNew: TextAlign.start,
                                    maxLinesNew: 3,
                                    styleNew: MyTextStyle(
                                      colorNew: setting! ? appColors.btnColor : appColors.iconColor.withOpacity(.5),
                                      size: ResponsiveFlutter.of(context).fontSize(1.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
