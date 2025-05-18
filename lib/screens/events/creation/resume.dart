import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_specification_model.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';

class Resume extends StatefulWidget {
  final List<String> titles;

  final File? imageFile;
  final TextEditingController detailsController;
  final TextEditingController titleController;
  EventCategoryModel selectedCategory;

  void Function(int) goToSection;

  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController addressController;
  final TextEditingController placeNameController;

  final List<EventSpecificationModel> specifications;

  EventTemplateModel? eventTemplateModel;

  Resume({
    Key? key,
    required this.goToSection,

    required this.titles,
    required this.imageFile,
    required this.detailsController,
    required this.titleController,
    required this.selectedCategory,

    required this.startDate,
    required this.endDate,
    required this.addressController,
    required this.placeNameController,

    required this.specifications,
    required this.eventTemplateModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  AppColors appColors = AppColors();
  final TextEditingController _controller = TextEditingController();
  String dateName = "";

  @override
  void initState() {
    super.initState();

    DateTime start = widget.startDate!;
    DateTime end = widget.endDate!;

    bool sameDay = start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;

    if (sameDay) {
      dateName = formatDate(start);
    } else {
      dateName = "Du ${formatShortDate(start)} au ${formatShortDate(end)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveFlutter.of(context).moderateScale(15),
        horizontal: ResponsiveFlutter.of(context).moderateScale(20),
      ),
      children: [
        Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: appColors.appLightColor,
              borderRadius: BorderRadius.circular(
                ResponsiveFlutter.of(context).moderateScale(20),
              ),
              boxShadow: [Utils.customShadow()]
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      widget.titles[0].toUpperCase(),
                      textAligntNew: TextAlign.left,
                      styleNew: MyTextStyle(
                        colorNew: appColors.btnColor,
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.8),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.goToSection(0);
                      },
                      child: Icon(Icons.edit, size: 18, color: appColors.btnColor)
                    )
                  ],
                ),
                Divider(color: appColors.lightColor.withOpacity(.1),
                    height: 20,
                    thickness: .5),
                const SizedBox(height: 5,),
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black),
                    image: DecorationImage(
                      image: FileImage(widget.imageFile!)
                    )
                  ),
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      "Titre",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.5),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                    MyTextView(
                      widget.titleController.text,
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w600,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                  ],
                ),
                Divider(color: appColors.lightColor.withOpacity(.1),
                    height: 20,
                    thickness: .5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      "Catégorie",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.5),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                    MyTextView(
                      widget.selectedCategory.name.toString(),
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w600,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                  ],
                ),
                Divider(color: appColors.lightColor.withOpacity(.1),
                    height: 20,
                    thickness: .5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      "Message",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.5),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: MyTextView(
                        widget.detailsController.text,
                        textAligntNew: TextAlign.right,
                        maxLinesNew: 100,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: appColors.appLightColor,
            borderRadius: BorderRadius.circular(
              ResponsiveFlutter.of(context).moderateScale(20),
            ),
            boxShadow: [Utils.customShadow()]
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      widget.titles[1].toUpperCase(),
                      textAligntNew: TextAlign.left,
                      styleNew: MyTextStyle(
                        colorNew: appColors.btnColor,
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.8),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          widget.goToSection(1);
                        },
                        child: Icon(Icons.edit, size: 18, color: appColors.btnColor)
                    )
                  ],
                ),
                Divider(color: appColors.lightColor.withOpacity(.1),
                    height: 20,
                    thickness: .5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      "Date",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.5),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                    MyTextView(
                      dateName,
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w600,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                  ],
                ),
                Divider(color: appColors.lightColor.withOpacity(.1),
                    height: 20,
                    thickness: .5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      "Heure",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.5),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                    MyTextView(
                      "De ${widget.startDate!.hour.toString().padLeft(2, '0')}H${widget.startDate!.minute.toString().padLeft(2, '0')} à ${widget.endDate!.hour.toString().padLeft(2, '0')}H${widget.endDate!.minute.toString().padLeft(2, '0')}",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w600,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                  ],
                ),
                Divider(color: appColors.lightColor.withOpacity(.1),
                    height: 20,
                    thickness: .5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      "Adresse",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.5),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                    MyTextView(
                      widget.addressController.text,
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w600,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                  ],
                ),
                Divider(color: appColors.lightColor.withOpacity(.1),
                    height: 20,
                    thickness: .5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      "Lieu de l'événement",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.5),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                    MyTextView(
                      widget.placeNameController.text,
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w600,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: appColors.appLightColor,
              borderRadius: BorderRadius.circular(
                ResponsiveFlutter.of(context).moderateScale(20),
              ),
              boxShadow: [Utils.customShadow()]
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      widget.titles[2].toUpperCase(),
                      textAligntNew: TextAlign.left,
                      styleNew: MyTextStyle(
                        colorNew: appColors.btnColor,
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.8),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          widget.goToSection(2);
                        },
                        child: Icon(Icons.edit, size: 18, color: appColors.btnColor)
                    )
                  ],
                ),
                ...widget.specifications.map((spec) {
                  return Column(
                    children: [
                      Divider(color: appColors.lightColor.withOpacity(.1),
                          height: 20,
                          thickness: .5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(CupertinoIcons.pin, size: 12,), const SizedBox(width: 5,),
                          MyTextView(
                            spec.name.toString(),
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w600,
                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                })
              ],
            )
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: appColors.appLightColor,
              borderRadius: BorderRadius.circular(
                ResponsiveFlutter.of(context).moderateScale(20),
              ),
              boxShadow: [Utils.customShadow()]
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      widget.titles[3].toUpperCase(),
                      textAligntNew: TextAlign.left,
                      styleNew: MyTextStyle(
                        colorNew: appColors.btnColor,
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.8),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          widget.goToSection(3);
                        },
                        child: Icon(Icons.edit, size: 18, color: appColors.btnColor)
                    )
                  ],
                ),
                Divider(color: appColors.lightColor.withOpacity(.1),
                    height: 20,
                    thickness: .5),
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: appColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black),
                    image: DecorationImage(
                      image: NetworkImage(AppUrl.domainName + "/images/templates/${widget.eventTemplateModel!.imagePath}"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      "Nom",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.5),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: MyTextView(
                        widget.eventTemplateModel!.name.toString(),
                        textAligntNew: TextAlign.right,
                        maxLinesNew: 100,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: appColors.lightColor.withOpacity(.1),
                    height: 20,
                    thickness: .5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      "Prix",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.5),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: MyTextView(
                        "${widget.eventTemplateModel!.price} crédits / invitation",
                        textAligntNew: TextAlign.right,
                        maxLinesNew: 100,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ],
    );
  }

  String formatDate(DateTime date) {
    return "${getWeekday(date.weekday)} ${date.day} ${getMonthName(date.month)} ${date.year}";
  }

  String formatShortDate(DateTime date) {
    return "${date.day} ${getMonthName(date.month)}";
  }

  String getWeekday(int weekday) {
    const weekdays = [
      "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"
    ];
    return weekdays[weekday - 1];
  }

  String getMonthName(int month) {
    const months = [
      "janvier", "février", "mars", "avril", "mai", "juin",
      "juillet", "août", "septembre", "octobre", "novembre", "décembre"
    ];
    return months[month - 1];
  }

}