import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/address/address_model.dart';
import 'package:kuuwaa/model/address/country_model.dart';
import 'package:kuuwaa/model/address/province_model.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  int id;
  EditEventScreen({required this.id, Key? key}) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  AppColors appColors = AppColors();
  String? selectedDate = "Select date";
  String? selectedTime = "Select time";
  bool loading = false;
  bool loaded = false;

  List<Map<String, dynamic>> provinces = [
    {
      "name": "Kinshasa",
      "id": 1
    },
    {
      "name": "Bas-Uele",
      "id": 2
    },
    {
      "name": "Équateur",
      "id": 3
    },
    {
      "name": "Haut-Katanga",
      "id": 4
    },
    {
      "name": "Haut-Lomami",
      "id": 5
    },
    {
      "name": "Haut-Uele",
      "id": 6
    },
    {
      "name": "Ituri",
      "id": 7
    },
    {
      "name": "Kasaï",
      "id": 8
    },
    {
      "name": " Kasaï central",
      "id": 9
    },
    {
      "name": "Kasaï oriental",
      "id": 10
    },
    {
      "name": "Kongo-Central",
      "id": 11
    },
    {
      "name": "Kwango",
      "id": 12
    },
    {
      "name": "Kwilu",
      "id": 13
    },
    {
      "name": "Lomami",
      "id": 14
    },
    {
      "name": "Lualaba",
      "id": 15
    },
    {
      "name": "Mai-Ndombe",
      "id": 16
    },
    {
      "name": "Maniema",
      "id": 17
    },
    {
      "name": "Mongala",
      "id": 18
    },
    {
      "name": "Nord-Kivu",
      "id": 19
    },
    {
      "name": "Nord-Ubangi",
      "id": 20
    },
    {
      "name": "Sankuru",
      "id": 21
    },
    {
      "name": "Sud-Kivu",
      "id": 22
    },
    {
      "name": "Sud-Ubangi",
      "id": 23
    },
    {
      "name": "Tanganyika",
      "id": 24
    },
    {
      "name": "Tshopo",
      "id": 25
    },
    {
      "name": "Tshuapa",
      "id": 26
    },
  ];
  Map<String, dynamic> selectedProvince = {
    "name": "",
    "id": null
  };

  double total = 0;

  bool showOtherCategory = false;

  TimeOfDay time = TimeOfDay.now();

  bool addingPrice = false;

  DateTime? date;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _refController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  final TextEditingController _priceCategoryController = TextEditingController();
  final TextEditingController _priceValueController = TextEditingController();

  Object dropDownValue = EventCategoryModel(
      id: 0,
      name: "Catégorie"
  );
  List items = [];

  bool paid = false;

  List<Map<String, dynamic>> prices = [];
  List<Widget> pricesList = [];

  EventViewModel eventViewModel = EventViewModel();

  @override
  void initState() {
    eventViewModel.getEventDetailApi(context, widget.id);
    List<dynamic> fetchedCategories = [dropDownValue];
    eventViewModel.getCategories(context, paid == true).then((value) {
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

  @override
  Widget build(BuildContext context) {
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
              title: "Modifier l'évenement",
              backArrow: true,
              context: context,
            ),
            Expanded(
              child: ChangeNotifierProvider<EventViewModel>(
                  create: (BuildContext context) => eventViewModel,
                  child: Consumer<EventViewModel>(
                      builder: (context, value, _) {
                        switch (value.event.status) {
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
                            EventModel event = value.event.data!;
                            paid = event.paidEvent == true;
                            if (!loaded) {
                              loaded = true;
                              _titleController.text = event.name!;
                              date = DateTime.parse(event.date.toString());
                              _detailsController.text = event.details.toString();
                              _numberController.text = event.address!.number.toString();
                              _streetController.text = event.address!.street.toString();
                              if (event.address!.ref != null && event.address!.ref != "null") {
                                _refController.text = event.address!.ref.toString();
                              }
                              selectedProvince["name"] = event.address!.province!.name.toString();
                              selectedProvince["id"] = event.address!.province!.id.toString();
                              for (var element in items) {
                                if (element.name == event.category!.name!) {
                                  dropDownValue = element;
                                }
                              }
                            }
                            return Column(
                              children: [
                                Expanded(
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(
                                      vertical: ResponsiveFlutter.of(context).moderateScale(15),
                                      horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                    ),
                                    children: [
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
                                              dropDownValue = value!;
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
                                                                          return SingleChildScrollView(
                                                                            child: Padding(
                                                                              padding: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top + 60, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                                                                              child: Column(
                                                                                children: [
                                                                                  MyTextView(
                                                                                    "Choisissez la province",
                                                                                    textAligntNew: TextAlign.center,
                                                                                    styleNew: MyTextStyle(
                                                                                      colorNew: appColors.lightColor,
                                                                                      fontWeightNew: FontWeight.w400,
                                                                                      size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 15,),
                                                                                  ListView.builder(
                                                                                      shrinkWrap: true,
                                                                                      itemCount: provinces.length,
                                                                                      itemBuilder: (context, index) {
                                                                                        return GestureDetector(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              selectedProvince = provinces[index];
                                                                                              Navigator.pop(context);
                                                                                            });
                                                                                          },
                                                                                          child: Container(
                                                                                            height: ResponsiveFlutter.of(context).verticalScale(40),
                                                                                            padding: EdgeInsets.symmetric(
                                                                                              vertical: ResponsiveFlutter.of(context).moderateScale(6),
                                                                                              horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                                                                                            ),
                                                                                            margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(2)),
                                                                                            decoration: BoxDecoration(
                                                                                              color: selectedProvince["id"] == provinces[index]["id"] ? appColors.lightPinkColor.withOpacity(.1) :  appColors.appLightColor,
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  MyTextView(
                                                                                                    provinces[index]["name"],
                                                                                                    textAligntNew: TextAlign.center,
                                                                                                    styleNew: MyTextStyle(
                                                                                                      colorNew: appColors.lightColor,
                                                                                                      fontWeightNew: FontWeight.w600,
                                                                                                      size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                    );
                                                                  },
                                                                  child: Container(
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
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          MyTextView(
                                                                            selectedProvince["id"] == null ? "Province" : selectedProvince["name"],
                                                                            textAligntNew: TextAlign.center,
                                                                            styleNew: MyTextStyle(
                                                                              colorNew: appColors.lightColor,
                                                                              fontWeightNew: FontWeight.w600,
                                                                              size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                            ),
                                                                          ),
                                                                          Icon(CupertinoIcons.chevron_down, color: appColors.lightColor, size: 15,)
                                                                        ],
                                                                      ),
                                                                    ),
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
                                                                    controller: _streetController,
                                                                    hintText: "Rue",
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
                                                                    controller: _numberController,
                                                                    hintText: "Numéro",
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
                                                                    hintText: "Réference",
                                                                    keyboardType: TextInputType.text,
                                                                    icon: true,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {});
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
                                              MyTextView(
                                                _numberController.text + ", " + _streetController.text + ". " +  selectedProvince["name"],
                                                textAligntNew: TextAlign.center,
                                                styleNew: MyTextStyle(
                                                  colorNew: appColors.lightColor,
                                                  fontWeightNew: FontWeight.w400,
                                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
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
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                GestureDetector(
                                  onTap: () async {
                                    event.name = _titleController.text;
                                    event.category = dropDownValue as EventCategoryModel;
                                    event.details = _detailsController.text;
                                    event.date = date;
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
                                    eventViewModel.editEventApi(context, event, event.id!);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                                    child: CommonButton(
                                      loading: eventViewModel.loading,
                                      title: "Enrégistrer",
                                    ),
                                  )
                                ),
                              ],
                            );
                        }
                      }
                  )
              ),
            ),
          ],
        )
      ),
    );
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
