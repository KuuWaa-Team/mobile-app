import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/dotted_line.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/informations_screen.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class EditGeneralInformation extends StatefulWidget {
  EventModel event;

  EditGeneralInformation({
    Key? key,
    required this.event
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditGeneralInformationState();
}

class _EditGeneralInformationState extends State<EditGeneralInformation> {
  AppColors appColors = AppColors();
  EventCategoryModel selectedCategory = EventCategoryModel(id: 0, name: "Catégorie");
  UserModel? user;
  EventViewModel eventViewModel = EventViewModel();
  List<EventCategoryModel> categories = [];
  bool showOtherCategory = false;
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final detailsController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    eventViewModel.getCategories(context).then((value) {
      setState(() {
        categories = [selectedCategory, ...eventViewModel.categories];
        titleController.text = widget.event.title.toString();
        detailsController.text = widget.event.details.toString();

        bool isUnvalidatedCategory = true;
        for (EventCategoryModel categoryModel in categories) {
          if (categoryModel.id == widget.event.category!.id) {
            isUnvalidatedCategory = false;
          }
        }

        if (isUnvalidatedCategory) {
          categories.add(widget.event.category!);
        }

        categories.add(EventCategoryModel(id: null, name: "Autre (À préciser)"));
        selectedCategory = widget.event.category!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
          systemNavigationBarDividerColor: appColors.white
      ),
    );
    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            commonAppBar(
              context: context,
              title: "Modifier les informations generales",
              backArrow: true,
              backClick: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (route) => InformationsScreen(event: widget.event)));
              }
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveFlutter.of(context).moderateScale(15),
                  horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                ),
                children: [
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
                      value: selectedCategory,
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
                      items: categories.map((item) {
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
                        setState(() {
                          selectedCategory = value as EventCategoryModel;
                          showOtherCategory = selectedCategory.id == null;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(10),
                  ),
                  if (showOtherCategory)
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
                        controller: categoryController,
                        context: context,
                        keyboardType: TextInputType.multiline,
                        hintText: "Entrez le nom de la catégorie",
                        icon: false,
                      ),
                    ),
                  if (showOtherCategory)
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
                      controller: titleController,
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
                      controller: detailsController,
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
                  SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                  GestureDetector(
                    onTap: () async {
                      if (titleController.text.trim() == "") {
                        Utils.flushBarErrorMessage("Le titre ne peux pas etre vide", context);
                      } else if (detailsController.text.trim() == "") {
                        Utils.flushBarErrorMessage("Le detail ne peux pas etre vide", context);
                      } else if (selectedCategory.id == 0) {
                        Utils.flushBarErrorMessage("Vous devez choisir une categorie", context);
                      } else {
                        setState(() {
                          loading = true;
                        });
                        final data = {
                          "title": titleController.text,
                          "category_id": selectedCategory.id,
                          "details": detailsController.text,
                          "category_name": categoryController.text,
                          "step": "GENERAL_INFORMATIONS"
                        };
                        await eventViewModel.editEventApi(context, data, widget.event.id!).then((value) {
                          if (value.isNotEmpty) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (r) => InformationsScreen(event: value['event'])));
                          }
                        });
                      }
                    },
                    child: CommonButton(
                      loading: loading,
                      title: "Modifier",
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}