import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuuwaa/view_model/auth/auth_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key, this.message}) : super(key: key);
  String? message;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  AppColors appColors = AppColors();
  ImagePath imagePath = ImagePath();
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  TextEditingController otp5Controller = TextEditingController();
  String otp = "";

  AuthViewModel authViewModel = AuthViewModel();
  bool loading = false;

  var maskFormatter = MaskTextInputFormatter(
      mask: '### ### ###',
      filter: { "#": RegExp(r'\d') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    listenOtp();
    super.initState();
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
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
                        Strings.enterCode,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          size: ResponsiveFlutter.of(context).fontSize(2.7),
                          fontWeightNew: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(5)),
                      Center(
                        child: MyTextView(
                          widget.message ?? "",
                          textAligntNew: TextAlign.center,
                          maxLinesNew: 3,
                          styleNew: MyTextStyle(
                            colorNew: appColors.mediumGrayColor,
                            size: ResponsiveFlutter.of(context).fontSize(1.6),
                            fontWeightNew: FontWeight.w400,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  LoginScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        child: MyTextView(
                          "Changer de numéro",
                          textAligntNew: TextAlign.center,
                          maxLinesNew: 3,
                          styleNew: MyTextStyle(
                            colorNew: Colors.white,
                            size: ResponsiveFlutter.of(context).fontSize(1.6),
                            fontWeightNew: FontWeight.w400,
                          ),
                        )
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(5)),
                      PinFieldAutoFill(
                        cursor: Cursor(color: appColors.lightColor, width: 2, height: 16, enabled: true),
                        currentCode: otp,
                        codeLength: 5,
                        decoration: BoxLooseDecoration(
                          strokeColorBuilder: PinListenColorBuilder(appColors.appLightColor, appColors.appLightColor,),
                          bgColorBuilder: FixedColorBuilder(appColors.appLightColor),
                          strokeWidth: 0,
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: appColors.lightColor
                          ),
                          radius: Radius.circular(ResponsiveFlutter.of(context).moderateScale(15))
                        ),
                        onCodeChanged: (code) {
                          setState(() {
                            otp = code ?? '';
                          });
                        },
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Container(
                      //       width: ResponsiveFlutter.of(context).scale(50),
                      //       height: ResponsiveFlutter.of(context).verticalScale(50),
                      //       decoration: BoxDecoration(
                      //         color: appColors.appLightColor,
                      //         borderRadius: BorderRadius.circular(
                      //           ResponsiveFlutter.of(context).moderateScale(15),
                      //         ),
                      //       ),
                      //       child: Center(
                      //         child: TextField(
                      //           controller: otp1Controller,
                      //           keyboardType: TextInputType.number,
                      //           maxLength: 1,
                      //           style: MyTextStyle(
                      //             colorNew: appColors.lightColor,
                      //             fontWeightNew: FontWeight.w500,
                      //             size: ResponsiveFlutter.of(context).fontSize(1.9),
                      //           ),
                      //           cursorColor: appColors.lightColor,
                      //           inputFormatters: [
                      //             LengthLimitingTextInputFormatter(1),
                      //             FilteringTextInputFormatter.digitsOnly
                      //           ],
                      //           onChanged: (value) {
                      //             if (value.length == 1) {
                      //               FocusScope.of(context).nextFocus();
                      //             }
                      //           },
                      //           textAlign: TextAlign.center,
                      //           decoration: InputDecoration(
                      //             counterText: "",
                      //             border: InputBorder.none,
                      //             isDense: true,
                      //             hintStyle: MyTextStyle(
                      //               colorNew: appColors.mediumLightColor,
                      //               fontWeightNew: FontWeight.w400,
                      //               size: ResponsiveFlutter.of(context).fontSize(1.9),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: ResponsiveFlutter.of(context).scale(50),
                      //       height: ResponsiveFlutter.of(context).verticalScale(50),
                      //       decoration: BoxDecoration(
                      //         color: appColors.appLightColor,
                      //         borderRadius: BorderRadius.circular(
                      //           ResponsiveFlutter.of(context).moderateScale(15),
                      //         ),
                      //       ),
                      //       child: Center(
                      //         child: TextField(
                      //           controller: otp2Controller,
                      //           keyboardType: TextInputType.number,
                      //           maxLength: 1,
                      //           style: MyTextStyle(
                      //             colorNew: appColors.lightColor,
                      //             fontWeightNew: FontWeight.w500,
                      //             size: ResponsiveFlutter.of(context).fontSize(1.9),
                      //           ),
                      //           cursorColor: appColors.lightColor,
                      //           inputFormatters: [
                      //             LengthLimitingTextInputFormatter(1),
                      //             FilteringTextInputFormatter.digitsOnly
                      //           ],
                      //           onChanged: (value) {
                      //             if (value.length == 1) {
                      //               FocusScope.of(context).nextFocus();
                      //             }
                      //           },
                      //           textAlign: TextAlign.center,
                      //           decoration: InputDecoration(
                      //             counterText: "",
                      //             border: InputBorder.none,
                      //             isDense: true,
                      //             hintStyle: MyTextStyle(
                      //               colorNew: appColors.mediumLightColor,
                      //               fontWeightNew: FontWeight.w400,
                      //               size: ResponsiveFlutter.of(context).fontSize(1.9),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: ResponsiveFlutter.of(context).scale(50),
                      //       height: ResponsiveFlutter.of(context).verticalScale(50),
                      //       decoration: BoxDecoration(
                      //         color: appColors.appLightColor,
                      //         borderRadius: BorderRadius.circular(
                      //           ResponsiveFlutter.of(context).moderateScale(15),
                      //         ),
                      //       ),
                      //       child: Center(
                      //         child: TextField(
                      //           controller: otp3Controller,
                      //           keyboardType: TextInputType.number,
                      //           maxLength: 1,
                      //           style: MyTextStyle(
                      //             colorNew: appColors.lightColor,
                      //             fontWeightNew: FontWeight.w500,
                      //             size: ResponsiveFlutter.of(context).fontSize(1.9),
                      //           ),
                      //           cursorColor: appColors.lightColor,
                      //           textAlign: TextAlign.center,
                      //           inputFormatters: [
                      //             LengthLimitingTextInputFormatter(1),
                      //             FilteringTextInputFormatter.digitsOnly
                      //           ],
                      //           onChanged: (value) {
                      //             if (value.length == 1) {
                      //               FocusScope.of(context).nextFocus();
                      //             }
                      //           },
                      //           decoration: InputDecoration(
                      //             counterText: "",
                      //             border: InputBorder.none,
                      //             isDense: true,
                      //             hintStyle: MyTextStyle(
                      //               colorNew: appColors.mediumLightColor,
                      //               fontWeightNew: FontWeight.w400,
                      //               size: ResponsiveFlutter.of(context).fontSize(1.9),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: ResponsiveFlutter.of(context).scale(50),
                      //       height: ResponsiveFlutter.of(context).verticalScale(50),
                      //       decoration: BoxDecoration(
                      //         color: appColors.appLightColor,
                      //         borderRadius: BorderRadius.circular(
                      //           ResponsiveFlutter.of(context).moderateScale(15),
                      //         ),
                      //       ),
                      //       child: Center(
                      //         child: TextField(
                      //           controller: otp4Controller,
                      //           keyboardType: TextInputType.number,
                      //           maxLength: 1,
                      //           style: MyTextStyle(
                      //             colorNew: appColors.lightColor,
                      //             fontWeightNew: FontWeight.w500,
                      //             size: ResponsiveFlutter.of(context).fontSize(1.9),
                      //           ),
                      //           cursorColor: appColors.lightColor,
                      //           textAlign: TextAlign.center,
                      //           inputFormatters: [
                      //             LengthLimitingTextInputFormatter(1),
                      //             FilteringTextInputFormatter.digitsOnly
                      //           ],
                      //           onChanged: (value) {
                      //             if (value.length == 1) {
                      //               FocusScope.of(context).nextFocus();
                      //             }
                      //           },
                      //           decoration: InputDecoration(
                      //             counterText: "",
                      //             border: InputBorder.none,
                      //             isDense: true,
                      //             hintStyle: MyTextStyle(
                      //               colorNew: appColors.mediumLightColor,
                      //               fontWeightNew: FontWeight.w400,
                      //               size: ResponsiveFlutter.of(context).fontSize(1.9),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: ResponsiveFlutter.of(context).scale(50),
                      //       height: ResponsiveFlutter.of(context).verticalScale(50),
                      //       decoration: BoxDecoration(
                      //         color: appColors.appLightColor,
                      //         borderRadius: BorderRadius.circular(
                      //           ResponsiveFlutter.of(context).moderateScale(15),
                      //         ),
                      //       ),
                      //       child: Center(
                      //         child: TextField(
                      //           controller: otp5Controller,
                      //           keyboardType: TextInputType.number,
                      //           maxLength: 1,
                      //           style: MyTextStyle(
                      //             colorNew: appColors.lightColor,
                      //             fontWeightNew: FontWeight.w500,
                      //             size: ResponsiveFlutter.of(context).fontSize(1.9),
                      //           ),
                      //           cursorColor: appColors.lightColor,
                      //           textAlign: TextAlign.center,
                      //           inputFormatters: [
                      //             LengthLimitingTextInputFormatter(1),
                      //             FilteringTextInputFormatter.digitsOnly
                      //           ],
                      //           decoration: InputDecoration(
                      //             counterText: "",
                      //             border: InputBorder.none,
                      //             isDense: true,
                      //             hintStyle: MyTextStyle(
                      //               colorNew: appColors.mediumLightColor,
                      //               fontWeightNew: FontWeight.w400,
                      //               size: ResponsiveFlutter.of(context).fontSize(1.9),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ]
                      // ),
                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(25)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).moderateScale(55)),
                        child: GestureDetector(
                          onTap: () async {
                            if (!loading) {
                              if (otp.length < 5) {
                                Utils.flushBarErrorMessage("Le code est incomplet", context);
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                await authViewModel.otpVerificationApi(
                                    {
                                      "otp": otp
                                    }, context).then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              }
                            }
                          },
                          child: CommonButton(
                            context: context,
                            title: Strings.next,
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
