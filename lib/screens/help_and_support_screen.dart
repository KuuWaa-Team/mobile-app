import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/constants.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({Key? key}) : super(key: key);
  @override
  _HelpAndSupportScreenState createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  final AppColors appColors = AppColors();

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Impossible d'ouvrir : $url");
    }
  }

  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required String asset,
    required VoidCallback onTap,
    double iconPadding = 15,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          ResponsiveFlutter.of(context).moderateScale(25),
        ),
        child: Container(
          height: ResponsiveFlutter.of(context).verticalScale(120),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveFlutter.of(context).moderateScale(15),
            horizontal: ResponsiveFlutter.of(context).moderateScale(10),
          ),
          decoration: BoxDecoration(
            color: appColors.appLightColor,
            borderRadius: BorderRadius.circular(
              ResponsiveFlutter.of(context).moderateScale(25),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: ResponsiveFlutter.of(context).moderateScale(55),
                width: ResponsiveFlutter.of(context).moderateScale(55),
                padding: EdgeInsets.all(
                  ResponsiveFlutter.of(context).moderateScale(iconPadding),
                ),
                decoration: BoxDecoration(
                  color: Constants.darkTheme
                      ? appColors.appDarkColor
                      : appColors.lightPinkColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(asset),
              ),
              const Spacer(),
              MyTextView(
                title,
                textAligntNew: TextAlign.center,
                styleNew: MyTextStyle(
                  colorNew: appColors.lightColor,
                  fontWeightNew: FontWeight.w600,
                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                ),
              ),
              SizedBox(
                height: ResponsiveFlutter.of(context).verticalScale(3),
              ),
              MyTextView(
                subtitle,
                textAligntNew: TextAlign.center,
                maxLineWrap: true,
                styleNew: MyTextStyle(
                  colorNew: appColors.greyTextColor,
                  fontWeightNew: FontWeight.w500,
                  size: ResponsiveFlutter.of(context).fontSize(1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
bottom: !Platform.isIOS,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              title: Strings.helpSupport,
              context: context,
              backArrow: true,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                  vertical: ResponsiveFlutter.of(context).moderateScale(15),
                ),
                children: [
                  MyTextView(
                    Strings.howCanWeHelpYou,
                    maxLinesNew: 3,
                    textAligntNew: TextAlign.center,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w600,
                      size: ResponsiveFlutter.of(context).fontSize(2.2),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(10),
                  ),
                  MyTextView(
                    Strings.dummyText1,
                    textAligntNew: TextAlign.center,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor.withOpacity(.4),
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(1.8),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(20),
                  ),
                  // Ligne 1
                  Row(
                    children: [
                      _buildContactCard(
                        title: "Appeler",
                        subtitle: "+243 900 900 999",
                        asset: "assets/images/ic_phone.png",
                        onTap: () => _launchUrl("tel:+243900900999"),
                      ),
                      SizedBox(width: 8),
                      _buildContactCard(
                        title: "Email",
                        subtitle: "contact@kuuwaa.com",
                        asset: "assets/images/ic_gmail.webp",
                        onTap: () => _launchUrl(
                            "mailto:contact@kuuwaa.com?subject=Support%20KuuWaa"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Ligne 2
                  Row(
                    children: [
                      _buildContactCard(
                        title: "WhatsApp",
                        subtitle: "+243 900 900 999",
                        asset: "assets/images/wpp.png",
                        onTap: () => _launchUrl(
                            "https://wa.me/243900900999?text=Bonjour%20KuuWaa"),
                        iconPadding: 12,
                      ),
                      SizedBox(width: 8),
                      _buildContactCard(
                        title: "Facebook",
                        subtitle: "KuuWaa",
                        asset: "assets/images/ic_facebook.png",
                        onTap: () => _launchUrl(
                            "https://www.facebook.com/profile.php?id=61553935995126"),
                        iconPadding: 12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MyTextView(
                    "Ou rendez-vous sur notre site web",
                    textAligntNew: TextAlign.center,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.darkGreyText,
                      fontWeightNew: FontWeight.w500,
                      size: ResponsiveFlutter.of(context).fontSize(1.6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      _launchUrl("https://www.kuuwaa.com");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyTextView(
                          "www.kuuwaa.com",
                          textAligntNew: TextAlign.center,
                          maxLineWrap: true,
                          styleNew: MyTextStyle(
                            colorNew: appColors.btnColor,
                            fontWeightNew: FontWeight.w600,
                            size: ResponsiveFlutter.of(context).fontSize(1.9),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Icon(Icons.open_in_new, size: 19, color: appColors.btnColor,)
                      ],
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
}
