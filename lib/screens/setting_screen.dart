import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/constants.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/shared_pref.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/model/common_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/about_us_screen.dart';
import 'package:kuuwaa/screens/help_and_support_screen.dart';
import 'package:kuuwaa/screens/auth/login_screen.dart';
import 'package:kuuwaa/screens/privacy_policy_screen.dart';
import 'package:kuuwaa/screens/terms_and_condition_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  AppColors appColors = AppColors();
  SharedPref pref = SharedPref();

  List<CommonModel>? settingsList = [
    CommonModel(image: ImagePath.question, title: Strings.helpAndSupport),
    CommonModel(image: ImagePath.lock, title: Strings.privacyPolicy +  "ssss"),
    // CommonModel(image: ImagePath.question, title: Strings.termsAndCondition),
    // CommonModel(image: ImagePath.info, title: Strings.aboutUs),
  ];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: appColors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
          systemNavigationBarDividerColor: appColors.white
      ),
    );
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              title: Strings.settings,
              backArrow: false,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                      vertical: ResponsiveFlutter.of(context).moderateScale(15),
                    ),
                    itemCount: settingsList!.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpAndSupportScreen(),
                            ),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyScreen(),
                            ),
                          );
                        }
                        // else if (index == 2) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const TermsAndConditionScreen(),
                        //     ),
                        //   );
                        // } else if (index == 3) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const AboutUsScreen(),
                        //     ),
                        //   );
                        // }
                      },
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: ResponsiveFlutter.of(context).verticalScale(52),
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              left: ResponsiveFlutter.of(context).moderateScale(15),
                            ),
                            padding: EdgeInsets.only(
                              right: ResponsiveFlutter.of(context).moderateScale(20),
                              left: ResponsiveFlutter.of(context).moderateScale(40),
                            ),
                            decoration: BoxDecoration(
                              color: appColors.appLightColor,
                              borderRadius: BorderRadius.circular(
                                ResponsiveFlutter.of(context).moderateScale(17),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyTextView(
                                  settingsList![index].title!,
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                  ),
                                ),
                                Image(
                                  image: const AssetImage(ImagePath.back),
                                  height: ResponsiveFlutter.of(context).verticalScale(13),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: ResponsiveFlutter.of(context).verticalScale(40),
                            width: ResponsiveFlutter.of(context).scale(40),
                            padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).moderateScale(12)),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appColors.white,
                              border: Border.all(
                                color: appColors.appMediumColor,
                                width: ResponsiveFlutter.of(context).scale(3),
                              ),
                            ),
                            child: Image(
                              image: AssetImage(settingsList![index].image!),
                            ),
                          ),
                        ],
                      ),
                    ),
                    separatorBuilder: (context, index) => SizedBox(
                      height: ResponsiveFlutter.of(context).verticalScale(5),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(50),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveFlutter.of(context).moderateScale(70),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        UserViewModel().remove().then((value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                                (route) => false,
                          );
                        });
                      },
                      child: Container(
                        height: ResponsiveFlutter.of(context).scale(40),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: appColors.btnColor,
                          borderRadius: BorderRadius.circular(
                            ResponsiveFlutter.of(context).moderateScale(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout, color: Colors.white,),
                            SizedBox(
                              width: ResponsiveFlutter.of(context).scale(10),
                            ),
                            MyTextView(
                              "Se déconnecter",
                              textAligntNew: TextAlign.center,
                              styleNew: MyTextStyle(
                                colorNew: appColors.white,
                                fontWeightNew: FontWeight.w600,
                                size: ResponsiveFlutter.of(context).fontSize(2),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Future<void> storeThemeColor() async {
    pref.saveString(pref.theme, Constants.darkTheme ? "1" : "0");
  }
}
