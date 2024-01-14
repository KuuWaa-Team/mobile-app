import 'dart:io';
import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/dotted_line.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/event/event_pack_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:provider/provider.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  AppColors appColors = AppColors();
  String? selectedDate = "Select date";
  String? selectedTime = "Select time";
  int step = 0;
  int maxStep = 4;
  bool loading = false;

  int selected = 1;
  EventModel event = EventModel(
    paidEvent: false
  );

  double total = 0;

  bool showOtherCategory = false;

  final PageController _controller = PageController();

  List<FeatureModel> features = [];
  List<FeatureModel> selectedFeatures = [];

  final ImagePicker picker = ImagePicker();
  XFile? image;
  File? imageFile;

  TimeOfDay time = TimeOfDay.now();

  bool addingPrice = false;

  DateTime? date;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  final TextEditingController _priceCategoryController = TextEditingController();
  final TextEditingController _priceValueController = TextEditingController();

  Object dropDownValue = EventCategoryModel(
    id: 0,
    name: "Catégorie"
  );
  List items = [];

  List<Map<String, dynamic>> prices = [];
  List<Widget> pricesList = [];

  EventPackModel? selectedPack;
  EventViewModel eventViewModel = EventViewModel();

  _onChanged(int index) {
    setState(() {
      step = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> featuresWidget = [];
    if (features.isEmpty) {
      if (eventViewModel.features.isNotEmpty) {
        eventViewModel.features.forEach((element) {
          featuresWidget.add(
            Column(
              children: [
                Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextView(
                      "+ ${element.name}",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor.withOpacity(.5),
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                    MyTextView(
                      "+" + element.price!.toInt().toString() + "\$",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.green,
                        fontWeightNew: FontWeight.w600,
                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      }
    }

    final List<Widget> _pages = [
      ListView(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveFlutter.of(context).moderateScale(15),
          horizontal: ResponsiveFlutter.of(context).moderateScale(20),
        ),
        children: [
          GestureDetector(
              onTap: () {
                setState(() {
                  selected = 1;
                  event.paidEvent = false;
                });
              },
              child: Container(
                  height: ResponsiveFlutter.of(context).verticalScale(130),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(
                        ResponsiveFlutter.of(context).moderateScale(20),
                      ),
                      border: selected == 1 ? Border.all(color: appColors.btnColor, width: 3) : null
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.mail_outlined, color: selected == 1 ?  appColors.btnColor : appColors.lightColor, size: 20,),
                          const SizedBox(width: 10,),
                          MyTextView(
                            "Évenement à invitations",
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: selected == 1 ?  appColors.btnColor : appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          Icon(Icons.circle, color: appColors.lightColor, size: 10,),
                          const SizedBox(width: 10,),
                          MyTextView(
                            "Accès gratuit",
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Icon(Icons.circle, color: appColors.lightColor, size: 10,),
                          const SizedBox(width: 10,),
                          MyTextView(
                            "Adapté pour : mariage, aniversaire, ...",
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.6),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
              )
          ),
          const SizedBox(height: 20,),
          GestureDetector(
              onTap: () {
                setState(() {
                  selected = 2;
                  event.paidEvent = true;
                });
              },
              child: Container(
                  height: ResponsiveFlutter.of(context).verticalScale(130),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(
                        ResponsiveFlutter.of(context).moderateScale(20),
                      ),
                      border:  selected == 2 ? Border.all(color:  appColors.btnColor, width: 3) : null
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.mail_outlined, color: selected == 2 ?  appColors.btnColor : appColors.lightColor, size: 20,),
                          const SizedBox(width: 10,),
                          MyTextView(
                            "Évenement à ticket (billeterie)",
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: selected == 2 ?  appColors.btnColor : appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          Icon(Icons.circle, color: appColors.lightColor, size: 10,),
                          const SizedBox(width: 10,),
                          MyTextView(
                            "Accès payant",
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Icon(Icons.circle, color: appColors.lightColor, size: 10,),
                          const SizedBox(width: 10,),
                          MyTextView(
                            "Adapté pour : concert, formation ...",
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.6),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
              )
          ),
        ],
      ),
      ListView(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveFlutter.of(context).moderateScale(15),
          horizontal: ResponsiveFlutter.of(context).moderateScale(20),
        ),
        children: [
          GestureDetector(
            onTap: () {
              imagePick();
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
                child: imageFile == null
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
                  imageFile!,
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
              value: dropDownValue,
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
              items: items.map((item) {
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
                EventCategoryModel dataModel = value as EventCategoryModel;
                setState(() {
                  dropDownValue = value;
                  if (dataModel.id == null) {
                    showOtherCategory = true;
                  } else {
                    showOtherCategory = false;
                  }
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
              controller: _categoryController,
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
              controller: _titleController,
              keyboardType: TextInputType.multiline,
              hintText: Strings.enterEventName,
              icon: false,
            ),
          ),
          SizedBox(
            height: ResponsiveFlutter.of(context).verticalScale(10),
          ),
          GestureDetector(
            onTap: () async {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only( // <-- SEE HERE
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 250,
                      child: CupertinoDatePicker(
                        dateOrder: DatePickerDateOrder.dmy,
                        onDateTimeChanged: (DateTime value) {
                          setState(() {
                            date = value;
                          });
                        },
                        use24hFormat: true,
                        // initialDateTime: DateTime.now(),
                        minimumDate: DateTime.now(),
                        mode: CupertinoDatePickerMode.dateAndTime,
                      ),
                    );
                  }
              );
            },
            child: Container  (
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MyTextView(
                      date == null ? "Date et heure" : DateFormat('dd/MM/yyyy à kk:mm').format(date!),
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.8),
                      ),
                    ),
                  ),
                  Image.asset(
                    ImagePath.pinkCalendar,
                    color: appColors.lightPinkColor,
                    height: ResponsiveFlutter.of(context).moderateScale(23),
                  )
                ],
              ),
            ),
          ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: commonTestField(
                    context: context,
                    controller: _addressController,
                    keyboardType: TextInputType.multiline,
                    hintText: Strings.location,
                    icon: false,
                  ),
                ),
                Image.asset(
                  ImagePath.pinkLocation,
                  color: appColors.lightPinkColor,
                  height: ResponsiveFlutter.of(context).moderateScale(23),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ResponsiveFlutter.of(context).verticalScale(10),
          ),
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
              controller: _detailsController,
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
          SizedBox(
            height: ResponsiveFlutter.of(context).verticalScale(10),
          ),
          if (selected == 2)
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
                                "Ajouter un prix de ticket",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor,
                                  fontWeightNew: FontWeight.w400,
                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
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
                                  controller: _priceCategoryController,
                                  hintText: "Catégorie",
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
                                  controller: _priceValueController,
                                  hintText: "Prix",
                                  keyboardType: TextInputType.phone,
                                  icon: true,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              MyTextView(
                                "Choisissez une couleur pour cette catégorie",
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor,
                                  fontWeightNew: FontWeight.w400,
                                  size: ResponsiveFlutter.of(context).fontSize(1.4),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: ResponsiveFlutter.of(context).scale(40),
                                      height: ResponsiveFlutter.of(context).verticalScale(40),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveFlutter.of(context).moderateScale(40),
                                        ),
                                      ),
                                      child: Icon(Icons.check, color: appColors.lightColor,),
                                    ),
                                    const SizedBox(width: 10,),
                                    Container(
                                      width: ResponsiveFlutter.of(context).scale(40),
                                      height: ResponsiveFlutter.of(context).verticalScale(40),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveFlutter.of(context).moderateScale(40),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Container(
                                      width: ResponsiveFlutter.of(context).scale(40),
                                      height: ResponsiveFlutter.of(context).verticalScale(40),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveFlutter.of(context).moderateScale(40),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Container(
                                      width: ResponsiveFlutter.of(context).scale(40),
                                      height: ResponsiveFlutter.of(context).verticalScale(40),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveFlutter.of(context).moderateScale(40),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Container(
                                      width: ResponsiveFlutter.of(context).scale(40),
                                      height: ResponsiveFlutter.of(context).verticalScale(40),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveFlutter.of(context).moderateScale(40),
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                              const SizedBox(height: 20,),
                              GestureDetector(
                                onTap: () {
                                  if (_priceCategoryController.text != "" && _priceValueController.text != "" && !addingPrice) {
                                    setState(() {
                                      addingPrice = true;
                                      prices.add({
                                        "category": _priceCategoryController.text,
                                        "price": _priceCategoryController.text
                                      });
                                      addingPrice = false;
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
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
                                        Strings.add,
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
                              SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10)),
                            ],
                          ),
                        ),
                      );
                    }
                );
              },
              child: Container(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyTextView(
                          "Prix des tickets",
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.8),
                          ),
                        ),
                        Icon(Icons.add_circle, color: appColors.btnColor, size: 25,)
                      ],
                    ),
                    if (pricesList.isNotEmpty)
                      const SizedBox(height: 15,),
                    Wrap(
                      runAlignment: WrapAlignment.start,
                      alignment: WrapAlignment.start,
                      runSpacing: 10,
                      spacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: pricesList,
                    )
                  ],
                ),
              ),
            ),
          // SizedBox(
          //   height: ResponsiveFlutter.of(context).verticalScale(20),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     showDialog(
          //         context: context,
          //         barrierColor: Colors.black54,
          //         barrierDismissible: true,
          //         builder: (context) {
          //           return WillPopScope(
          //             onWillPop: () async => false,
          //             child: BackdropFilter(
          //               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          //               child: Stack(
          //                 children: [
          //                   Center(
          //                     child: Container(
          //                       height: ResponsiveFlutter.of(context).verticalScale(200),
          //                       width: double.infinity,
          //                       margin: EdgeInsets.symmetric(
          //                         horizontal: ResponsiveFlutter.of(context).moderateScale(30),
          //                       ),
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(
          //                           ResponsiveFlutter.of(context).moderateScale(20),
          //                         ),
          //                         image: const DecorationImage(
          //                           image: AssetImage(ImagePath.hurray),
          //                           fit: BoxFit.fitHeight,
          //                         ),
          //                       ),
          //                       child: Column(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         children: [
          //                           Image.asset(
          //                             ImagePath.ok,
          //                             height: ResponsiveFlutter.of(context).verticalScale(55),
          //                           ),
          //                           SizedBox(
          //                             height: ResponsiveFlutter.of(context).verticalScale(10),
          //                           ),
          //                           MyTextView(
          //                             Strings.hurray,
          //                             styleNew: MyTextStyle(
          //                               colorNew: appColors.white,
          //                               size: ResponsiveFlutter.of(context).fontSize(3.3),
          //                               fontWeightNew: FontWeight.bold,
          //                             ),
          //                           ),
          //                           SizedBox(
          //                             height: ResponsiveFlutter.of(context).verticalScale(10),
          //                           ),
          //                           MyTextView(
          //                             Strings.yourEventSuccessfullyCreated,
          //                             styleNew: MyTextStyle(
          //                               colorNew: appColors.white,
          //                               size: ResponsiveFlutter.of(context).fontSize(2.2),
          //                               fontWeightNew: FontWeight.w400,
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                   Align(
          //                     alignment: Alignment.bottomCenter,
          //                     child: GestureDetector(
          //                       onTap: () {
          //                         Navigator.pop(context);
          //                       },
          //                       child: Padding(
          //                         padding: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(20)),
          //                         child: Image.asset(
          //                           ImagePath.close,
          //                           height: ResponsiveFlutter.of(context).verticalScale(45),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           );
          //         });
          //   },
          //   child: commonButton(
          //     context: context,
          //     title: Strings.createEvent,
          //   ),
          // ),
          // SizedBox(
          //   height: ResponsiveFlutter.of(context).verticalScale(80),
          // ),
        ],
      ),
      ChangeNotifierProvider<EventViewModel>(
          create: (BuildContext context) => eventViewModel,
          child: Consumer<EventViewModel>(
              builder: (context, value, _) {
                switch (value.packList.status) {
                  case Status.LOADING:
                    return const Column(
                      children: [
                        SizedBox(height: 20,),
                        EventShimmer(),
                        SizedBox(height: 20,),
                        EventShimmer(),
                        SizedBox(height: 20,),
                        EventShimmer(),
                      ],
                    );
                  case Status.ERROR:
                    return Center(
                      child: Text(value.eventsList.message.toString()),
                    );
                  case Status.COMPLETED:
                    List<EventPackModel> packs = eventViewModel.packList.data;
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveFlutter.of(context).moderateScale(15),
                        horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                      ),
                      itemCount: packs.length,
                      itemBuilder: (context, index) {
                        EventPackModel pack = packs[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPack = pack;
                            });
                          },
                          child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: appColors.appLightColor,
                                borderRadius: BorderRadius.circular(
                                  ResponsiveFlutter.of(context).moderateScale(10),
                                ),
                                border: selectedPack != null && selectedPack!.id == pack.id ? Border.all(color: appColors.btnColor, width: 2): null
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyTextView(
                                        pack.name.toString(),
                                        textAligntNew: TextAlign.start,
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.lightColor,
                                          fontWeightNew: FontWeight.w600,
                                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                                        ),
                                      ),
                                      MyTextView(
                                        "${pack.price!.toInt()}\$",
                                        textAligntNew: TextAlign.start,
                                        styleNew: MyTextStyle(
                                          colorNew: selectedPack != null && selectedPack!.id == pack.id ? appColors.btnColor : appColors.lightColor,
                                          fontWeightNew: FontWeight.w600,
                                          size: ResponsiveFlutter.of(context).fontSize(2),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(color: appColors.lightColor.withOpacity(.05), height: 30, thickness: .5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MyTextView(
                                        pack.maxTickets != null ? "${pack.maxTickets} Invitations max": "Invitations illimitées",
                                        textAligntNew: TextAlign.start,
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.lightPinkColor,
                                          fontWeightNew: FontWeight.w400,
                                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          ),
                        );
                      },
                    );
                }
              }
          )
      ),
      ListView(
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
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  MyTextView(
                    "Résumés",
                    textAligntNew: TextAlign.center,
                    styleNew: MyTextStyle(
                      colorNew: appColors.btnColor,
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(1.8),
                    ),
                  ),
                  Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
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
                        event.name.toString(),
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          fontWeightNew: FontWeight.w600,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
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
                        event.category == null ? "" :event.category!.name.toString(),
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          fontWeightNew: FontWeight.w600,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
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
                      Text(
                        event.details != null ? (event.details!.length > 30 ? event.details.toString().substring(0, 30) + "..." : event.details.toString()) : "",
                        style: TextStyle(
                          fontSize: 12,
                          color: appColors.lightColor,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                  Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                ],
              )
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: appColors.appLightColor,
                borderRadius: BorderRadius.circular(
                  ResponsiveFlutter.of(context).moderateScale(20),
                ),
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  MyTextView(
                    "Facturation",
                    textAligntNew: TextAlign.center,
                    styleNew: MyTextStyle(
                      colorNew: appColors.btnColor,
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(1.8),
                    ),
                  ),
                  Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyTextView(
                        "Pack pris",
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                      MyTextView(
                        event.eventPack == null ? "" : event.eventPack!.name.toString(),
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          fontWeightNew: FontWeight.w600,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyTextView(
                        "Nombre d'invitations",
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                      MyTextView(
                        event.eventPack == null ? "" : (event.eventPack!.maxTickets == null ? "illimités" : event.eventPack!.maxTickets.toString()),
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          fontWeightNew: FontWeight.w600,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyTextView(
                        "Coût du package",
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                      MyTextView(
                        event.eventPack == null ? "" : event.eventPack!.price!.toInt().toString() + "\$",
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.green,
                          fontWeightNew: FontWeight.w600,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                    ],
                  ),
                  ...featuresWidget,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: appColors.lightColor.withOpacity(.1))
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyTextView(
                          "Total à payer",
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                        MyTextView(
                          total.toInt().toString() + "\$",
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.green,
                            fontWeightNew: FontWeight.w600,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    ];

    pricesList = [];
    for (var element in prices) {
      pricesList.add(
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: appColors.iconColor.withOpacity(.3))
            ),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: CupertinoColors.systemYellow, size: 10,),
                const SizedBox(width: 5,),
                MyTextView(
                  element["category"],
                  textAligntNew: TextAlign.center,
                  styleNew: MyTextStyle(
                    colorNew: appColors.lightColor,
                    fontWeightNew: FontWeight.w400,
                    size: ResponsiveFlutter.of(context).fontSize(1.3),
                  ),
                ),
                const SizedBox(width: 5,),
                MyTextView(
                  element["price"] + "\$",
                  textAligntNew: TextAlign.center,
                  styleNew: MyTextStyle(
                    colorNew: appColors.lightColor,
                    fontWeightNew: FontWeight.w400,
                    size: ResponsiveFlutter.of(context).fontSize(1.3),
                  ),
                ),
                const SizedBox(width: 10,),
                Icon(Icons.clear, size: 15, color: appColors.iconColor,)
              ],
            ),
          )
      );
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              title: Strings.createEvent,
              backArrow: true,
              context: context,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextView(
                  (step + 1).toString(),
                  textAligntNew: TextAlign.center,
                  styleNew: MyTextStyle(
                    colorNew: appColors.btnColor,
                    fontWeightNew: FontWeight.w600,
                    size: ResponsiveFlutter.of(context).fontSize(3),
                  ),
                ),
                MyTextView(
                  "/" + maxStep.toString(),
                  textAligntNew: TextAlign.center,
                  styleNew: MyTextStyle(
                    colorNew: appColors.lightColor.withOpacity(.8),
                    fontWeightNew: FontWeight.w300,
                    size: ResponsiveFlutter.of(context).fontSize(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5,),
            MyTextView(
              step == 0 ? "Type d'évenement" : (
                step == 1 ? "Détails de l'évenement" : (
                  step == 2 ? "Choisir un pack" : "Paiement"
                )
            ),
              textAligntNew: TextAlign.center,
              styleNew: MyTextStyle(
                colorNew: appColors.lightColor,
                fontWeightNew: FontWeight.w400,
                size: ResponsiveFlutter.of(context).fontSize(1.3),
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child:
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                onPageChanged:_onChanged,
                itemBuilder: (context, int index) {
                  return _pages[index];
                },
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                List<dynamic> fetchedCategories = [dropDownValue];
                if (step == 0) {
                  await eventViewModel.getCategories(context, event.paidEvent == true).then((value) {
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
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOutQuint
                  );
                } else if (step == 1) {
                  EventCategoryModel categoryValue = dropDownValue as EventCategoryModel;
                  if (imageFile == null) {
                    Utils.flushBarErrorMessage("Vous devez ajouter une image", context);
                  } else if (categoryValue.id == 0) {
                    Utils.flushBarErrorMessage("Vous devez choisir une catégorie", context);
                  } else if (categoryValue.id == null && _categoryController.text == "") {
                    Utils.flushBarErrorMessage("Vous devez entrer le nom de la catégorie", context);
                  } else if (_titleController.text == "") {
                    Utils.flushBarErrorMessage("Vous devez entrer un titre de l'évenement", context);
                  } else if (date == null) {
                    Utils.flushBarErrorMessage("Vous devez entrer la date de l'évenement", context);
                  } else if (_addressController.text == "") {
                    Utils.flushBarErrorMessage("Vous devez entrer l'adresse", context);
                  } else if (_detailsController.text == "") {
                    Utils.flushBarErrorMessage("Vous devez entrer un message description de l'évenement", context);
                  } else {
                    event.date = date;
                    event.name = _titleController.text;
                    event.category = categoryValue;
                    event.address = _addressController.text;
                    event.details = _detailsController.text;

                    eventViewModel.getPacksApi(context);
                    eventViewModel.getFeaturesApi(context);

                    _controller.nextPage(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutQuint
                    );
                  }
                } else if (step == 2) {
                  if (selectedPack == null) {
                    Utils.flushBarErrorMessage("Vous devez séléctionner un pack", context);
                  } else {
                    event.eventPack = selectedPack!;
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
                                    Positioned(
                                        right: 0,
                                        top: 0,
                                        child: IconButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, icon: const Icon(Icons.close)
                                        )
                                    ),
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
                                                Icons.card_giftcard,
                                                color: appColors.btnColor,
                                                size: 50,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Appuyez sur ces fonctionnalités pour les ajouter à votre évenement", style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ), textAlign: TextAlign.center,),
                                            ],
                                          ),
                                          const SizedBox(height: 20,),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: eventViewModel.features.length,
                                            itemBuilder: (context, index) {
                                              FeatureModel element = eventViewModel.features[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  if (selectedFeatures.contains(element)) {
                                                    setState(() {
                                                      selectedFeatures.remove(element);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      selectedFeatures.add(element);
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: appColors.appLightColor.withOpacity(.5), width: 1),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  margin: const EdgeInsets.only(bottom: 10),
                                                  width: MediaQuery.of(context).size.width,
                                                  padding: const EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Container(
                                                                width: 16,
                                                                height: 16,
                                                                padding: const EdgeInsets.all(2),
                                                                margin: const EdgeInsets.only(right: 7),
                                                                decoration: BoxDecoration(
                                                                    color: selectedFeatures.contains(element) ? appColors.btnColor : null,
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    border: selectedFeatures.contains(element) ? null : Border.all(width: 1, color: appColors.appLightColor.withOpacity(.5))
                                                                ),
                                                                child: Icon(Icons.check, size: 12, color: appColors.lightColor,),
                                                              ),
                                                              MyTextView(
                                                                element.name.toString(),
                                                                textAligntNew: TextAlign.start,
                                                                maxLineWrap: true,
                                                                styleNew: MyTextStyle(
                                                                  colorNew: appColors.black,
                                                                  fontWeightNew: FontWeight.w400,
                                                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(width: 10,),
                                                          MyTextView(
                                                            "+${element.price?.toInt()}\$",
                                                            textAligntNew: TextAlign.start,
                                                            maxLineWrap: true,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.btnColor,
                                                              fontWeightNew: FontWeight.w700,
                                                              size: ResponsiveFlutter.of(context).fontSize(1.3),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      MyTextView(
                                                        element.description.toString(),
                                                        textAligntNew: TextAlign.start,
                                                        maxLineWrap: true,
                                                        styleNew: MyTextStyle(
                                                          colorNew: appColors.black.withOpacity(.5),
                                                          fontWeightNew: FontWeight.w400,
                                                          size: ResponsiveFlutter.of(context).fontSize(1.2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 20,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    event.features = selectedFeatures;
                                                    total += event.eventPack!.price!;
                                                    event.features?.forEach((element) {
                                                      total += element.price!;
                                                    });
                                                  });
                                                  Navigator.pop(context);
                                                  _controller.nextPage(
                                                      duration: const Duration(milliseconds: 800),
                                                      curve: Curves.easeInOutQuint
                                                  );
                                                },
                                                child: CommonButton(
                                                  loading: loading,
                                                  title: "Continuer",
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
                  }
                } else if (step == 3) {
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
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, icon: const Icon(Icons.close)
                                      )
                                  ),
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
                                              Icons.question_mark_rounded,
                                              color: appColors.btnColor,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Comment voulez-vous payer ?", style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ), textAlign: TextAlign.center,),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                        GestureDetector(
                                          onTap: () {
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: appColors.appLightColor.withOpacity(.5), width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            margin: const EdgeInsets.only(bottom: 10),
                                            width: MediaQuery.of(context).size.width,
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.mobile_screen_share_rounded, size: 17,),
                                                    const SizedBox(width: 7,),
                                                    MyTextView(
                                                      "Payer par mobile monnaie",
                                                      textAligntNew: TextAlign.start,
                                                      maxLineWrap: true,
                                                      styleNew: MyTextStyle(
                                                        colorNew: appColors.black,
                                                        fontWeightNew: FontWeight.w500,
                                                        size: ResponsiveFlutter.of(context).fontSize(1.6),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: appColors.appLightColor.withOpacity(.5), width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            margin: const EdgeInsets.only(bottom: 10),
                                            width: MediaQuery.of(context).size.width,
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.credit_card, size: 17,),
                                                    const SizedBox(width: 7,),
                                                    MyTextView(
                                                      "Payer par carte de crédit",
                                                      textAligntNew: TextAlign.start,
                                                      maxLineWrap: true,
                                                      styleNew: MyTextStyle(
                                                        colorNew: appColors.black,
                                                        fontWeightNew: FontWeight.w500,
                                                        size: ResponsiveFlutter.of(context).fontSize(1.6),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10,),
                                                  ],
                                                ),
                                                const SizedBox(height: 5,),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                              },
                                              child: CommonButton(
                                                title: "Continuer",
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
                }
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: step == 3 ? 10 : 20, left: 20, right: 20),
                child: CommonButton(
                  title: step == 3 ? "Payer maintenant" : Strings.next,
                ),
              )
            ),
            if (step == 3)
            if (step == 3)
            GestureDetector(
              onTap: ()  {
                if (!loading) {
                  setState(() {
                    loading = true;
                  });
                  EventViewModel eventViewModel2 = EventViewModel();
                  eventViewModel2.createEventApi(context, event, image);
                }
              },
              child: Container(
                height: ResponsiveFlutter.of(context).moderateScale(40),
                margin: EdgeInsets.only(
                  bottom: ResponsiveFlutter.of(context).moderateScale(20),
                  left: ResponsiveFlutter.of(context).moderateScale(20),
                  right: ResponsiveFlutter.of(context).moderateScale(20),
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
                      "Ignorer pour le moment",
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
          ],
        ),
      ),
    );
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

  selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: time,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != time) {
      time = timeOfDay;
      debugPrint("time ------------- >>>> $timeOfDay");
      selectedTime = timeOfDay.hour.toString() + " : " + timeOfDay.minute.toString();
      setState(() {});
    } else {
      debugPrint("<<<< ------------- Time Not Selected ------------- >>>>");
    }
  }
}
