import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/dotted_line.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';

class EventGeneralInformation extends StatefulWidget {
  final VoidCallback onImagePick;
  final File? imageFile;
  final List items;
  final TextEditingController categoryController;
  final TextEditingController detailsController;
  final TextEditingController titleController;
  bool showOtherCategory;
  Object selectedCategory;
  final Function(Object) onCategoryChanged;

  EventGeneralInformation({
    Key? key,
    required this.onImagePick,
    required this.imageFile,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.items,
    required this.showOtherCategory,
    required this.categoryController,
    required this.titleController,
    required this.detailsController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventGeneralInformationState();
}

class _EventGeneralInformationState extends State<EventGeneralInformation> {
  AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveFlutter.of(context).moderateScale(15),
        horizontal: ResponsiveFlutter.of(context).moderateScale(20),
      ),
      children: [
        GestureDetector(
          onTap: () {
            widget.onImagePick();
          },
          child: FDottedLine(
            color: appColors.lightPinkColor,
            strokeWidth: 1.5,
            dottedLength: 6.0,
            space: 3.5,
            height: ResponsiveFlutter.of(context).verticalScale(130),
            width: double.infinity,
            corner: FDottedLineCorner.all(ResponsiveFlutter.of(context).moderateScale(20)),
            child: Container(
              height: ResponsiveFlutter.of(context).verticalScale(130),
              width: double.infinity,
              decoration: BoxDecoration(
                color: appColors.appLightColor,
                borderRadius: BorderRadius.circular(
                  ResponsiveFlutter.of(context).moderateScale(20),
                ),
              ),
              child: widget.imageFile == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagePath.image,
                    height: ResponsiveFlutter.of(context).moderateScale(25),
                    color: appColors.lightColor,
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    Strings.tapToAddImage,
                    textAligntNew: TextAlign.center,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(2),
                    ),
                  ),
                ],
              )
                  : Image.file(
                widget.imageFile!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveFlutter.of(context).verticalScale(10),
        ),
        Container(
          height: ResponsiveFlutter.of(context).verticalScale(50),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveFlutter.of(context).moderateScale(20),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: appColors.appLightColor,
            borderRadius: BorderRadius.circular(
              ResponsiveFlutter.of(context).moderateScale(20),
            ),
            border: Border.all(
              color: appColors.borderColor,
              width: 1.5,
            ),
          ),
          child: DropdownButton(
            value: widget.selectedCategory,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: appColors.lightPinkColor,
            ),
            style: MyTextStyle(
              colorNew: appColors.lightColor,
              fontWeightNew: FontWeight.w400,
              size: ResponsiveFlutter.of(context).fontSize(1.8),
            ),
            iconSize: ResponsiveFlutter.of(context).moderateScale(30),
            isExpanded: true,
            dropdownColor: appColors.appLightColor,
            borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).moderateScale(20)),
            underline: Container(),
            alignment: Alignment.bottomCenter,
            items: widget.items.map((item) {
              return DropdownMenuItem(
                value: item,
                alignment: Alignment.centerLeft,
                child: MyTextView(
                  item.name.toString(),
                  textAligntNew: TextAlign.center,
                  styleNew: MyTextStyle(
                    colorNew: appColors.lightColor,
                    fontWeightNew: FontWeight.w500,
                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              widget.onCategoryChanged(value!);
            },
          ),
        ),
        SizedBox(
          height: ResponsiveFlutter.of(context).verticalScale(10),
        ),
        if (widget.showOtherCategory)
          Container(
            height: ResponsiveFlutter.of(context).verticalScale(50),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveFlutter.of(context).moderateScale(20),
            ),
            decoration: BoxDecoration(
              color: appColors.appLightColor,
              borderRadius: BorderRadius.circular(
                ResponsiveFlutter.of(context).moderateScale(20),
              ),
              border: Border.all(
                color: appColors.borderColor,
                width: 1.5,
              ),
            ),
            child: commonTestField(
              controller: widget.categoryController,
              context: context,
              keyboardType: TextInputType.multiline,
              hintText: "Entrez le nom de la catégorie",
              icon: false,
            ),
          ),
        if (widget.showOtherCategory)
          SizedBox(
            height: ResponsiveFlutter.of(context).verticalScale(10),
          ),
        Container(
          height: ResponsiveFlutter.of(context).verticalScale(50),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveFlutter.of(context).moderateScale(20),
          ),
          decoration: BoxDecoration(
            color: appColors.appLightColor,
            borderRadius: BorderRadius.circular(
              ResponsiveFlutter.of(context).moderateScale(20),
            ),
            border: Border.all(
              color: appColors.borderColor,
              width: 1.5,
            ),
          ),
          child: commonTestField(
            context: context,
            controller: widget.titleController,
            keyboardType: TextInputType.multiline,
            hintText: Strings.enterEventName,
            icon: false,
          ),
        ),
        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10),),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveFlutter.of(context).moderateScale(20),
            vertical: ResponsiveFlutter.of(context).moderateScale(15),
          ),
          decoration: BoxDecoration(
            color: appColors.appLightColor,
            borderRadius: BorderRadius.circular(
              ResponsiveFlutter.of(context).moderateScale(20),
            ),
            border: Border.all(
              color: appColors.borderColor,
              width: 1.5,
            ),
          ),
          child: TextField(
            style: MyTextStyle(
              colorNew: appColors.lightColor,
              fontWeightNew: FontWeight.w400,
              size: ResponsiveFlutter.of(context).fontSize(1.8),
            ),
            cursorColor: appColors.lightColor,
            keyboardType: TextInputType.multiline,
            expands: false,
            controller: widget.detailsController,
            maxLines: 5,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: Strings.enterEventDetails,
              hintStyle: MyTextStyle(
                colorNew: appColors.lightColor,
                fontWeightNew: FontWeight.w400,
                size: ResponsiveFlutter.of(context).fontSize(1.8),
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}