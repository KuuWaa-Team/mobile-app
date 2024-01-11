import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/constants.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class InvitesScreen extends StatefulWidget {
  const InvitesScreen({Key? key}) : super(key: key);
  @override
  _InvitesScreenState createState() => _InvitesScreenState();
}

class _InvitesScreenState extends State<InvitesScreen> {
  AppColors appColors = AppColors();
  bool? showNotification = true;
  bool? paymentNotification = true;
  bool? liveNotification = false;
  bool? invitationNotification = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              title: Strings.myInvites,
              backArrow: true,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: appColors.appMediumColor,
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
                                  Strings.addInvite,
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w600,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(height: 15,),
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
                                    // controller: phone,
                                    hintText: "Civilité",
                                    keyboardType: TextInputType.phone,
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
                                    // controller: phone,
                                    hintText: "Nom complet",
                                    keyboardType: TextInputType.phone,
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
                                    // controller: phone,
                                    hintText: "Numéro de téléphone",
                                    keyboardType: TextInputType.phone,
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
                                    // controller: phone,
                                    hintText: "Table",
                                    keyboardType: TextInputType.phone,
                                    icon: true,
                                  ),
                                ),
                                Container(
                                  height: ResponsiveFlutter.of(context).verticalScale(40),
                                  padding: EdgeInsets.only(
                                    top: ResponsiveFlutter.of(context).moderateScale(6),
                                    bottom: ResponsiveFlutter.of(context).moderateScale(6),
                                    left: ResponsiveFlutter.of(context).moderateScale(15),
                                    right: ResponsiveFlutter.of(context).moderateScale(15),
                                  ),
                                  margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                                  decoration: BoxDecoration(
                                      color: appColors.btnColor,
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyTextView(
                                        Strings.save,
                                        textAligntNew: TextAlign.center,
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.lightColor,
                                          fontWeightNew: FontWeight.w600,
                                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                                        ),
                                      ),
                                    ],
                                  ),
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
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                ),
                decoration: BoxDecoration(
                    color: appColors.btnColor,
                    borderRadius: BorderRadius.circular(30)
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 20,),
                    const SizedBox(width: 5,),
                    MyTextView(
                      Strings.addInvite,
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w600,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: ResponsiveFlutter.of(context).moderateScale(20),
                right: ResponsiveFlutter.of(context).moderateScale(20),
                top: ResponsiveFlutter.of(context).moderateScale(10),
              ),
              child: CupertinoSearchTextField(
                padding: const EdgeInsets.only(top: 7, bottom: 7, left: 10, right: 10),
                prefixIcon: Icon(CupertinoIcons.search, color: appColors.lightColor.withOpacity(.4), size: 15,),
                style: TextStyle(
                  color: appColors.lightColor,
                  fontSize: 14
                ),

                placeholder: "Rechercher",
                onChanged: (String value) {
                },
                onSubmitted: (String value) {
                },
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveFlutter.of(context).verticalScale(15),
                  horizontal: ResponsiveFlutter.of(context).scale(20),
                ),
                children: [
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: ResponsiveFlutter.of(context).moderateScale(20),
                        ),
                        padding: const EdgeInsets.fromLTRB(35, 15, 15, 15),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyTextView(
                                      "Daniel Mwema",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor,
                                        fontWeightNew: FontWeight.w600,
                                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                                      ),
                                    ),
                                    const SizedBox(height: 3,),
                                    MyTextView(
                                      "+243 814 063 056",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor.withOpacity(.5),
                                        fontWeightNew: FontWeight.w400,
                                        size: ResponsiveFlutter.of(context).fontSize(1.2),
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.check_circle_outline, color: Colors.green,)
                              ],
                            ),
                            Divider(
                              height: ResponsiveFlutter.of(context).moderateScale(25),
                              color: appColors.dividerColor,
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                MyTextView(
                                  "Boisson",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "Cascal",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                MyTextView(
                                  "Table",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "Java",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(43),
                        width: ResponsiveFlutter.of(context).scale(43),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).moderateScale(10)),
                        margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).moderateScale(10)),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColors.white,
                          border: Border.all(
                            color: appColors.appMediumColor,
                            width: ResponsiveFlutter.of(context).scale(2.5),
                          ),
                        ),
                        child: MyTextView(
                          "DM",
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.btnColor,
                            fontWeightNew: FontWeight.w700,
                            size: ResponsiveFlutter.of(context).fontSize(1.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: ResponsiveFlutter.of(context).moderateScale(20),
                        ),
                        padding: const EdgeInsets.fromLTRB(35, 15, 15, 15),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyTextView(
                                      "Daniel Mwema",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor,
                                        fontWeightNew: FontWeight.w600,
                                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                                      ),
                                    ),
                                    const SizedBox(height: 3,),
                                    MyTextView(
                                      "+243 814 063 056",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor.withOpacity(.5),
                                        fontWeightNew: FontWeight.w400,
                                        size: ResponsiveFlutter.of(context).fontSize(1.2),
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.history_rounded, color: Colors.orange,)
                              ],
                            ),
                            Divider(
                              height: ResponsiveFlutter.of(context).moderateScale(25),
                              color: appColors.dividerColor,
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                MyTextView(
                                  "Boisson",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "-",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                MyTextView(
                                  "Table",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "Java",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(43),
                        width: ResponsiveFlutter.of(context).scale(43),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).moderateScale(10)),
                        margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).moderateScale(10)),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColors.white,
                          border: Border.all(
                            color: appColors.appMediumColor,
                            width: ResponsiveFlutter.of(context).scale(2.5),
                          ),
                        ),
                        child: MyTextView(
                          "DM",
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.btnColor,
                            fontWeightNew: FontWeight.w700,
                            size: ResponsiveFlutter.of(context).fontSize(1.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: ResponsiveFlutter.of(context).moderateScale(20),
                        ),
                        padding: const EdgeInsets.fromLTRB(35, 15, 15, 15),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyTextView(
                                      "Daniel Mwema",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor,
                                        fontWeightNew: FontWeight.w600,
                                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                                      ),
                                    ),
                                    const SizedBox(height: 3,),
                                    MyTextView(
                                      "+243 814 063 056",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor.withOpacity(.5),
                                        fontWeightNew: FontWeight.w400,
                                        size: ResponsiveFlutter.of(context).fontSize(1.2),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.cancel_outlined, color: appColors.red,)
                              ],
                            ),
                            Divider(
                              height: ResponsiveFlutter.of(context).moderateScale(25),
                              color: appColors.dividerColor,
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                MyTextView(
                                  "Boisson",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "-",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                MyTextView(
                                  "Table",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "Java",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(43),
                        width: ResponsiveFlutter.of(context).scale(43),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).moderateScale(10)),
                        margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).moderateScale(10)),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColors.white,
                          border: Border.all(
                            color: appColors.appMediumColor,
                            width: ResponsiveFlutter.of(context).scale(2.5),
                          ),
                        ),
                        child: MyTextView(
                          "DM",
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.btnColor,
                            fontWeightNew: FontWeight.w700,
                            size: ResponsiveFlutter.of(context).fontSize(1.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: ResponsiveFlutter.of(context).moderateScale(20),
                        ),
                        padding: const EdgeInsets.fromLTRB(35, 15, 15, 15),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyTextView(
                                      "Daniel Mwema",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor,
                                        fontWeightNew: FontWeight.w600,
                                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                                      ),
                                    ),
                                    const SizedBox(height: 3,),
                                    MyTextView(
                                      "+243 814 063 056",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor.withOpacity(.5),
                                        fontWeightNew: FontWeight.w400,
                                        size: ResponsiveFlutter.of(context).fontSize(1.2),
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.check_circle_outline, color: Colors.green,)
                              ],
                            ),
                            Divider(
                              height: ResponsiveFlutter.of(context).moderateScale(25),
                              color: appColors.dividerColor,
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                MyTextView(
                                  "Boisson",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "Cascal",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                MyTextView(
                                  "Table",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "Java",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(43),
                        width: ResponsiveFlutter.of(context).scale(43),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).moderateScale(10)),
                        margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).moderateScale(10)),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColors.white,
                          border: Border.all(
                            color: appColors.appMediumColor,
                            width: ResponsiveFlutter.of(context).scale(2.5),
                          ),
                        ),
                        child: MyTextView(
                          "DM",
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.btnColor,
                            fontWeightNew: FontWeight.w700,
                            size: ResponsiveFlutter.of(context).fontSize(1.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: ResponsiveFlutter.of(context).moderateScale(20),
                        ),
                        padding: const EdgeInsets.fromLTRB(35, 15, 15, 15),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyTextView(
                                      "Daniel Mwema",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor,
                                        fontWeightNew: FontWeight.w600,
                                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                                      ),
                                    ),
                                    const SizedBox(height: 3,),
                                    MyTextView(
                                      "+243 814 063 056",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor.withOpacity(.5),
                                        fontWeightNew: FontWeight.w400,
                                        size: ResponsiveFlutter.of(context).fontSize(1.2),
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.history_rounded, color: Colors.orange,)
                              ],
                            ),
                            Divider(
                              height: ResponsiveFlutter.of(context).moderateScale(25),
                              color: appColors.dividerColor,
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                MyTextView(
                                  "Boisson",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "-",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                MyTextView(
                                  "Table",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "Java",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(43),
                        width: ResponsiveFlutter.of(context).scale(43),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).moderateScale(10)),
                        margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).moderateScale(10)),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColors.white,
                          border: Border.all(
                            color: appColors.appMediumColor,
                            width: ResponsiveFlutter.of(context).scale(2.5),
                          ),
                        ),
                        child: MyTextView(
                          "DM",
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.btnColor,
                            fontWeightNew: FontWeight.w700,
                            size: ResponsiveFlutter.of(context).fontSize(1.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          left: ResponsiveFlutter.of(context).moderateScale(20),
                        ),
                        padding: const EdgeInsets.fromLTRB(35, 15, 15, 15),
                        decoration: BoxDecoration(
                          color: appColors.appLightColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyTextView(
                                      "Daniel Mwema",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor,
                                        fontWeightNew: FontWeight.w600,
                                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                                      ),
                                    ),
                                    const SizedBox(height: 3,),
                                    MyTextView(
                                      "+243 814 063 056",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor.withOpacity(.5),
                                        fontWeightNew: FontWeight.w400,
                                        size: ResponsiveFlutter.of(context).fontSize(1.2),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.cancel_outlined, color: appColors.red,)
                              ],
                            ),
                            Divider(
                              height: ResponsiveFlutter.of(context).moderateScale(25),
                              color: appColors.dividerColor,
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                MyTextView(
                                  "Boisson",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "-",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                MyTextView(
                                  "Table",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor.withOpacity(.5),
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  "Java",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w700,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: ResponsiveFlutter.of(context).verticalScale(43),
                        width: ResponsiveFlutter.of(context).scale(43),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).moderateScale(10)),
                        margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).moderateScale(10)),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: appColors.white,
                          border: Border.all(
                            color: appColors.appMediumColor,
                            width: ResponsiveFlutter.of(context).scale(2.5),
                          ),
                        ),
                        child: MyTextView(
                          "DM",
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.btnColor,
                            fontWeightNew: FontWeight.w700,
                            size: ResponsiveFlutter.of(context).fontSize(1.7),
                          ),
                        ),
                      ),
                    ],
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