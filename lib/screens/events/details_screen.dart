import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/screens/admin/admin_list_screen.dart';
import 'package:kuuwaa/screens/beverage/beverage_list_screen.dart';
import 'package:kuuwaa/screens/book/book_screen.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/chat_screen.dart';
import 'package:kuuwaa/screens/events/check/check_screen.dart';
import 'package:kuuwaa/screens/events/edit_event_screen.dart';
import 'package:kuuwaa/screens/events/payment_screen.dart';
import 'package:kuuwaa/screens/home_page_screen.dart';
import 'package:kuuwaa/screens/table/table_list_screen.dart';
import 'package:kuuwaa/shimmer/event_owner_detail_shimmer.dart';
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
                        return const EventOwnerDetailShimmer();
                      case Status.ERROR:
                        return Center(
                          child: Text(value.event.message.toString()),
                        );
                      case Status.COMPLETED:
                        EventModel event = value.event.data!;
                        print(event.paymentStatus);
                        return Stack(
                          children: [
                            imageFile == null || !loadingImage?
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.32,
                              width: MediaQuery.of(context).size.width,
                              child: InstaImageViewer(
                                child: Image.network(AppUrl.domainName + event.imagePath.toString(), fit: BoxFit.cover,),
                              ),
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BottomBarScreen(),
                                            ),
                                          );
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
                                          eventViewModel.getEventDetailApi(context, widget.id);
                                        });
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height * 0.25,
                                          right: ResponsiveFlutter.of(context).moderateScale(10),
                                          left: ResponsiveFlutter.of(context).moderateScale(10),
                                        ),
                                        decoration: BoxDecoration(
                                          color: appColors.appDarkColor,
                                          borderRadius: BorderRadius.circular(40),
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
                                    if (event.shared != true)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imagePick(event);
                                        });
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height * 0.25,
                                        ),
                                        decoration: BoxDecoration(
                                          color: appColors.appDarkColor,
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            CupertinoIcons.photo,
                                            color: appColors.lightColor,
                                            size: ResponsiveFlutter.of(context).moderateScale(15),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (event.shared == true)
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height * 0.25,
                                        right: ResponsiveFlutter.of(context).moderateScale(25),
                                      ),
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.share_outlined, color: appColors.lightColor, size: 18,),
                                            const SizedBox(width: 10,),
                                            MyTextView(
                                              "Protocoleur",
                                              textAligntNew: TextAlign.start,
                                              maxLineWrap: true,
                                              styleNew: MyTextStyle(
                                                colorNew: appColors.lightColor,
                                                fontWeightNew: FontWeight.w600,
                                                size: ResponsiveFlutter.of(context).fontSize(2),
                                              ),
                                            ),
                                          ],
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
                                // bottom: MediaQuery.of(context).padding.bottom + ResponsiveFlutter.of(context).moderateScale(20),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      alignment: WrapAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: MyTextView(
                                            event.name.toString(),
                                            textAligntNew: TextAlign.start,
                                            maxLinesNew: 3,
                                            styleNew: MyTextStyle(
                                              colorNew: appColors.lightColor,
                                              fontWeightNew: FontWeight.w600,
                                              size: ResponsiveFlutter.of(context).fontSize(2),
                                            ),
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
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                                    GestureDetector(
                                      onTap: () {
                                        // if (event.invitationsCount == null || event.invitationsCount! < 1) {
                                        //   showDialog(
                                        //     context: context,
                                        //     builder: (context) {
                                        //       return StatefulBuilder(
                                        //         builder: (context, setState) {
                                        //           return Dialog(
                                        //               shape: RoundedRectangleBorder(
                                        //                 borderRadius: BorderRadius.circular(10),
                                        //               ),
                                        //               child: Stack(
                                        //                 children: [
                                        //                   Padding(
                                        //                     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                        //                     child:
                                        //                     Column(
                                        //                       mainAxisSize: MainAxisSize.min,
                                        //                       children: [
                                        //                         SizedBox(
                                        //                           height: 60,
                                        //                           width: 60,
                                        //                           child: Center(
                                        //                             child: Icon(
                                        //                               Icons.lightbulb_outline,
                                        //                               color: appColors.btnColor,
                                        //                               size: 50,
                                        //                             ),
                                        //                           ),
                                        //                         ),
                                        //                         const SizedBox(height: 10,),
                                        //                         const Column(
                                        //                           mainAxisSize: MainAxisSize.min,
                                        //                           children: [
                                        //                             Text("Aucune invitation n'a encore été enrégistrée pour cet évenement.", style: TextStyle(
                                        //                                 fontWeight: FontWeight.bold
                                        //                             ), textAlign: TextAlign.center,),
                                        //                           ],
                                        //                         ),
                                        //                         const SizedBox(height: 20,),
                                        //                         Row(
                                        //                           mainAxisAlignment: MainAxisAlignment.center,
                                        //                           children: [
                                        //                             GestureDetector(
                                        //                               onTap: () {
                                        //                                 Navigator.pop(context);
                                        //                               },
                                        //                               child: CommonButton(
                                        //                                 loading: false,
                                        //                                 title: "Compris",
                                        //                                 padding: const EdgeInsets.symmetric(horizontal: 20),
                                        //                               ),
                                        //                             )
                                        //                           ],
                                        //                         )
                                        //                       ],
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               )
                                        //           );
                                        //         },
                                        //       );
                                        //     },
                                        //   );
                                        // } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CheckScreen(event: event),
                                            ),
                                          );
                                        // }
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
                                            Icon(
                                              CupertinoIcons.qrcode_viewfinder,
                                              size: 15,
                                              color: appColors.lightPinkColor,
                                            ),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              "Vérifier invitation",
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
                                                            DateFormat('dd MMM, yyyy').format(event.date!),
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
                                                            DateFormat('kk:mm').format(event.date!),
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
                                                        // height: ResponsiveFlutter.of(context).moderateScale(55),
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
                                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                            Flexible(
                                                              child: MyTextView(
                                                                "Numéro " + event.address!.number! + ", avénue " + event.address!.street! + ". " + event.address!.province!.name! + (event.address!.ref == null || event.address!.ref == "null" ? "" : ", réf. " + event.address!.ref!),
                                                                textAligntNew: TextAlign.start,
                                                                maxLinesNew: 5,
                                                                maxLineWrap: true,
                                                                styleNew: MyTextStyle(
                                                                  colorNew: appColors.lightColor,
                                                                  fontWeightNew: FontWeight.w500,
                                                                  size: ResponsiveFlutter.of(context).fontSize(2),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                                                      if (event.shared != true)
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
                                        // if (event.tablesCount == null || event.tablesCount! < 1) {
                                        //   showDialog(
                                        //     context: context,
                                        //     builder: (context) {
                                        //       return StatefulBuilder(
                                        //         builder: (context, setState) {
                                        //           return Dialog(
                                        //               shape: RoundedRectangleBorder(
                                        //                 borderRadius: BorderRadius.circular(10),
                                        //               ),
                                        //               child: Stack(
                                        //                 children: [
                                        //                   Padding(
                                        //                     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                        //                     child:
                                        //                     Column(
                                        //                       mainAxisSize: MainAxisSize.min,
                                        //                       children: [
                                        //                         SizedBox(
                                        //                           height: 60,
                                        //                           width: 60,
                                        //                           child: Center(
                                        //                             child: Icon(
                                        //                               Icons.lightbulb_outline,
                                        //                               color: appColors.btnColor,
                                        //                               size: 50,
                                        //                             ),
                                        //                           ),
                                        //                         ),
                                        //                         const SizedBox(height: 10,),
                                        //                         const Column(
                                        //                           mainAxisSize: MainAxisSize.min,
                                        //                           children: [
                                        //                             Text("Vous devez enrégistrer au moins une table avant de gérer les invités", style: TextStyle(
                                        //                                 fontWeight: FontWeight.bold
                                        //                             ), textAlign: TextAlign.center,),
                                        //                           ],
                                        //                         ),
                                        //                         const SizedBox(height: 20,),
                                        //                         Row(
                                        //                           mainAxisAlignment: MainAxisAlignment.center,
                                        //                           children: [
                                        //                             GestureDetector(
                                        //                               onTap: () {
                                        //                                 Navigator.pop(context);
                                        //                               },
                                        //                               child: CommonButton(
                                        //                                 loading: false,
                                        //                                 title: "Compris",
                                        //                                 padding: const EdgeInsets.symmetric(horizontal: 20),
                                        //                               ),
                                        //                             )
                                        //                           ],
                                        //                         )
                                        //                       ],
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               )
                                        //           );
                                        //         },
                                        //       );
                                        //     },
                                        //   );
                                        // } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => InvitationsListScreen(event: event),
                                            ),
                                          );
                                        // }
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
                                            Icon(
                                              CupertinoIcons.mail_solid, 
                                              size: 15, 
                                              color: appColors.lightPinkColor,
                                            ),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              Strings.invites,
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
                                    if (event.featureslugs == null || !event.featureslugs!.contains("BEVERAGE"))
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TableListScreen(event: event),
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
                                              Strings.tables,
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
                                    if (event.featureslugs != null && event.featureslugs!.contains("BEVERAGE"))
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TableListScreen(event: event),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: appColors.appLightColor,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            width: (MediaQuery.of(context).size.width / 2) - 25,
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                            child: Row (
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(CupertinoIcons.table_fill, size: 15, color: appColors.lightPinkColor,),
                                                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                MyTextView(
                                                  Strings.tables,
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
                                        SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BeverageListScreen(event: event),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: appColors.appLightColor,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            width: (MediaQuery.of(context).size.width / 2) - 30,
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                            child: Row (
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(CupertinoIcons.hourglass_bottomhalf_fill, size: 15, color: appColors.lightPinkColor,),
                                                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                MyTextView(
                                                  Strings.beverage,
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
                                      ],
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    if (event.shared != true && event.featureslugs != null && event.featureslugs!.contains("BOOK"))
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BookScreen(event: event),
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
                                              Icon(CupertinoIcons.book_fill, size: 15, color: appColors.lightPinkColor,),
                                              SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                              MyTextView(
                                                "Livre d'or",
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
                                        ),
                                      ),
                                    if (event.shared != true && event.featureslugs != null && event.featureslugs!.contains("BOOK"))
                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => BookScreen(event: event),
                                        //   ),
                                        // );
                                        Utils.flushBarErrorMessage("Fonctionnalité en cours de dévéloppement", context);
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
                                            Icon(CupertinoIcons.bell_fill, size: 15, color: appColors.lightPinkColor,),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              "Save the date",
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
                                      ),
                                    ),
                                    if (event.shared != true)
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    if (event.shared != true)
                                    Row(
                                      children: [
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
                                            width: (MediaQuery.of(context).size.width / 2) - 25,
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                            child: Row (
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.admin_panel_settings_rounded, size: 15, color: appColors.lightPinkColor,),
                                                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                MyTextView(
                                                  "Controlleurs",
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
                                        SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => const ChatScreen(),
                                            //   ),
                                            // );
                                            Utils.flushBarErrorMessage("Fonctionnalité en cours de dévéloppement", context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: appColors.appLightColor,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            width: (MediaQuery.of(context).size.width / 2) - 30,
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                            child: Row (
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(CupertinoIcons.chat_bubble_2_fill, size: 15, color: appColors.lightPinkColor,),
                                                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                MyTextView(
                                                  "Chat",
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
                                      ],
                                    ),
                                    if (event.shared != true)
                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    if (event.shared != true)
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
                                                        if (event.paymentStatus != 'paid')
                                                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                                        if (event.paymentStatus != 'paid')
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
                                                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                                        if (event.paymentStatus != 'paid')
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
                                                        if (event.paymentStatus == 'paid')
                                                          GestureDetector(
                                                            onTap: () {
                                                            },
                                                            child: CommonButton(
                                                              loading: false,
                                                              title: "Télécharger la facture",
                                                            ),
                                                          ),
                                                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: event.paymentStatus == 'paid' ? Colors.green.withOpacity(.08) : Colors.red.withOpacity(.08),
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
                                              if (event.paymentStatus != 'paid')
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.red
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
}
