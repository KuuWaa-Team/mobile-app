import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/check_out_screen.dart';
import 'package:kuuwaa/screens/invitations/invitations_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvitationDetailsScreen extends StatefulWidget {
  const InvitationDetailsScreen({Key? key}) : super(key: key);
  @override
  _InvitationDetailsScreenState createState() => _InvitationDetailsScreenState();
}

class _InvitationDetailsScreenState extends State<InvitationDetailsScreen> {
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.32,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(ImagePath.image_4,)
                  ),
                  color: appColors.appMediumColor,
                  // borderRadius: BorderRadius.circular(20)
                ),
                width: MediaQuery.of(context).size.width,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.25,
                      left: ResponsiveFlutter.of(context).moderateScale(20),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: appColors.appDarkColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.back,
                            color: appColors.lightColor,
                            size: ResponsiveFlutter.of(context).moderateScale(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.25,
                      left: ResponsiveFlutter.of(context).moderateScale(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: appColors.appDarkColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.download_rounded,
                            color: appColors.lightColor,
                            size: ResponsiveFlutter.of(context).moderateScale(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.25,
                      right: ResponsiveFlutter.of(context).moderateScale(25),
                      left: ResponsiveFlutter.of(context).moderateScale(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: appColors.appDarkColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.update,
                            color: appColors.lightColor,
                            size: ResponsiveFlutter.of(context).moderateScale(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.22),
                padding: EdgeInsets.only(
                  right: ResponsiveFlutter.of(context).moderateScale(20),
                  left: ResponsiveFlutter.of(context).moderateScale(20),
                  top: MediaQuery.of(context).padding.top + ResponsiveFlutter.of(context).moderateScale(55),
                  bottom: MediaQuery.of(context).padding.bottom + ResponsiveFlutter.of(context).moderateScale(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyTextView(
                            "Mariage de Zenas",
                            textAligntNew: TextAlign.start,
                            maxLineWrap: true,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w600,
                              size: ResponsiveFlutter.of(context).fontSize(2.2),
                            ),
                          ),
                          SizedBox(width: ResponsiveFlutter.of(context).moderateScale(20)),
                          Container(
                            height: ResponsiveFlutter.of(context).moderateScale(30),
                            width: ResponsiveFlutter.of(context).moderateScale(120),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: appColors.blurBtnColor,
                              borderRadius: BorderRadius.circular(
                                ResponsiveFlutter.of(context).moderateScale(20),
                              ),
                            ),
                            child: MyTextView(
                              "Mariage Réligieux",
                              textAligntNew: TextAlign.center,
                              maxLineWrap: true,
                              styleNew: MyTextStyle(
                                colorNew: appColors.lightPinkColor,
                                fontWeightNew: FontWeight.w500,
                                size: ResponsiveFlutter.of(context).fontSize(1.2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                      MyTextView(
                        Strings.dummyText27,
                        textAligntNew: TextAlign.start,
                        maxLineWrap: true,
                        maxLinesNew: 4,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.7),
                        ),
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(15)),
                      Row(
                        children: [
                          Image.asset(
                            ImagePath.calender,
                            color: appColors.lightColor,
                            height: ResponsiveFlutter.of(context).moderateScale(15),
                          ),
                          SizedBox(width: ResponsiveFlutter.of(context).moderateScale(8)),
                          MyTextView(
                            Strings.dummyText22,
                            textAligntNew: TextAlign.start,
                            maxLineWrap: true,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.6),
                            ),
                          ),
                          SizedBox(width: ResponsiveFlutter.of(context).moderateScale(20)),
                          Image.asset(
                            ImagePath.time,
                            color: appColors.lightColor,
                            height: ResponsiveFlutter.of(context).moderateScale(15),
                          ),
                          SizedBox(width: ResponsiveFlutter.of(context).moderateScale(8)),
                          MyTextView(
                            Strings.dummyText23,
                            textAligntNew: TextAlign.start,
                            maxLineWrap: true,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                      Container(
                        height: ResponsiveFlutter.of(context).moderateScale(55),
                        width: double.infinity,
                        padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(10)),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(
                            ResponsiveFlutter.of(context).moderateScale(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                            Image.asset(
                              ImagePath.location,
                              color: appColors.lightColor,
                              height: ResponsiveFlutter.of(context).moderateScale(15),
                            ),
                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(8)),
                            MyTextView(
                              "Université de kinshasa",
                              textAligntNew: TextAlign.start,
                              maxLineWrap: true,
                              styleNew: MyTextStyle(
                                colorNew: appColors.lightColor,
                                fontWeightNew: FontWeight.w500,
                                size: ResponsiveFlutter.of(context).fontSize(2),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: ResponsiveFlutter.of(context).moderateScale(35),
                              height: double.infinity,
                              padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(10)),
                              margin: EdgeInsets.only(left: ResponsiveFlutter.of(context).moderateScale(5)),
                              decoration: BoxDecoration(
                                color: appColors.lightPinkColor,
                                borderRadius: BorderRadius.circular(
                                  ResponsiveFlutter.of(context).moderateScale(13),
                                ),
                              ),
                              child: Image.asset(ImagePath.mapIcon),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: appColors.appMediumColor,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only( // <-- SEE HERE
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        MyTextView(
                                          "Quelle boisson allez-vous prendre ?",
                                          textAligntNew: TextAlign.center,
                                          styleNew: MyTextStyle(
                                            colorNew: appColors.lightColor,
                                            fontWeightNew: FontWeight.w400,
                                            size: ResponsiveFlutter.of(context).fontSize(2),
                                          ),
                                        ),
                                        const SizedBox(height: 30,),
                                        Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: ResponsiveFlutter.of(context).moderateScale(15),
                                                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                              ),
                                              margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                                              decoration: BoxDecoration(
                                                color: appColors.appLightColor,
                                                borderRadius: BorderRadius.circular(
                                                  ResponsiveFlutter.of(context).moderateScale(25),
                                                ),
                                              ),
                                              child: MyTextView(
                                                "Castel Beer",
                                                textAligntNew: TextAlign.center,
                                                styleNew: MyTextStyle(
                                                  colorNew: appColors.lightColor,
                                                  fontWeightNew: FontWeight.w400,
                                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: ResponsiveFlutter.of(context).moderateScale(15),
                                                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                              ),
                                              margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                                              decoration: BoxDecoration(
                                                color: appColors.appLightColor,
                                                borderRadius: BorderRadius.circular(
                                                  ResponsiveFlutter.of(context).moderateScale(25),
                                                ),
                                              ),
                                              child: MyTextView(
                                                "Turbo King",
                                                textAligntNew: TextAlign.center,
                                                styleNew: MyTextStyle(
                                                  colorNew: appColors.lightColor,
                                                  fontWeightNew: FontWeight.w400,
                                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: ResponsiveFlutter.of(context).moderateScale(15),
                                                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                              ),
                                              margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                                              decoration: BoxDecoration(
                                                color: appColors.appLightColor,
                                                borderRadius: BorderRadius.circular(
                                                  ResponsiveFlutter.of(context).moderateScale(25),
                                                ),
                                              ),
                                              child: MyTextView(
                                                "Heineken",
                                                textAligntNew: TextAlign.center,
                                                styleNew: MyTextStyle(
                                                  colorNew: appColors.lightColor,
                                                  fontWeightNew: FontWeight.w400,
                                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: ResponsiveFlutter.of(context).moderateScale(15),
                                                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                              ),
                                              margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                                              decoration: BoxDecoration(
                                                color: appColors.appLightColor,
                                                borderRadius: BorderRadius.circular(
                                                  ResponsiveFlutter.of(context).moderateScale(25),
                                                ),
                                              ),
                                              child: MyTextView(
                                                "Maltina",
                                                textAligntNew: TextAlign.center,
                                                styleNew: MyTextStyle(
                                                  colorNew: appColors.lightColor,
                                                  fontWeightNew: FontWeight.w400,
                                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: ResponsiveFlutter.of(context).moderateScale(15),
                                                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                              ),
                                              margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                                              decoration: BoxDecoration(
                                                color: appColors.appLightColor,
                                                borderRadius: BorderRadius.circular(
                                                  ResponsiveFlutter.of(context).moderateScale(25),
                                                ),
                                              ),
                                              child: MyTextView(
                                                "Coca cola",
                                                textAligntNew: TextAlign.center,
                                                styleNew: MyTextStyle(
                                                  colorNew: appColors.lightColor,
                                                  fontWeightNew: FontWeight.w400,
                                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: ResponsiveFlutter.of(context).moderateScale(15),
                                                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                              ),
                                              margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                                              decoration: BoxDecoration(
                                                color: appColors.appLightColor,
                                                borderRadius: BorderRadius.circular(
                                                  ResponsiveFlutter.of(context).moderateScale(25),
                                                ),
                                              ),
                                              child: MyTextView(
                                                "Energy malt",
                                                textAligntNew: TextAlign.center,
                                                styleNew: MyTextStyle(
                                                  colorNew: appColors.lightColor,
                                                  fontWeightNew: FontWeight.w400,
                                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: ResponsiveFlutter.of(context).moderateScale(15),
                                                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                              ),
                                              margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                                              decoration: BoxDecoration(
                                                color: appColors.appLightColor,
                                                borderRadius: BorderRadius.circular(
                                                  ResponsiveFlutter.of(context).moderateScale(25),
                                                ),
                                              ),
                                              child: MyTextView(
                                                "Vital'o",
                                                textAligntNew: TextAlign.center,
                                                styleNew: MyTextStyle(
                                                  colorNew: appColors.lightColor,
                                                  fontWeightNew: FontWeight.w400,
                                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10)),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        child: Container(
                          height: ResponsiveFlutter.of(context).moderateScale(40),
                          margin: EdgeInsets.only(
                            bottom: ResponsiveFlutter.of(context).moderateScale(10),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              ResponsiveFlutter.of(context).moderateScale(25),
                            ), // Creates border
                            color: appColors.btnColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyTextView(
                                "Je serais là",
                                textAligntNew: TextAlign.start,
                                maxLineWrap: true,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.white,
                                  fontWeightNew: FontWeight.w600,
                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                        },
                        child: Container(
                          height: ResponsiveFlutter.of(context).moderateScale(40),
                          margin: EdgeInsets.only(
                            bottom: ResponsiveFlutter.of(context).moderateScale(20),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              ResponsiveFlutter.of(context).moderateScale(25),
                            ), // Creates border
                            color: appColors.appLightColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyTextView(
                                "Je ne serais pas là",
                                textAligntNew: TextAlign.start,
                                maxLineWrap: true,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.white,
                                  fontWeightNew: FontWeight.w600,
                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.17,),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.17,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: appColors.appLightColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                      ),
                      child: Image.asset(ImagePath.code,)),
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
