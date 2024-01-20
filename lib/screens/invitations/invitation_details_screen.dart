import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/invitation/invitation_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/event_detail_shimmer.dart';
import 'package:kuuwaa/view_model/invitation/invitation_view_model.dart';
import 'package:provider/provider.dart';

class InvitationDetailsScreen extends StatefulWidget {
  int id;
  InvitationDetailsScreen({Key? key, required this.id}) : super(key: key);
  @override
  _InvitationDetailsScreenState createState() => _InvitationDetailsScreenState();
}

class _InvitationDetailsScreenState extends State<InvitationDetailsScreen> {
  AppColors appColors = AppColors();
  InvitationViewModel invitationViewModel = InvitationViewModel();

  @override
  void initState() {
    invitationViewModel.invitationDetailApi(context, widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ChangeNotifierProvider<InvitationViewModel>(
              create: (BuildContext context) => invitationViewModel,
              child: Consumer<InvitationViewModel>(
                  builder: (context, value, _) {
                    switch (value.invitation.status) {
                      case Status.LOADING:
                        return const EventDetailShimmer();
                      case Status.ERROR:
                        return Center(
                          child: Text(value.invitation.message.toString()),
                        );
                      case Status.COMPLETED:
                        InvitationModel invitation = value.invitation.data!;
                        return Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.32,
                              color: appColors.appMediumColor,
                              width: MediaQuery.of(context).size.width,
                              child: InstaImageViewer(child: Image.network(AppUrl.domainName + invitation.event!.imagePath.toString())),
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
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      invitationViewModel.invitationDetailApi(context, widget.id!);
                                    });
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: appColors.appDarkColor,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height * 0.25,
                                      right: ResponsiveFlutter.of(context).moderateScale(25),
                                      left: ResponsiveFlutter.of(context).moderateScale(10),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        CupertinoIcons.refresh,
                                        color: appColors.lightColor,
                                        size: ResponsiveFlutter.of(context).moderateScale(15),
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
                                          invitation.event!.name.toString(),
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
                                            invitation.event!.category!.name.toString(),
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
                                      invitation.civility.toString() + " " + invitation.name.toString() + ",",
                                      textAligntNew: TextAlign.start,
                                      maxLineWrap: true,
                                      maxLinesNew: 4,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor,
                                        fontWeightNew: FontWeight.w400,
                                        size: ResponsiveFlutter.of(context).fontSize(1.8),
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    MyTextView(
                                      invitation.event!.details.toString(),
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
                                          DateFormat('dd MMM, yyyy').format(invitation.event!.date!),
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
                                          DateFormat('kk:mm').format(invitation.event!.date!),
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
                                      height: ResponsiveFlutter.of(context).moderateScale(45),
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
                                            invitation.event!.address.toString(),
                                            textAligntNew: TextAlign.start,
                                            maxLineWrap: true,
                                            styleNew: MyTextStyle(
                                              colorNew: appColors.lightColor,
                                              fontWeightNew: FontWeight.w500,
                                              size: ResponsiveFlutter.of(context).fontSize(2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
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
                                            width: ((MediaQuery.of(context).size.width - 40) / 2) - 5,
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
                                                  invitation.count! > 1 ? "Nous serons là": "Je serais là",
                                                  textAligntNew: TextAlign.start,
                                                  maxLineWrap: true,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.white,
                                                    fontWeightNew: FontWeight.w600,
                                                    size: ResponsiveFlutter.of(context).fontSize(1.4),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        GestureDetector(
                                          onTap: () {

                                          },
                                          child: Container(
                                            width: ((MediaQuery.of(context).size.width - 40) / 2) - 10,
                                            height: ResponsiveFlutter.of(context).moderateScale(40),
                                            margin: EdgeInsets.only(
                                              bottom: ResponsiveFlutter.of(context).moderateScale(10),
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
                                                    size: ResponsiveFlutter.of(context).fontSize(1.4),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
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
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white
                                      ),
                                      child: InstaImageViewer(
                                        child: Image.network(AppUrl.domainName + invitation.codePath.toString())
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                    }
                  }
              )
          ),
        ),
      ),
    );
  }
}
