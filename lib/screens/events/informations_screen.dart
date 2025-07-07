import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/check_dialog.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/creation/event_general_information.dart';
import 'package:kuuwaa/screens/events/edit_event_screen.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/invitation/invitation_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InformationsScreen extends StatefulWidget {
  EventModel event;
  InformationsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _InformationsScreenState createState() => _InformationsScreenState();
}

class _InformationsScreenState extends State<InformationsScreen> {
  AppColors appColors = AppColors();
  EventViewModel eventViewModel = EventViewModel();
  EventCategoryModel selectedCategory = EventCategoryModel(
      id: 0,
      name: "Catégorie"
  );
  final ImagePicker picker = ImagePicker();
  XFile? image;
  File? imageFile;
  bool showOtherCategory = false;

  List items = [];
  @override
  void initState() {
    List<dynamic> fetchedCategories = [selectedCategory];

    eventViewModel.getCategories(context).then((value) {
      for (var element in eventViewModel.categories) {
        fetchedCategories.add(element);
      }
      fetchedCategories.add(EventCategoryModel(
          id: null,
          name: "Autre (À préciser)"
      ));
      setState(() {
        items = fetchedCategories;
      });
    });
    super.initState();
  }

  void imagePick() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image!.path);
      debugPrint("Image ------------- >>>> ${image!.path}");
    } else {
      debugPrint("<<<< ------------- Image Not Selected ------------- >>>>");
    }
    setState(() {});
  }

  Widget buildStaticMapImage() {
    final latitude = widget.event.placeLatitude;
    final longitude = widget.event.placeLongitude;

    final staticMapUrl = 'https://maps.googleapis.com/maps/api/staticmap'
        '?center=$latitude,$longitude'
        '&zoom=16'
        '&size=600x300'
        '&markers=color:red%7C$latitude,$longitude'
        '&key=AIzaSyAvXtXVRVf5OMYoeRtzGc-6TIKc_TnL8ys';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: appColors.greyTextColor)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          staticMapUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        systemNavigationBarDividerColor: appColors.white
      ),
    );
    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          backgroundColor: appColors.appMediumColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              commonAppBar(
                context: context,
                title: "Details de l'événement",
                backArrow: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyTextView(
                              "Informations générales",
                              textAligntNew: TextAlign.start,
                              styleNew: MyTextStyle(
                                colorNew: appColors.btnColor,
                                fontWeightNew: FontWeight.w500,
                                size: ResponsiveFlutter.of(context).fontSize(2),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //
                            //   },
                            //   child: Icon(Icons.edit, color: appColors.btnColor,),
                            // )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        MyTextView(
                          "Image",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(5)),
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.black),
                            image: DecorationImage(
                              image: NetworkImage(AppUrl.domainName + widget.event.imagePath!),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        MyTextView(
                          "Titre",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                        MyTextView(
                          widget.event.title.toString(),
                          maxLinesNew: 2,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w600,
                            size: ResponsiveFlutter.of(context).fontSize(2),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                        MyTextView(
                          "Catégorie",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                        MyTextView(
                          widget.event.category!.name.toString(),
                          maxLinesNew: 2,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w600,
                            size: ResponsiveFlutter.of(context).fontSize(2),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                        MyTextView(
                          "Details",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                        MyTextView(
                          widget.event.details.toString(),
                          maxLinesNew: 20,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w500,
                            size: ResponsiveFlutter.of(context).fontSize(1.6),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(8)),
                        const Divider(),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(8)),
                        MyTextView(
                          "Date, heure et addresse",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.btnColor,
                            fontWeightNew: FontWeight.w500,
                            size: ResponsiveFlutter.of(context).fontSize(2),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        MyTextView(
                          "Date",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(2)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              ImagePath.calender,
                              color: appColors.lightColor,
                              height: ResponsiveFlutter.of(context).moderateScale(15),
                            ),
                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(5)),
                            MyTextView(
                              widget.event.formattedDate(),
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
                        const SizedBox(height: 10,),
                        MyTextView(
                          "Heure",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(2)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              ImagePath.time,
                              color: appColors.lightColor,
                              height: ResponsiveFlutter.of(context).moderateScale(15),
                            ),
                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(5)),
                            MyTextView(
                              widget.event.formattedHour(),
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
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                        MyTextView(
                          "Adresse",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                        MyTextView(
                          widget.event.address.toString(),
                          maxLinesNew: 20,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w500,
                            size: ResponsiveFlutter.of(context).fontSize(1.6),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                        MyTextView(
                          "Lieu de l'évenement",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                        MyTextView(
                          widget.event.placeName.toString(),
                          maxLinesNew: 20,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w500,
                            size: ResponsiveFlutter.of(context).fontSize(1.6),
                          ),
                        ),
                        if (widget.event.placeLongitude != null && widget.event.placeLatitude != null)
                        buildStaticMapImage(),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(8)),
                        const Divider(),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyTextView(
                              "Autres spécifications",
                              textAligntNew: TextAlign.start,
                              styleNew: MyTextStyle(
                                colorNew: appColors.btnColor,
                                fontWeightNew: FontWeight.w500,
                                size: ResponsiveFlutter.of(context).fontSize(2),
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () {
                            //
                            //       },
                            //       child: Icon(Icons.edit, color: appColors.btnColor,),
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                        const SizedBox(height: 8,),
                        if (widget.event.specifications != null)
                        ...widget.event.specifications!.map((spec) => Column(
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.pin, size: 12,), const SizedBox(width: 5,),
                                MyTextView(
                                  spec.name!,
                                  maxLinesNew: 20,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w500,
                                    size: ResponsiveFlutter.of(context).fontSize(1.6),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10)),
                          ],
                        )),
                        const Divider(),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(8)),
                        MyTextView(
                          "Modèle des invitations",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.btnColor,
                            fontWeightNew: FontWeight.w500,
                            size: ResponsiveFlutter.of(context).fontSize(2),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.black),
                            image: DecorationImage(
                              image: NetworkImage(AppUrl.domainName + "/images/templates/${widget.event.template!.imagePath}"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                        MyTextView(
                          "Nom du modèle",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                        MyTextView(
                          widget.event.template!.name.toString(),
                          maxLinesNew: 20,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w500,
                            size: ResponsiveFlutter.of(context).fontSize(1.6),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                        MyTextView(
                          "Prix du modèle",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                        MyTextView(
                          widget.event.template!.price.toString() + " crédits / invitation",
                          maxLinesNew: 20,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w500,
                            size: ResponsiveFlutter.of(context).fontSize(1.6),
                          ),
                        ),
                        MyTextView(
                          "Inclu des animations ?",
                          textAligntNew: TextAlign.start,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor.withOpacity(.5),
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(1)),
                        MyTextView(
                          widget.event.template!.hasAnimations == true ? "Oui" : "Non",
                          maxLinesNew: 20,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w500,
                            size: ResponsiveFlutter.of(context).fontSize(1.6),
                          ),
                        ),
                        SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                      ],
                    ),
                  ),
                ),
              )
              // Expanded(flex: 4, child: _buildQrView(context)),
            ],
          )
        )
    );
  }
}
