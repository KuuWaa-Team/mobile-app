import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/common_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:provider/provider.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({Key? key}) : super(key: key);
  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  AppColors appColors = AppColors();
  bool fetched = false;
  EventViewModel eventViewModel = EventViewModel();
  List<CommonModel>? select = [
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
    CommonModel(isSelect: true),
  ];
  UserModel user = UserModel();

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });

      if (!fetched) {
        eventViewModel.listingApi(context);
        setState(() {
          fetched = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: ChangeNotifierProvider<EventViewModel>(
            create: (BuildContext context) => eventViewModel,
            child: Consumer<EventViewModel>(
                builder: (context, value, _) {
                  switch (value.eventsList.status) {
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
                      List<EventModel> events = value.eventsList.data;
                      if (events.isEmpty) {
                        return Container(
                          decoration: BoxDecoration(
                            color: appColors.appLightColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          margin: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.block_outlined, color: appColors.lightColor.withOpacity(.2),),
                              const SizedBox(width: 10,),
                              MyTextView(
                                "Vous n'avez aucun évenement",
                                textAligntNew: TextAlign.start,
                                maxLinesNew: 3,
                                styleNew: MyTextStyle(
                                colorNew: appColors.lightColor.withOpacity(.2),
                                fontWeightNew: FontWeight.w400,
                                size: ResponsiveFlutter.of(context).fontSize(1.8),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: events.length,
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                              vertical: ResponsiveFlutter.of(context).moderateScale(15),
                            ),
                            itemBuilder: (context, index) {
                              EventModel current = events[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(id: current.id!),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveFlutter.of(context).moderateScale(17),
                                    vertical: ResponsiveFlutter.of(context).moderateScale(15),
                                  ),
                                  decoration: BoxDecoration(
                                    color: appColors.appLightColor,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveFlutter.of(context).moderateScale(15),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    MyTextView(
                                                      current.name.toString(),
                                                      textAligntNew: TextAlign.start,
                                                      maxLineWrap: true,
                                                      styleNew: MyTextStyle(
                                                        colorNew: appColors.lightColor,
                                                        fontWeightNew: FontWeight.w600,
                                                        size: ResponsiveFlutter.of(context).fontSize(2),
                                                      ),
                                                    ),
                                                    MyTextView(
                                                      current.category!.name.toString(),
                                                      textAligntNew: TextAlign.start,
                                                      maxLineWrap: true,
                                                      styleNew: MyTextStyle(
                                                        colorNew: Colors.orange.withOpacity(.4),
                                                        fontWeightNew: FontWeight.w400,
                                                        size: ResponsiveFlutter.of(context).fontSize(1.4),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  ImagePath.calender,
                                                  color: appColors.lightColor.withOpacity(.5),
                                                  height: ResponsiveFlutter.of(context).moderateScale(14),
                                                ),
                                                SizedBox(
                                                  width: ResponsiveFlutter.of(context).moderateScale(6),
                                                ),
                                                MyTextView(
                                                  DateFormat('dd MMM, yyyy').format(current.date!),
                                                  textAligntNew: TextAlign.start,
                                                  maxLineWrap: true,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.lightColor.withOpacity(.5),
                                                    fontWeightNew: FontWeight.w500,
                                                    size: ResponsiveFlutter.of(context).fontSize(1.4),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ResponsiveFlutter.of(context).moderateScale(10),
                                                ),
                                                Image.asset(
                                                  ImagePath.time,
                                                  color: appColors.lightColor.withOpacity(.5),
                                                  height: ResponsiveFlutter.of(context).moderateScale(14),
                                                ),
                                                SizedBox(
                                                  width: ResponsiveFlutter.of(context).moderateScale(6),
                                                ),
                                                MyTextView(
                                                  DateFormat('kk:mm').format(current.date!),
                                                  textAligntNew: TextAlign.start,
                                                  maxLineWrap: true,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.lightColor.withOpacity(.5),
                                                    fontWeightNew: FontWeight.w500,
                                                    size: ResponsiveFlutter.of(context).fontSize(1.4),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ResponsiveFlutter.of(context).moderateScale(10),
                                                ),
                                                SizedBox(
                                                  width: ResponsiveFlutter.of(context).moderateScale(6),
                                                ),
                                                if (current.paymentStatus == 'waiting')
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Colors.orange
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                                                  child: MyTextView(
                                                    "En attente du paiement",
                                                    textAligntNew: TextAlign.start,
                                                    maxLineWrap: true,
                                                    styleNew: MyTextStyle(
                                                      colorNew: appColors.lightColor,
                                                      fontWeightNew: FontWeight.w500,
                                                      size: ResponsiveFlutter.of(context).fontSize(1.1),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              height: ResponsiveFlutter.of(context).moderateScale(20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveFlutter.of(context).verticalScale(65),
                        ),
                      ],
                    );
                  }
                }
            )
        ),
      ),
    );
  }
}
