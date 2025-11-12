import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/verification_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  AppColors appColors = AppColors();
  ImagePath imagePath = ImagePath();
  TextEditingController? email = TextEditingController();
  TextEditingController? password = TextEditingController();
  TextEditingController? firstName = TextEditingController();
  TextEditingController? lastName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
bottom: !Platform.isIOS,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(20)),
                  color: appColors.appMediumColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MyTextView(
                        Strings.signUp,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          size: ResponsiveFlutter.of(context).fontSize(3.7),
                          fontWeightNew: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(5)),
                      MyTextView(
                        Strings.pleaseFillTheDetails,
                        styleNew: MyTextStyle(
                          colorNew: appColors.mediumGrayColor,
                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                          fontWeightNew: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(25)),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: ResponsiveFlutter.of(context).verticalScale(170),
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveFlutter.of(context).moderateScale(20),
                              horizontal: ResponsiveFlutter.of(context).moderateScale(25),
                            ),
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(25)),
                            decoration: BoxDecoration(
                              color: appColors.appLightColor,
                              borderRadius: BorderRadius.circular(
                                ResponsiveFlutter.of(context).moderateScale(25),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: commonTestField(
                                        context: context,
                                        controller: firstName,
                                        hintText: Strings.firstName,
                                        image: ImagePath.avatar,
                                        keyboardType: TextInputType.name,
                                        obscureText: false,
                                        icon: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: commonTestField(
                                        context: context,
                                        controller: lastName,
                                        hintText: Strings.lastName,
                                        image: ImagePath.avatar,
                                        keyboardType: TextInputType.name,
                                        obscureText: false,
                                        icon: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: ResponsiveFlutter.of(context).verticalScale(20)),
                                commonTestField(
                                  context: context,
                                  controller: email,
                                  hintText: Strings.emailAddress,
                                  image: ImagePath.email,
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                  icon: true,
                                ),
                                SizedBox(height: ResponsiveFlutter.of(context).verticalScale(20)),
                                commonTestField(
                                  context: context,
                                  controller: password,
                                  hintText: Strings.password,
                                  image: ImagePath.password,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  icon: true,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveFlutter.of(context).moderateScale(55),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const VerificationScreen(),
                                  ),
                                );
                              },
                              child: CommonButton(
                                context: context,
                                title: Strings.signUp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: MyTextView(
                          Strings.doNotHaveAnAccount,
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.mediumGrayColor,
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.8),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(5)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: MyTextView(
                            Strings.login,
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightPinkColor,
                              fontWeightNew: FontWeight.bold,
                              size: ResponsiveFlutter.of(context).fontSize(2),
                            ),
                          ),
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
    );
  }
}
