import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/data/response/status.dart';
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

  double total = 0;

  bool showOtherCategory = false;

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
                              _addressController.text = event.address.toString();
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
                                      if (event.paidEvent == true)
                                      SizedBox(
                                        height: ResponsiveFlutter.of(context).verticalScale(10),
                                      ),
                                      if (paid == true)
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
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                GestureDetector(
                                    onTap: () async {
                                      event.name = _titleController.text;
                                      event.category = dropDownValue as EventCategoryModel;
                                      event.address = _addressController.text;
                                      event.details = _detailsController.text;
                                      event.date = date;
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
