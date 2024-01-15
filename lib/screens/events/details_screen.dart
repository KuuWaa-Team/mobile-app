import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/screens/admin/admin_list_screen.dart';
import 'package:kuuwaa/screens/beverage/beverage_list_screen.dart';
import 'package:kuuwaa/screens/events/edit_event_screen.dart';
import 'package:kuuwaa/screens/events/payment_screen.dart';
import 'package:kuuwaa/screens/table/table_list_screen.dart';
import 'package:kuuwaa/shimmer/event_detail_shimmer.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:provider/provider.dart';

import '../invitations/invitations_list_screen.dart';

class DetailsScreen extends StatefulWidget {
  int id;

  DetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  AppColors appColors = AppColors();
  EventViewModel eventViewModel = EventViewModel();

  final ImagePicker picker = ImagePicker();
  XFile? image;
  File? imageFile;
  bool loadingImage = false;

  @override
  void initState() {
    eventViewModel.getEventDetailApi(context, widget.id);
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
          child: ChangeNotifierProvider<EventViewModel>(
              create: (BuildContext context) => eventViewModel,
              child: Consumer<EventViewModel>(
                  builder: (context, value, _) {
                    switch (value.event.status) {
                      case Status.LOADING:
                        return const EventDetailShimmer();
                      case Status.ERROR:
                        return Center(
                          child: Text(value.event.message.toString()),
                        );
                      case Status.COMPLETED:
                        EventModel event = value.event.data!;
                        print(event.features);
                        return Stack(
                          children: [
                            imageFile == null || !loadingImage?
                            Container(
                              height: MediaQuery.of(context).size.height * 0.32,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(AppUrl.domainName + event.imagePath.toString())
                                ),
                                color: appColors.appMediumColor,
                                // borderRadius: BorderRadius.circular(20)
                              ),
                              width: MediaQuery.of(context).size.width,
                            )
                            : Stack(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.32,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.file(imageFile!, fit: BoxFit.cover),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.32,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.7),
                                    // borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(color: Colors.white.withOpacity(.7), strokeWidth: 2),
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
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
                                        right: ResponsiveFlutter.of(context).moderateScale(25),
                                        left: ResponsiveFlutter.of(context).moderateScale(10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            eventViewModel.getEventDetailApi(context, widget.id);
                                          });
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
                                              Icons.refresh,
                                              color: appColors.lightColor,
                                              size: ResponsiveFlutter.of(context).moderateScale(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                          event.name.toString(),
                                          textAligntNew: TextAlign.start,
                                          maxLineWrap: true,
                                          styleNew: MyTextStyle(
                                            colorNew: appColors.lightColor,
                                            fontWeightNew: FontWeight.w600,
                                            size: ResponsiveFlutter.of(context).fontSize(2),
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
                                            event.category!.name.toString(),
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
                                    // SizedBox(height: ResponsiveFlutter.of(context).moderateScale(15)),
                                    // Row(
                                    //   children: [
                                    //     Image.asset(
                                    //       ImagePath.calender,
                                    //       color: appColors.lightColor,
                                    //       height: ResponsiveFlutter.of(context).moderateScale(15),
                                    //     ),
                                    //     SizedBox(width: ResponsiveFlutter.of(context).moderateScale(8)),
                                    //     MyTextView(
                                    //       DateFormat('dd MMM, yyyy').format(event.date!),
                                    //       textAligntNew: TextAlign.start,
                                    //       maxLineWrap: true,
                                    //       styleNew: MyTextStyle(
                                    //         colorNew: appColors.lightColor,
                                    //         fontWeightNew: FontWeight.w400,
                                    //         size: ResponsiveFlutter.of(context).fontSize(1.6),
                                    //       ),
                                    //     ),
                                    //     SizedBox(width: ResponsiveFlutter.of(context).moderateScale(20)),
                                    //     Image.asset(
                                    //       ImagePath.time,
                                    //       color: appColors.lightColor,
                                    //       height: ResponsiveFlutter.of(context).moderateScale(15),
                                    //     ),
                                    //     SizedBox(width: ResponsiveFlutter.of(context).moderateScale(8)),
                                    //     MyTextView(
                                    //       DateFormat('kk:mm').format(event.date!),
                                    //       textAligntNew: TextAlign.start,
                                    //       maxLineWrap: true,
                                    //       styleNew: MyTextStyle(
                                    //         colorNew: appColors.lightColor,
                                    //         fontWeightNew: FontWeight.w400,
                                    //         size: ResponsiveFlutter.of(context).fontSize(1.6),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
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
                                                        "Details de l'évenement",
                                                        textAligntNew: TextAlign.center,
                                                        styleNew: MyTextStyle(
                                                          colorNew: appColors.lightColor.withOpacity(.5),
                                                          fontWeightNew: FontWeight.w400,
                                                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                        ),
                                                      ),
                                                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(5)),
                                                      MyTextView(
                                                        event.name.toString(),
                                                        maxLinesNew: 2,
                                                        styleNew: MyTextStyle(
                                                          colorNew: appColors.lightColor,
                                                          fontWeightNew: FontWeight.w600,
                                                          size: ResponsiveFlutter.of(context).fontSize(2),
                                                        ),
                                                      ),
                                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                                      Container(
                                                        height: ResponsiveFlutter.of(context).moderateScale(25),
                                                        width: ResponsiveFlutter.of(context).moderateScale(120),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: appColors.blurBtnColor,
                                                          borderRadius: BorderRadius.circular(
                                                            ResponsiveFlutter.of(context).moderateScale(20),
                                                          ),
                                                        ),
                                                        child: MyTextView(
                                                          event.category!.name.toString(),
                                                          textAligntNew: TextAlign.center,
                                                          maxLineWrap: true,
                                                          styleNew: MyTextStyle(
                                                            colorNew: appColors.lightPinkColor,
                                                            fontWeightNew: FontWeight.w500,
                                                            size: ResponsiveFlutter.of(context).fontSize(1.2),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                                      MyTextView(
                                                        event.details.toString(),
                                                        maxLinesNew: 10,
                                                        styleNew: MyTextStyle(
                                                          colorNew: appColors.lightColor.withOpacity(.7),
                                                          fontWeightNew: FontWeight.w400,
                                                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                        ),
                                                      ),
                                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
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
                                                              event.address.toString(),
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
                                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => EditEventScreen(id: event.id!),
                                                            ),
                                                          );
                                                        },
                                                        child: CommonButton(
                                                          loading: false,
                                                          title: "Modifier les details",
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row (
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.text_justify, size: 15, color: appColors.lightPinkColor,),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              "Details de l'évenement",
                                              textAligntNew: TextAlign.start,
                                              maxLineWrap: true,
                                              styleNew: MyTextStyle(
                                                colorNew: appColors.lightColor,
                                                fontWeightNew: FontWeight.w500,
                                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    GestureDetector(
                                      onTap: () {
                                        imagePick(event);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row (
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.photo, size: 15, color: appColors.lightPinkColor,),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              "Modifier l'image",
                                              textAligntNew: TextAlign.start,
                                              maxLineWrap: true,
                                              styleNew: MyTextStyle(
                                                colorNew: appColors.lightColor,
                                                fontWeightNew: FontWeight.w500,
                                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    GestureDetector(
                                      onTap: () {
                                        if (event.tablesCount == null || event.tablesCount! < 1) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                                            child:
                                                            Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                SizedBox(
                                                                  height: 60,
                                                                  width: 60,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.lightbulb_outline,
                                                                      color: appColors.btnColor,
                                                                      size: 50,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                const Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text("Vous devez enrégistrer au moins une table avant de gérer les invités", style: TextStyle(
                                                                        fontWeight: FontWeight.bold
                                                                    ), textAlign: TextAlign.center,),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 20,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: CommonButton(
                                                                        loading: false,
                                                                        title: "Compris",
                                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => InvitationsListScreen(id: event.id!),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: event.tablesCount == null || event.tablesCount! < 1 ? appColors.appLightColor.withOpacity(.5) : appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row (
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.mail_solid, 
                                              size: 15, 
                                              color: event.tablesCount == null || event.tablesCount! < 1 ? appColors.lightPinkColor.withOpacity(.3) : appColors.lightPinkColor,
                                            ),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              Strings.invites + (event.invitationsCount == null || event.invitationsCount! == 0 ? " (0)" : " (${event.invitationsCount})"),
                                              textAligntNew: TextAlign.start,
                                              maxLineWrap: true,
                                              styleNew: MyTextStyle(
                                                colorNew: event.tablesCount == null || event.tablesCount! < 1 ? appColors.lightColor.withOpacity(.3) : appColors.lightColor,
                                                fontWeightNew: FontWeight.w500,
                                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TableListScreen(id: event.id!),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row (
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.table_fill, size: 15, color: appColors.lightPinkColor,),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              Strings.tables  + (event.tablesCount == null || event.tablesCount! == 0 ? " (0)" : " (${event.tablesCount})"),
                                              textAligntNew: TextAlign.start,
                                              maxLineWrap: true,
                                              styleNew: MyTextStyle(
                                                colorNew: appColors.lightColor,
                                                fontWeightNew: FontWeight.w500,
                                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BeverageListScreen(id: event.id!),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row (
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.hourglass_bottomhalf_fill, size: 15, color: appColors.lightPinkColor,),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              Strings.beverage + (event.beveragesCount == null || event.beveragesCount! == 0 ? " (0)" : " (${event.beveragesCount})"),
                                              textAligntNew: TextAlign.start,
                                              maxLineWrap: true,
                                              styleNew: MyTextStyle(
                                                colorNew: appColors.lightColor,
                                                fontWeightNew: FontWeight.w500,
                                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
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
                                                        "Details de l'abonnement",
                                                        textAligntNew: TextAlign.center,
                                                        styleNew: MyTextStyle(
                                                          colorNew: appColors.lightColor.withOpacity(.5),
                                                          fontWeightNew: FontWeight.w400,
                                                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                        ),
                                                      ),
                                                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(15)),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          MyTextView(
                                                            "Pack",
                                                            maxLinesNew: 2,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.lightColor.withOpacity(.5),
                                                              fontWeightNew: FontWeight.w400,
                                                              size: ResponsiveFlutter.of(context).fontSize(2),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 5,),
                                                          MyTextView(
                                                            event.eventPack!.name.toString(),
                                                            maxLinesNew: 2,
                                                            styleNew: MyTextStyle(
                                                              colorNew: Colors.orange,
                                                              fontWeightNew: FontWeight.w600,
                                                              size: ResponsiveFlutter.of(context).fontSize(2),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                                      Container(
                                                        height: ResponsiveFlutter.of(context).moderateScale(25),
                                                        width: ResponsiveFlutter.of(context).moderateScale(120),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: appColors.blurBtnColor,
                                                          borderRadius: BorderRadius.circular(
                                                            ResponsiveFlutter.of(context).moderateScale(20),
                                                          ),
                                                        ),
                                                        child: MyTextView(
                                                          event.eventPack!.maxTickets == null ? "Invitations illimitées" : event.eventPack!.maxTickets.toString() + " invitations",
                                                          textAligntNew: TextAlign.center,
                                                          maxLineWrap: true,
                                                          styleNew: MyTextStyle(
                                                            colorNew: appColors.lightPinkColor,
                                                            fontWeightNew: FontWeight.w500,
                                                            size: ResponsiveFlutter.of(context).fontSize(1.2),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: event.features!.length,
                                                        itemBuilder: (context, index) {
                                                          FeatureModel feature = event.features![index];
                                                          return Container(
                                                            margin: const EdgeInsets.only(bottom: 10),
                                                            decoration: BoxDecoration(
                                                                color: appColors.appLightColor,
                                                                borderRadius: BorderRadius.circular(5)
                                                            ),
                                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                MyTextView(
                                                                  "+ " + feature.name.toString(),
                                                                  textAligntNew: TextAlign.start,
                                                                  maxLineWrap: true,
                                                                  styleNew: MyTextStyle(
                                                                    colorNew: Colors.green,
                                                                    fontWeightNew: FontWeight.w600,
                                                                    size: ResponsiveFlutter.of(context).fontSize(1.6),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 5,),
                                                                MyTextView(
                                                                  feature.description.toString(),
                                                                  textAligntNew: TextAlign.start,
                                                                  maxLineWrap: true,
                                                                  styleNew: MyTextStyle(
                                                                    colorNew: appColors.lightColor.withOpacity(.5),
                                                                    fontWeightNew: FontWeight.w500,
                                                                    size: ResponsiveFlutter.of(context).fontSize(1.3),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: appColors.red.withOpacity(.05),
                                                          border: Border.all(color: appColors.red.withOpacity(.5), width: 1)
                                                        ),
                                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.error_outline_rounded, color: appColors.red, size: 30,),
                                                            const SizedBox(width: 10,),
                                                            Flexible(
                                                              child: Text(
                                                                "Votre évenement n'est pas actif. Pour l'activer, vous devez payer les frais de l'abonnement.",
                                                                style: TextStyle(
                                                                  color: appColors.red,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: ResponsiveFlutter.of(context).fontSize(1.3),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => PaymentScreen(event: event,),
                                                            ),
                                                          );
                                                        },
                                                        child: CommonButton(
                                                          loading: false,
                                                          title: "Activer l'évenement",
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row (
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(CupertinoIcons.info_circle_fill, size: 15, color: appColors.lightPinkColor,),
                                                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                MyTextView(
                                                  "Abonnement",
                                                  textAligntNew: TextAlign.start,
                                                  maxLineWrap: true,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.lightColor,
                                                    fontWeightNew: FontWeight.w500,
                                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                  ),
                                                ),
                                                const SizedBox(width: 10,),
                                              ],
                                            ),
                                            // if (event.paidEvent != true)
                                            Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.orange
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                                  child: MyTextView(
                                                    "En attente du paiement",
                                                    textAligntNew: TextAlign.start,
                                                    maxLineWrap: true,
                                                    styleNew: MyTextStyle(
                                                      colorNew: appColors.lightColor,
                                                      fontWeightNew: FontWeight.w500,
                                                      size: ResponsiveFlutter.of(context).fontSize(1.2),
                                                    ),
                                                  )
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AdminListScreen(id: event.id!),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row (
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.admin_panel_settings_rounded, size: 15, color: appColors.lightPinkColor,),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              "Protocoleurs" + (event.adminsCount == null || event.adminsCount! == 0 ? " (0)" : " (${event.adminsCount})"),
                                              textAligntNew: TextAlign.start,
                                              maxLineWrap: true,
                                              styleNew: MyTextStyle(
                                                colorNew: appColors.lightColor,
                                                fontWeightNew: FontWeight.w500,
                                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: appColors.red.withOpacity(.2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      child: Row (
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(CupertinoIcons.delete_solid, size: 15, color: appColors.lightPinkColor,),
                                          SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                          MyTextView(
                                            "Supprimer l'évenement",
                                            textAligntNew: TextAlign.start,
                                            maxLineWrap: true,
                                            styleNew: MyTextStyle(
                                              colorNew: appColors.lightColor,
                                              fontWeightNew: FontWeight.w500,
                                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(15)),
                                  ],
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

  void imagePick(EventModel event) async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image!.path);
      debugPrint("Image ------------- >>>> ${image!.path}");
    } else {
      debugPrint("<<<< ------------- Image Not Selected ------------- >>>>");
    }
    setState(() {
      loadingImage = true;
    });
    await eventViewModel.editEventImageApi(context, image, event.id!).then((value) {
      setState(() {
        loadingImage = false;
        imageFile = null;
      });
    });
  }
}
