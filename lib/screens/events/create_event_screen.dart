import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/dotted_line.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/address/address_model.dart';
import 'package:kuuwaa/model/address/country_model.dart';
import 'package:kuuwaa/model/address/province_model.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/event/event_pack_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/events/creation/event_general_information.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  int step = 1;
  int maxStep = 4;
  bool loading = false;
  bool loadingCreation = false;
  bool loadingNext = false;
  bool paying = false;

  String street = "";
  String ref = "";

  int selected = 1;
  EventModel event = EventModel(
    paidEvent: false
  );

  var maskFormatter = MaskTextInputFormatter(
      mask: '*## ### ###',
      filter: { "#": RegExp(r'\d'), "*": RegExp(r'[7-9]') },
      type: MaskAutoCompletionType.lazy
  );
  final TextEditingController _phoneController = TextEditingController();

  Map<String, dynamic> selectedProvince = {
    "name": "",
    "id": null
  };

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
  final TextEditingController _detailsController = TextEditingController();

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _refController = TextEditingController();

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
      step = index + 1;
    });
  }

  @override
  void initState() {
    List<dynamic> fetchedCategories = [dropDownValue];
    eventViewModel.getCategories(context, event.paidEvent == true).then((value) {
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

  _pickDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: date ?? DateTime.now(),
    );
    if(date != null) {
      setState(() {
        date = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> featuresWidget = [];

    final List<Widget> _pages = [
      EventGeneralInformation(
        categoriesDropDown: dropDownValue,
        categoryController: _categoryController,
        detailsController: _detailsController,
        imageFile: imageFile,
        items: items,
        onImagePick: imagePick,
        showOtherCategory: showOtherCategory,
        titleController: _titleController,
      ),
      GestureDetector(
        onTap: () async {
          DatePicker.showDateTimePicker(
              context,
              showTitleActions: true,
              minTime: DateTime.now(),
              onConfirm: (value) {
                setState(() {
                  date = value;
                });
              }, currentTime: DateTime.now(), locale: LocaleType.fr);
          // showModalBottomSheet(
          //     isScrollControlled: true,
          //     shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.only( // <-- SEE HERE
          //         topLeft: Radius.circular(10.0),
          //         topRight: Radius.circular(10.0),
          //       ),
          //     ),
          //     context: context,
          //     builder: (context) {
          //       return SizedBox(
          //         height: 250,
          //         child: CupertinoDatePicker(
          //           dateOrder: DatePickerDateOrder.dmy,
          //           onDateTimeChanged: (DateTime value) {
          //             setState(() {
          //               date = value;
          //             });
          //           },
          //           use24hFormat: true,
          //           // initialDateTime: date ?? DateTime.now(),
          //           minimumDate: DateTime.now(),
          //           mode: CupertinoDatePickerMode.dateAndTime,
          //         ),
          //       );
          //     }
          // );
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
      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10),),
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
                return StatefulBuilder(
                    builder: (context, setState) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                MyTextView(
                                  "Entrez l'adresse de l'évenement",
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
                                    controller: _streetController,
                                    hintText: "Adresse complète",
                                    keyboardType: TextInputType.text,
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
                                    controller: _refController,
                                    hintText: "Lieu de l'évenement (optionnel)",
                                    keyboardType: TextInputType.text,
                                    icon: true,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      street = _streetController.text;
                                      ref = _refController.text;
                                    });
                                    Navigator.pop(context);
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
                                          "Valider",
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
                        ),
                      );
                    }
                );
              }
          );
        },
        child: Container(
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
                  street == "" ? "Adresse" : street + ". " +  selectedProvince["name"] + " (" + ref + ")",
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
                        "Pack",
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
                        "Coût du pack",
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
                  ListView.builder(
                    itemCount: event.features == null ? 0 : event.features!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      FeatureModel element = event.features![index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
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
                              // MyTextView(
                              //   "+" + element.price!.toInt().toString() + "\$",
                              //   textAligntNew: TextAlign.center,
                              //   styleNew: MyTextStyle(
                              //     colorNew: appColors.green,
                              //     fontWeightNew: FontWeight.w600,
                              //     size: ResponsiveFlutter.of(context).fontSize(1.5),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
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
                          total.toInt().toString() + "\$ HT",
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
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 40) / _pages.length,
                  height: 5,
                  color: appColors.btnColor,
                )
              ],
            ),
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
                if (! loadingNext) {
                  setState(() {
                    loadingNext = true;
                  });
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
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear
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
                    } else if (_detailsController.text == "") {
                      Utils.flushBarErrorMessage("Vous devez entrer un message description de l'évenement", context);
                    } else if (selectedProvince["id"] == null || _streetController.text == "") {
                      Utils.flushBarErrorMessage("Vous devez compléter les informations de l'adress", context);
                    } else {
                      event.date = date;
                      event.name = _titleController.text;
                      event.category = categoryValue;
                      event.details = _detailsController.text;
                      event.address = AddressModel(
                          country: CountryModel(
                              id: 1,
                              name: "République Démocratique du Congo"
                          ),
                          number: _numberController.text,
                          province: ProvinceModel.fromJson(selectedProvince),
                          street: _streetController.text,
                          ref: _refController.text
                      );

                      eventViewModel.getPacksApi(context);
                      eventViewModel.getFeaturesApi(context);

                      _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear
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
                                                            // const SizedBox(width: 10,),
                                                            // MyTextView(
                                                            //   "+${element.price?.toInt()}\$",
                                                            //   textAligntNew: TextAlign.start,
                                                            //   maxLineWrap: true,
                                                            //   styleNew: MyTextStyle(
                                                            //     colorNew: appColors.btnColor,
                                                            //     fontWeightNew: FontWeight.w700,
                                                            //     size: ResponsiveFlutter.of(context).fontSize(1.3),
                                                            //   ),
                                                            // ),
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
                                                  onTap: () async {
                                                    if (loadingCreation != true) {
                                                      setState(() {
                                                        loadingCreation = true;
                                                        event.features = selectedFeatures;
                                                        loading = true;
                                                        total += event.eventPack!.price!;
                                                        event.features?.forEach((element) {
                                                          total += element.price!;
                                                        });
                                                      });

                                                      EventViewModel eventViewModel2 = EventViewModel();
                                                      await eventViewModel2.createEventApi(context, event, image).then((value) {
                                                        Navigator.pop(context);
                                                        if (value.runtimeType == int) {
                                                          setState(() {
                                                            event.id = value;
                                                          });
                                                        }
                                                        setState(() {
                                                          loadingCreation = false;
                                                        });

                                                        // remove when handle payment
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => const BottomBarScreen(),
                                                          ),
                                                        );

                                                        // _controller.nextPage(
                                                        //     duration: const Duration(milliseconds: 300),
                                                        //     curve: Curves.linear
                                                        // );
                                                      });
                                                    }
                                                  },
                                                  child: CommonButton(
                                                    loading: loadingCreation,
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
                                              Navigator.pop(context);
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
                                                                    const Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Text("Entrez votre numéro mobile monney...", style: TextStyle(
                                                                            fontWeight: FontWeight.bold
                                                                        ), textAlign: TextAlign.center,),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Image.asset(ImagePath.map),
                                                                    const SizedBox(height: 10,),
                                                                    Container(
                                                                      height: ResponsiveFlutter.of(context).verticalScale(40),
                                                                      padding: EdgeInsets.symmetric(
                                                                        vertical: ResponsiveFlutter.of(context).moderateScale(5),
                                                                        horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                                                                      ),
                                                                      margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(25)),
                                                                      decoration: BoxDecoration(
                                                                          color: appColors.lightColor,
                                                                          borderRadius: BorderRadius.circular(
                                                                            ResponsiveFlutter.of(context).moderateScale(25),
                                                                          ),
                                                                          border: Border.all(color: appColors.borderColor, width: 1)
                                                                      ),
                                                                      child: commonTestField(
                                                                        textColor: appColors.borderColor,
                                                                        context: context,
                                                                        controller: _phoneController,
                                                                        initial: "+243",
                                                                        hintText: "XXX XXX XXX",
                                                                        keyboardType: TextInputType.phone,
                                                                        inputFormatters: [maskFormatter],
                                                                        icon: true,
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            Map data = {
                                                                              "phoneNumber": _phoneController.text
                                                                            };
                                                                            setState(() {
                                                                              paying = true;
                                                                            });
                                                                            EventViewModel eventViewModel2 = EventViewModel();
                                                                            await eventViewModel2.payPackApi(context, data, event).then((value) {
                                                                              setState(() {
                                                                                paying = false;
                                                                              });
                                                                              if (value != null && value.containsKey('success') && value['success']) {
                                                                                Navigator.pop(context);
                                                                                showDialog(
                                                                                  context: context,
                                                                                  barrierDismissible: false,
                                                                                  builder: (context) {
                                                                                    Utils.checkPaymentResponse(context, value['orderNumber'], event);
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
                                                                                                      const SizedBox(height: 10,),
                                                                                                      const CupertinoActivityIndicator(color: Colors.black, radius: 20,),
                                                                                                      const SizedBox(height: 10,),
                                                                                                      Text(value['message'].toString(), style: const TextStyle(
                                                                                                          fontWeight: FontWeight.bold
                                                                                                      ), textAlign: TextAlign.center,),
                                                                                                      const SizedBox(height: 10,),
                                                                                                      const Text("Veuillez patienter", style: TextStyle(
                                                                                                        fontSize: 11
                                                                                                      ), textAlign: TextAlign.center,),
                                                                                                      const SizedBox(height: 10,),
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
                                                                                Utils.flushBarErrorMessage(Utils.errorMessage, context);
                                                                                setState(() {
                                                                                  paying = false;
                                                                                });
                                                                              }
                                                                            });
                                                                          },
                                                                          child: CommonButton(
                                                                            title: "Continuer",
                                                                            loading: paying,
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
                                                        "Payer par mobile money",
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
                  setState(() {
                    loadingNext = false;
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: step == 3 ? 10 : 20, left: 20, right: 20),
                child: CommonButton(
                  loading: loadingNext,
                  title: step == 3 ? "Payer maintenant" : Strings.next,
                ),
              )
            ),
            if (step == 3)
            GestureDetector(
              onTap: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomBarScreen(),
                  ),
                );
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
                    if (loadingNext)
                    CupertinoActivityIndicator(color: appColors.lightColor, animating: true, radius: 8),
                    if (loadingNext)
                    const SizedBox(width: 10,),
                    if (!loadingNext)
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
            const SizedBox(height: 20,),
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
