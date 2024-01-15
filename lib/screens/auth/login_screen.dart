import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/auth/auth_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppColors appColors = AppColors();
  ImagePath imagePath = ImagePath();
  final TextEditingController _phoneController = TextEditingController();
  bool loading = false;
  AuthViewModel authViewModel = AuthViewModel();

  var maskFormatter = MaskTextInputFormatter(
      mask: '*## ### ###',
      filter: { "#": RegExp(r'\d'), "*": RegExp(r'[1-9]') },
      type: MaskAutoCompletionType.lazy
  );

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
                        Strings.login,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          size: ResponsiveFlutter.of(context).fontSize(2.7),
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
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(50),
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveFlutter.of(context).moderateScale(10),
                          horizontal: ResponsiveFlutter.of(context).moderateScale(25),
                        ),
                        margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(25)),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(
                            ResponsiveFlutter.of(context).moderateScale(25),
                          ),
                        ),
                        child: commonTestField(
                          context: context,
                          controller: _phoneController,
                          initial: "+243",
                          hintText: Strings.yourPhoneNumber,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [maskFormatter],
                          icon: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).moderateScale(55)),
                        child: GestureDetector(
                          onTap: () async {
                            if (!loading) {
                              if (_phoneController.text == "") {
                                Utils.flushBarErrorMessage("Vous devez entrer le numéro de téléphone", context);
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                await authViewModel.loginApi({
                                  "phoneNumber": _phoneController.text
                                }, context).then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
                            }
                          },
                          child: CommonButton(
                            loading: loading,
                            context: context,
                            title: Strings.next,
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
