import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/auth/auth_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  AppColors appColors = AppColors();
  ImagePath imagePath = ImagePath();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  AuthViewModel authViewModel = AuthViewModel();
  bool loading = false;
  UserModel user = UserModel();
  UserViewModel userViewModel = UserViewModel();

  @override
  void initState() {
    userViewModel.getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: SafeArea(
        bottom: false,
        top: false,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child:
          Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(20)),
                  color: appColors.appMediumColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/logo.png", width: 70),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(25)),
                      MyTextView(
                        Strings.completeProfile,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          size: ResponsiveFlutter.of(context).fontSize(2.3),
                          fontWeightNew: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(15)),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(40),
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveFlutter.of(context).moderateScale(6),
                          horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                        ),
                        margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(
                            ResponsiveFlutter.of(context).moderateScale(25),
                          ),
                        ),
                        child: commonTestField(
                          context: context,
                          controller: _lastnameController,
                          hintText: Strings.yourName,
                          keyboardType: TextInputType.text,
                          icon: true,
                        ),
                      ),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(40),
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveFlutter.of(context).moderateScale(6),
                          horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                        ),
                        margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(
                            ResponsiveFlutter.of(context).moderateScale(25),
                          ),
                        ),
                        child: commonTestField(
                          context: context,
                          controller: _firstnameController,
                          hintText: Strings.yourFirstName,
                          keyboardType: TextInputType.text,
                          icon: true,
                        ),
                      ),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(40),
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveFlutter.of(context).moderateScale(6),
                          horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                        ),
                        margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(
                            ResponsiveFlutter.of(context).moderateScale(25),
                          ),
                        ),
                        child: commonTestField(
                          context: context,
                          controller: _addressController,
                          hintText: Strings.yourAddress,
                          keyboardType: TextInputType.text,
                          icon: true,
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).moderateScale(55)),
                        child: GestureDetector(
                          onTap: () {
                            if (!loading) {
                              if (_lastnameController.text == "") {
                                Utils.flushBarErrorMessage("Vous devez entrer votre nom", context);
                              } else if (_firstnameController.text == "") {
                                Utils.flushBarErrorMessage("Vous devez entrer votre prénom", context);
                              } else if (_addressController.text == "") {
                                Utils.flushBarErrorMessage("Vous devez entrer votre adresse", context);
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                authViewModel.completeProfileApi(
                                  {
                                    "firstname": _firstnameController.text,
                                    "lastname": _lastnameController.text,
                                    "address": _addressController.text
                                  }, user.id!, context);
                              }
                            }
                          },
                          child: CommonButton(
                            context: context,
                            title: Strings.save,
                            loading: loading,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: MyTextView(
                          "KuuWaa",
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.mediumGrayColor,
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.8),
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
