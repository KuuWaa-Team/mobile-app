import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_specification_model.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/screens/events/creation/event_general_information.dart';
import 'package:kuuwaa/screens/events/creation/other_information.dart';
import 'package:kuuwaa/screens/events/creation/place_date_hour.dart';
import 'package:kuuwaa/screens/events/creation/resume.dart';
import 'package:kuuwaa/screens/events/creation/template_choice.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final appColors = AppColors();
  final picker = ImagePicker();
  final controller = PageController();
  final userViewModel = UserViewModel();
  final eventViewModel = EventViewModel();

  // Form controllers
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final detailsController = TextEditingController();
  final addressController = TextEditingController();
  final placeNameController = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: '*## ### ###',
    filter: {"#": RegExp(r'\\d'), "*": RegExp(r'[7-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  // States
  int step = 0;
  bool loadingNext = false;
  bool showOtherCategory = false;
  bool useGoogleMaps = true;
  bool showEndDate = true;

  List<EventSpecificationModel> specifications = [];
  List<EventCategoryModel> categories = [];
  List<EventTemplateModel> templates = [];

  EventCategoryModel selectedCategory = EventCategoryModel(id: 0, name: "Catégorie");
  EventTemplateModel? eventTemplateModel;
  File? imageFile;
  File? templateImageFile;
  DateTime? startDate;
  DateTime? endDate;
  LatLng? placeCoords;
  UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    user = await userViewModel.getUser();
    await eventViewModel.getCategories(context);
    await eventViewModel.getTemplates(context);

    setState(() {
      categories = [selectedCategory, ...eventViewModel.categories, EventCategoryModel(id: null, name: "Autre (À préciser)")];
      templates = eventViewModel.templates;
    });
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  void _goToNextPage() async {
    setState(() => loadingNext = true);
    bool hasErrors = false;

    switch (step) {
      case 0:
        if (imageFile == null || titleController.text.isEmpty || detailsController.text.isEmpty ||
            selectedCategory.id == 0 || (selectedCategory.id == null && categoryController.text.isEmpty)) {
          hasErrors = true;
          Utils.flushBarErrorMessage("Veuillez remplir toutes les informations", context);
        }
        break;
      case 1:
        if (startDate == null || (endDate == null && showEndDate) || (placeCoords == null && useGoogleMaps)) {
          hasErrors = true;
          Utils.flushBarErrorMessage("Veuillez compléter les informations de lieu/date", context);
        }
        break;
      case 3:
        if (eventTemplateModel == null) {
          hasErrors = true;
          Utils.flushBarErrorMessage("Veuillez choisir un modèle d'invitation", context);
        }
        break;
    }

    if (!hasErrors) {
      if (step < 4) {
        controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
      } else {
        print("1111111111111111111111");
        final data = {
          "title": titleController.text,
          "category_id": selectedCategory.id,
          "image": imageFile,
          "template_image": templateImageFile,
          "details": detailsController.text,
          "category_name": categoryController.text,
          "start_date": startDate.toString(),
          "end_date": endDate.toString(),
          "address": addressController.text,
          "place_name": placeNameController.text,
          "place_longitude": placeCoords?.longitude.toString(),
          "place_latitude": placeCoords?.latitude.toString(),
          "specifications": jsonEncode(specifications.map((e) => e.name).toList()),
          "template_id": eventTemplateModel!.id,
          "user_uid": user.uid,
        };
        print("222222222222222222222222222");
        await eventViewModel.createEventApi(context, data);
      }
    }
    setState(() => loadingNext = false);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      EventGeneralInformation(
        selectedCategory: selectedCategory,
        onCategoryChanged: (value) {
          setState(() {
            selectedCategory = value as EventCategoryModel;
            showOtherCategory = selectedCategory.id == null;
          });
        },
        categoryController: categoryController,
        detailsController: detailsController,
        imageFile: imageFile,
        items: categories,
        onImagePick: _pickImage,
        showOtherCategory: showOtherCategory,
        titleController: titleController,
      ),
      PlaceDateHour(
        startDate: startDate,
        endDate: endDate,
        onStartDateConfirm: (value) => setState(() => startDate = value),
        onEndDateConfirm: (value) => setState(() => endDate = value),
        placeNameController: placeNameController,
        addressController: addressController,
        onCoordinatesPicked: (coords) => setState(() => placeCoords = coords),
        showEndDate: showEndDate,
        hasMaps: useGoogleMaps,
        onHasMapsChanged: (val) => setState(() => useGoogleMaps = val),
        onShowEndDateChanged: (val) => setState(() => showEndDate = val),
      ),
      OtherInformation(
        specifications: specifications,
        addSpecification: (spec) => setState(() => specifications.add(spec)),
        removeSpecification: (spec) => setState(() => specifications.remove(spec)),
      ),
      TemplateChoice(
        templates: templates,
        selectedTemplate: eventTemplateModel,
        placeNameController: placeNameController,
        endDate: endDate,
        startDate: startDate,
        addressController: addressController,
        detailsController: detailsController,
        imageFile: imageFile,
        templateImageFile: templateImageFile,
        selectedCategory: selectedCategory,
        titleController: titleController,
        onTemplateSelected: (template) => setState(() => eventTemplateModel = template),
        onTemplateImageSelected: (imageFile) => setState(() => templateImageFile = imageFile),
      ),
      Resume(
        titles: const ["Informations générales", "Lieu, date et heure", "Autres informations", "Modèle de design", "Vérifier et confirmer"],
        imageFile: imageFile,
        titleController: titleController,
        selectedCategory: selectedCategory,
        detailsController: detailsController,
        addressController: addressController,
        startDate: startDate,
        endDate: endDate,
        placeNameController: placeNameController,
        eventTemplateModel: eventTemplateModel,
        specifications: specifications,
        goToSection: (page) => setState(() {
          controller.jumpToPage(page);
          step = page;
        }),
      )
    ];

    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: categories.isEmpty || templates.isEmpty
          ? Center(child: CircularProgressIndicator(color: appColors.btnColor))
          : Column(
        children: [
          Row(
            children: List.generate(pages.length, (index) =>
                Expanded(child: Container(height: 5, color: step >= index ? appColors.btnColor : Colors.black12))),
          ),
          commonAppBar(
            title: ["Informations générales", "Lieu, date et heure", "Autres informations", "Modèle de design", "Vérifier et confirmer"][step],
            backArrow: true,
            context: context,
            backClick: () {
              if (step == 0) {
                Navigator.pop(context);
              } else {
                controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
              }
            },
          ),
          Expanded(
            child: PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => step = index),
              itemCount: pages.length,
              itemBuilder: (context, index) => pages[index],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: MediaQuery.of(context).viewInsets.top + 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: GestureDetector(
              onTap: _goToNextPage,
              child: CommonButton(
                loading: loadingNext,
                title: step == pages.length - 1 ? "Créer l'évenement" : Strings.next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
