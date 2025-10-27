import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/event/event_specification_model.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/creation/map_picker_view.dart';
import 'package:kuuwaa/screens/events/informations_screen.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class EditOtherInformations extends StatefulWidget {
  EventModel event;

  EditOtherInformations({
    Key? key,
    required this.event
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditOtherInformationsState();
}

class _EditOtherInformationsState extends State<EditOtherInformations> {
  AppColors appColors = AppColors();
  UserModel? user;
  EventViewModel eventViewModel = EventViewModel();
  bool loading = false;
  final TextEditingController _controller = TextEditingController();

  List<EventSpecificationModel> specifications = [];

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    if (widget.event.specifications != null) {
      setState(() {
        specifications.addAll(widget.event.specifications!);
      });
    }
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
                title: "Modifier les specifications",
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MyTextView(
                      "Ce menu est optionnel, vous pouvez le passer",
                      maxLinesNew: 5,
                      styleNew: MyTextStyle(
                        colorNew: Colors.orange,
                        fontWeightNew: FontWeight.w400,
                        size: ResponsiveFlutter.of(context).fontSize(1.4),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(10),
                  ),
                  MyTextView(
                    "Veuillez ajouter d'autres informations rélatives à votre événement (Dress code, cadeau non embalé,...)",
                    maxLinesNew: 5,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor.withOpacity(.7),
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(1.5),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(10),
                  ),
                  Container(
                    height: ResponsiveFlutter.of(context)
                        .verticalScale(40),
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveFlutter.of(context)
                          .moderateScale(6),
                      horizontal: ResponsiveFlutter.of(context)
                          .moderateScale(15),
                    ),
                    margin: EdgeInsets.only(
                        bottom: ResponsiveFlutter.of(context)
                            .moderateScale(10)),
                    decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(
                        ResponsiveFlutter.of(context)
                            .moderateScale(25),
                      ),
                    ),
                    child: commonTestField(
                      context: context,
                      controller: _controller,
                      hintText: "Spécification",
                      keyboardType: TextInputType.text,
                      icon: true,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        setState(() {
                          setState(() => specifications.add(EventSpecificationModel(name: text)));
                          _controller.clear();
                        });
                      }
                    },
                    child: CommonButton(
                      icon: Icons.add,
                      btnColor: appColors.black,
                      title: "Ajouter",
                    ),
                  ),
                  SizedBox(height: ResponsiveFlutter.of(context).verticalScale(20)),
                  ...specifications.map((spec) => Container(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveFlutter.of(context).moderateScale(10),
                      horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: appColors.borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MyTextView(
                            spec.name.toString(),
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.7),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              specifications.remove(spec);
                            });
                          },
                          child: Icon(Icons.close, color: appColors.btnColor, size: 18,),
                        )
                      ],
                    ),
                  )).toList(),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      final data = {
                        "specifications": jsonEncode(specifications.map((e) => e.name).toList()),
                        "step": "OTHER_INFORMATIONS",
                      };
                      await eventViewModel.editEventApi(context, data, widget.event.id!).then((value) {
                        if (value.isNotEmpty) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (r) => InformationsScreen(event: value['event'])));
                        }
                      });
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