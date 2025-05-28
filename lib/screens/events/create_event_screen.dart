import 'dart:convert';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/event/event_pack_model.dart';
import 'package:kuuwaa/model/event/event_specification_model.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuuwaa/screens/events/creation/event_general_information.dart';
import 'package:kuuwaa/screens/events/creation/map_picker_view.dart';
import 'package:kuuwaa/screens/events/creation/other_information.dart';
import 'package:kuuwaa/screens/events/creation/place_date_hour.dart';
import 'package:kuuwaa/screens/events/creation/resume.dart';
import 'package:kuuwaa/screens/events/creation/template_choice.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  LatLng? placeCoords;

  String street = "";
  String ref = "";

  List<EventSpecificationModel> specifications = [];

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

  EventCategoryModel selectedCategory = EventCategoryModel(
    id: 0,
    name: "Catégorie"
  );
  List items = [];

  List<Map<String, dynamic>> prices = [];
  List<Widget> pricesList = [];

  EventPackModel? selectedPack;
  EventViewModel eventViewModel = EventViewModel();
  EventTemplateModel? eventTemplateModel;

  _onChanged(int index) {
    setState(() {
      step = index;
    });
  }

  UserModel user = UserModel();

  @override
  void initState() {
    List<dynamic> fetchedCategories = [selectedCategory];
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });

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
    eventViewModel.getTemplates(context).then((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _pageNames = [
      "Informations générales",
      "Lieu, date et heure",
      "Autres informations",
      "Modèle de design",
      "Vérifier et confirmer",
    ];

    final List<Widget> _pages = [
      EventGeneralInformation(
        selectedCategory: selectedCategory,
        onCategoryChanged: (value) {
          EventCategoryModel dataModel = value as EventCategoryModel;
          setState(() {
            selectedCategory = value;
            if (dataModel.id == null) {
              showOtherCategory = true;
            } else {
              showOtherCategory = false;
            }
          });
        },
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
        onStartDateConfirm: (value) {
          setState(() {
            startDate = value;
            endDate = null;
          });
        },
        onEndDateConfirm: (value) {
          setState(() {
            endDate = value;
          });
        },
        placeNameController: _placeNameController,
        addressController: _addressController,
        onCoordinatesPicked: (latLng) {
          setState(() {
            placeCoords = latLng;
          });
        },
      ),
      OtherInformation(
        specifications: specifications,
        addSpecification: (spec) {
          setState(() {
            specifications.add(spec);
          });
        },
        removeSpecification: (spec) {
          setState(() {
            specifications.remove(spec);
          });
        },
      ),
      TemplateChoice(
        templates: eventViewModel.templates,
        eventTemplateModel: eventTemplateModel,
        placeNameController: _placeNameController,
        endDate: endDate,
        startDate: startDate,
        addressController: _addressController,
        detailsController: _detailsController,
        imageFile: imageFile,
        selectedCategory: selectedCategory,
        titleController: _titleController,
        changeTemplate: (template) {
          setState(() {
            eventTemplateModel = template;
          });
        },
      ),
      Resume(
        titles: _pageNames,
        imageFile: imageFile,
        titleController: _titleController,
        selectedCategory: selectedCategory,
        detailsController: _detailsController,
        addressController: _addressController,
        startDate: startDate,
        endDate: endDate,
        placeNameController: _placeNameController,
        eventTemplateModel: eventTemplateModel,
        specifications: specifications,
        goToSection: (page) {
          setState(() {
            _controller.jumpToPage(page);
            step = page;
          });
        },
      ),
    ];

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
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
              Container(
                decoration: BoxDecoration(
                  color: appColors.appMediumColor,
                  border: Border(top: BorderSide(color: appColors.greyTextColor, width: 1))
                ),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
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

                          if (_controller.page!.toInt() < _pages.length - 1)  {
                            bool hasErrors = false;
                            if (_controller.page!.toInt() == 0 /* GENERAL INFORMATION */) {
                              if (imageFile == null) {
                                hasErrors = true;
                                Utils.flushBarErrorMessage("Vous devez ajouter une image", context);
                              } else if (selectedCategory.id == 0) {
                                hasErrors = true;
                                Utils.flushBarErrorMessage("Vous devez choisir une catégorie", context);
                              } else if (selectedCategory.id == null && _categoryController.text == "") {
                                hasErrors = true;
                                Utils.flushBarErrorMessage("Vous devez entrer le nom de la catégorie", context);
                              } else if (_titleController.text == "") {
                                hasErrors = true;
                                Utils.flushBarErrorMessage("Vous devez entrer un titre de l'évenement", context);
                              } else if (_detailsController.text == "") {
                                hasErrors = true;
                                Utils.flushBarErrorMessage("Vous devez entrer un message description de l'évenement", context);
                              }
                            }

                            if (_controller.page!.toInt() == 1 /* PLACE - DATE - HOUR */) {
                              if (startDate == null) {
                                hasErrors = true;
                                Utils.flushBarErrorMessage("Vous devez entrer la date et l'heure de débu de l'évenement", context);
                              } else if (endDate == null) {
                                hasErrors = true;
                                Utils.flushBarErrorMessage("Vous devez entrer la date et l'heure de la fin de l'évenement", context);
                              } else if (placeCoords == null) {
                                hasErrors = true;
                                Utils.flushBarErrorMessage("Vous devez confirmer le lieu sur le map", context);
                              }
                            }

                            if (_controller.page!.toInt() == 3 /* template */) {
                              if (eventTemplateModel == null) {
                                hasErrors = true;
                                Utils.flushBarErrorMessage("Vous devez choisir un modèle d'invitation l'évenement", context);
                              }
                            }

                            if (!hasErrors) {
                              _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear
                              );
                            }
                          } else {
                            setState(() {
                              loadingNext = true;
                            });
                            List<String?> specs = specifications.map((e) => e.name).toList();

                            Map data = {
                              "title": _titleController.text,
                              "category_id": selectedCategory.id,
                              "image": image,
                              "details": _detailsController.text,
                              "category_name": _categoryController.text,

                              "start_date": startDate.toString(),
                              "end_date": endDate.toString(),
                              "address": _addressController.text,
                              "place_name": _placeNameController.text,
                              "place_longitude": placeCoords!.longitude.toString(),
                              "place_latitude": placeCoords!.latitude.toString(),
                              "specifications": jsonEncode(specs),

                              "template_id": eventTemplateModel!.id,
                              "user_uid": user.uid
                            };
                            await eventViewModel.createEventApi(context, data).then((value) {
                              setState(() {
                                loadingNext = true;
                              });
                            });
                          }

                          setState(() {
                            loadingNext = false;
                          });
                        }
                      },
                      child: CommonButton(
                        loading: loadingNext,
                        title: step == _pages.length - 1 ? "Créer l'évenement" : Strings.next,
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
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
