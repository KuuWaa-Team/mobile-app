import 'dart:async';

import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/constants.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/shared_pref.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuuwaa/service/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppColors appColors = AppColors();
  Utils utils = Utils();
  SharedPref pref = SharedPref();
  SplashService splashService = SplashService();

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
          () => SplashService().checkAuthentication(context)
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Constants.darkTheme ? Brightness.light : Brightness.dark,
        statusBarBrightness: Constants.darkTheme ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: appColors.white,
        systemNavigationBarDividerColor: appColors.white,
        systemNavigationBarIconBrightness: Constants.darkTheme ? Brightness.light : Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
          // image: DecorationImage(
          //   // image: AssetImage(ImagePath.splash),
          //   alignment: Alignment.center,
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Center(child: Image.asset(ImagePath.logo, width: 120,)),
      ),
    );
  }
}
