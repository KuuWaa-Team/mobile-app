import 'dart:io';
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
import 'package:kuuwaa/screens/events/creation/other_information.dart';
import 'package:kuuwaa/screens/events/creation/place_date_hour.dart';
import 'package:kuuwaa/screens/events/creation/template_choice.dart';
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
  int step = 0;
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

  DateTime? startDate;
  DateTime? endDate;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _placeNameController = TextEditingController();

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
    eventViewModel.getTemplates(context).then((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> featuresWidget = [];

    final List _pageNames = [
      "Informations générales",
      "Lieu, date et heure",
      "Autres informations",
      "Modèle de design",
      "Vérifier et confirmer",
    ];

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
      PlaceDateHour(
        startDate: startDate,
        endDate: endDate,
        placeNameController: _placeNameController,
        addressController: _categoryController,
      ),
      OtherInformation(),
      TemplateChoice(templates: eventViewModel.templates,),
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
                  Divider(color: appColors.lightColor.withOpacity(.1),
                      height: 20,
                      thickness: .5),
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
                        event.category == null ? "" : event.category!.name
                            .toString(),
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
                      Text(
                        event.details != null ? (event.details!.length > 30
                            ? event.details.toString().substring(0, 30) + "..."
                            : event.details.toString()) : "",
                        style: TextStyle(
                            fontSize: 12,
                            color: appColors.lightColor,
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  ),
                  Divider(color: appColors.lightColor.withOpacity(.1),
                      height: 20,
                      thickness: .5),
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
                  Divider(color: appColors.lightColor.withOpacity(.1),
                      height: 20,
                      thickness: .5),
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
                        event.eventPack == null ? "" : event.eventPack!.name
                            .toString(),
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
                        "Nombre d'invitations",
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                      MyTextView(
                        event.eventPack == null ? "" : (event.eventPack!
                            .maxTickets == null ? "illimités" : event.eventPack!
                            .maxTickets.toString()),
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
                        "Coût du pack",
                        textAligntNew: TextAlign.center,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor.withOpacity(.5),
                          fontWeightNew: FontWeight.w400,
                          size: ResponsiveFlutter.of(context).fontSize(1.5),
                        ),
                      ),
                      MyTextView(
                        event.eventPack == null ? "" : event.eventPack!.price!
                            .toInt().toString() + "\$",
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
                    itemCount: event.features == null ? 0 : event.features!
                        .length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      FeatureModel element = event.features![index];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Divider(color: appColors.lightColor.withOpacity(.1),
                              height: 20,
                              thickness: .5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyTextView(
                                "+ ${element.name}",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor.withOpacity(
                                      .5),
                                  fontWeightNew: FontWeight.w400,
                                  size: ResponsiveFlutter.of(context).fontSize(
                                      1.5),
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
                        border: Border.all(width: 1,
                            color: appColors.lightColor.withOpacity(.1))
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
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
            Row(
              children: List.generate(_pages.length, (index) {
                return Expanded(
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: step >= index ? appColors.btnColor : Colors.black12,
                    ),
                  ),
                );
              }),
            ),
            commonAppBar(
              title: _pageNames[step],
              backArrow: true,
              context: context,
              backClick: () {
                if (step == 0) {
                  Navigator.pop(context);
                } else {
                  _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.linear
                  );
                }
              }
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
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  SizedBox(
                      width: 13, height: 13,
                      child: CircularProgressIndicator(color: appColors.btnColor, strokeWidth: 2,)
                  ),
                  const SizedBox(width: 10,),
                  MyTextView(
                    "Création d'événement en cours...",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.btnColor,
                      fontWeightNew: FontWeight.w500,
                      size: ResponsiveFlutter.of(context).fontSize(1.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40),)
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (!loadingNext) {
                        setState(() {
                          loadingNext = true;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                        List<dynamic> fetchedCategories = [dropDownValue];

                        if (_controller.page!.toInt() == _pages.length - 1) {
                          EventCategoryModel categoryValue = dropDownValue as EventCategoryModel;
                          if (imageFile == null) {
                            Utils.flushBarErrorMessage("Vous devez ajouter une image", context);
                          } else if (categoryValue.id == 0) {
                            Utils.flushBarErrorMessage("Vous devez choisir une catégorie", context);
                          } else if (categoryValue.id == null && _categoryController.text == "") {
                            Utils.flushBarErrorMessage("Vous devez entrer le nom de la catégorie", context);
                          } else if (_titleController.text == "") {
                            Utils.flushBarErrorMessage("Vous devez entrer un titre de l'évenement", context);
                          } else if (startDate == null) {
                            Utils.flushBarErrorMessage("Vous devez entrer la date de l'évenement", context);
                          } else if (_detailsController.text == "") {
                            Utils.flushBarErrorMessage("Vous devez entrer un message description de l'évenement", context);
                          } else if (selectedProvince["id"] == null || _addressController.text == "") {
                            Utils.flushBarErrorMessage("Vous devez compléter les informations de l'adress", context);
                          } else {
                            event.date = startDate;
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
                                street: _addressController.text,
                                ref: _placeNameController.text
                            );

                            eventViewModel.getPacksApi(context);
                            eventViewModel.getFeaturesApi(context);

                            _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear
                            );
                          }
                        } else {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear
                          );
                        }
                        setState(() {
                          loadingNext = false;
                        });
                      }
                    },
                    child: CommonButton(
                      loading: loadingNext,
                      title: step == _pages.length - 1 ? "Payer maintenant" : Strings.next,
                    )
                  ),
                   if (step == _pages.length - 1)
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
                ],
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
