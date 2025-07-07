import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_pack_model.dart';
import 'package:kuuwaa/model/event/event_specification_model.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/model/event/feature_model.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
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
  final AppColors appColors = AppColors();

  final PageController _controller = PageController();
  final ImagePicker picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _placeNameController = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: '*## ### ###',
    filter: {"#": RegExp(r'\d'), "*": RegExp(r'[7-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  int step = 0;
  bool loadingNext = false;
  bool showOtherCategory = false;
  bool useGoogleMaps = true;
  bool showEndDate = true;

  List<EventSpecificationModel> specifications = [];
  List<FeatureModel> features = [];
  List<FeatureModel> selectedFeatures = [];

  XFile? image;
  File? imageFile;
  LatLng? placeCoords;

  DateTime? startDate;
  DateTime? endDate;

  String? selectedDate = "Select date";
  String? selectedTime = "Select time";
  TimeOfDay time = TimeOfDay.now();

  UserModel user = UserModel();
  EventViewModel eventViewModel = EventViewModel();
  EventCategoryModel selectedCategory = EventCategoryModel(id: 0, name: "Catégorie");
  EventTemplateModel? eventTemplateModel;

  List items = [];
  List<String> _pageNames = [];
  List<Widget> _pages = [];

  bool pagesInitialized = false;

  @override
  void initState() {
    super.initState();

    List<dynamic> fetchedCategories = [selectedCategory];
    fetchedCategories.add(EventCategoryModel(id: null, name: "Autre (À préciser)"));

    UserViewModel().getUser().then((value) {
      setState(() => user = value);
    });

    eventViewModel.getTemplates(context);
    eventViewModel.getCategories(context).then((value) {
      for (var element in eventViewModel.categories) {
        fetchedCategories.add(element);
      }
      setState(() {
        items = fetchedCategories;
        _initPages();
      });
    });
  }

  void _initPages() {
    setState(() {
      pagesInitialized = true;
    });
    _pageNames = [
      "Informations générales",
      "Lieu, date et heure",
      "Autres informations",
      "Modèle de design",
      "Vérifier et confirmer",
    ];
    _pages = [
      EventGeneralInformation(
        selectedCategory: selectedCategory,
        onCategoryChanged: (value) {
          setState(() {
            selectedCategory = value as EventCategoryModel;
            showOtherCategory = selectedCategory.id == null;
            _initPages();
          });
        },
        categoryController: _categoryController,
        detailsController: _detailsController,
        imageFile: imageFile,
        items: items,
        onImagePick: _pickImage,
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
            _initPages();
          });
        },
        onEndDateConfirm: (value) {
          setState(() => endDate = value);
          _initPages();
        },
        placeNameController: _placeNameController,
        addressController: _addressController,
        onCoordinatesPicked: (latLng) => setState(() {
          placeCoords = latLng;
          _initPages();
        }),
        showEndDate: showEndDate,
        hasMaps: useGoogleMaps,
        onHasMapsChanged: (val) => setState(() {
          useGoogleMaps = val;
          placeCoords = null;
          _initPages();
        }),
        onShowEndDateChanged: (val) => setState(() {
          showEndDate = val;
          endDate = null;
          _initPages();
        }),
      ),
      OtherInformation(
        specifications: specifications,
        addSpecification: (spec) => setState(() {
          specifications.add(spec);
        _initPages();
        }),
        removeSpecification: (spec) => setState(() {
          specifications.remove(spec);
          _initPages();
        }),
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
        changeTemplate: (template) => setState(() {
          eventTemplateModel = template;
          _initPages();
        }),
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
            _initPages();
          });
        },
      ),
    ];
  }

  void _pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image!.path);
    }
    setState(() {
      _initPages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: items.isEmpty || _pages.isEmpty
            ? Center(child: CircularProgressIndicator(color: appColors.btnColor))
            : Column(
          children: [
            Row(
              children: List.generate(_pages.length, (index) {
                return Expanded(
                  child: Container(
                    height: 5,
                    color: step >= index ? appColors.btnColor : Colors.black12,
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
                    curve: Curves.linear,
                  );
                }
              },
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => step = index),
                itemBuilder: (context, index) => _pages[index],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              child: GestureDetector(
                onTap: () async {
                  if (!loadingNext) {
                    setState(() => loadingNext = true);
                    FocusManager.instance.primaryFocus?.unfocus();

                    bool hasErrors = false;
                    final currentPage = _controller.page!.toInt();

                    if (currentPage == 0) {
                      if (imageFile == null || _titleController.text.isEmpty || _detailsController.text.isEmpty ||
                          selectedCategory.id == 0 ||
                          (selectedCategory.id == null && _categoryController.text.isEmpty)) {
                        hasErrors = true;
                        Utils.flushBarErrorMessage("Veuillez remplir toutes les informations", context);
                      }
                    }

                    if (currentPage == 1) {
                      if (startDate == null ||
                          (endDate == null && showEndDate) ||
                          (placeCoords == null && useGoogleMaps)) {
                        hasErrors = true;
                        Utils.flushBarErrorMessage("Veuillez compléter les informations de lieu/date", context);
                      }
                    }

                    if (currentPage == 3 && eventTemplateModel == null) {
                      hasErrors = true;
                      Utils.flushBarErrorMessage("Veuillez choisir un modèle d'invitation", context);
                    }

                    if (!hasErrors) {
                      if (currentPage < _pages.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      } else {
                        final data = {
                          "title": _titleController.text,
                          "category_id": selectedCategory.id,
                          "image": image,
                          "details": _detailsController.text,
                          "category_name": _categoryController.text,
                          "start_date": startDate.toString(),
                          "end_date": endDate.toString(),
                          "address": _addressController.text,
                          "place_name": _placeNameController.text,
                          "place_longitude": placeCoords?.longitude.toString(),
                          "place_latitude": placeCoords?.latitude.toString(),
                          "specifications": jsonEncode(specifications.map((e) => e.name).toList()),
                          "template_id": eventTemplateModel!.id,
                          "user_uid": user.uid,
                        };
                        await eventViewModel.createEventApi(context, data);
                      }
                    }
                    setState(() => loadingNext = false);
                  }
                },
                child: CommonButton(
                  loading: loadingNext,
                  title: step == _pages.length - 1 ? "Créer l'évenement" : Strings.next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
