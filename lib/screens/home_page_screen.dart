import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/events/create_event_screen.dart';
import 'package:kuuwaa/screens/events/my_events_screen.dart';
import 'package:kuuwaa/screens/notification_screen.dart';
import 'package:kuuwaa/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppColors appColors = AppColors();
  UserModel user = UserModel();

  TabController? tabController;
  int? tab = 0;

  EventViewModel eventViewModel = EventViewModel();

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + ResponsiveFlutter.of(context).moderateScale(10),
                right: ResponsiveFlutter.of(context).moderateScale(20),
                left: ResponsiveFlutter.of(context).moderateScale(20),
                bottom: ResponsiveFlutter.of(context).moderateScale(10),
              ),
              decoration: BoxDecoration(
                color: appColors.appDarkColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(ResponsiveFlutter.of(context).moderateScale(30)),
                  bottomRight: Radius.circular(ResponsiveFlutter.of(context).moderateScale(30)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImagePath.logo,
                        height: ResponsiveFlutter.of(context).moderateScale(15),
                      ),
                      SizedBox(width: ResponsiveFlutter.of(context).moderateScale(8)),
                      MyTextView(
                        "KuuWaa",
                        textAligntNew: TextAlign.start,
                        maxLineWrap: true,
                        styleNew: MyTextStyle(
                          colorNew: appColors.lightColor,
                          fontWeightNew: FontWeight.w700,
                          size: ResponsiveFlutter.of(context).fontSize(2),
                        ),
                      ),
                      const Spacer(),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const NotificationScreen(),
                      //       ),
                      //     );
                      //   },
                      //   child: SizedBox(
                      //     height: ResponsiveFlutter.of(context).moderateScale(22),
                      //     width: ResponsiveFlutter.of(context).moderateScale(25),
                      //     child: Stack(
                      //       children: [
                      //         Image.asset(
                      //           ImagePath.bell,
                      //           height: ResponsiveFlutter.of(context).moderateScale(22),
                      //           color: appColors.lightColor,
                      //         ),
                      //         Align(
                      //           alignment: Alignment.topRight,
                      //           child: Container(
                      //             height: ResponsiveFlutter.of(context).moderateScale(15),
                      //             width: ResponsiveFlutter.of(context).moderateScale(15),
                      //             alignment: Alignment.center,
                      //             decoration: BoxDecoration(
                      //               color: appColors.btnColor,
                      //               shape: BoxShape.circle,
                      //               border: Border.all(
                      //                 color: appColors.appDarkColor,
                      //                 width: ResponsiveFlutter.of(context).moderateScale(2.5),
                      //               ),
                      //             ),
                      //             child: MyTextView(
                      //               "2",
                      //               textAligntNew: TextAlign.center,
                      //               maxLineWrap: true,
                      //               styleNew: MyTextStyle(
                      //                 colorNew: appColors.lightColor,
                      //                 fontWeightNew: FontWeight.w500,
                      //                 textHeight: 1,
                      //                 size: ResponsiveFlutter.of(context).fontSize(1),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: ResponsiveFlutter.of(context).moderateScale(15),
                      // ),
                      // GestureDetector(
                      //     onTap: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => const ProfileScreen(),
                      //         ),
                      //       );
                      //     },
                      //     child: SizedBox(
                      //       height: ResponsiveFlutter.of(context).moderateScale(28),
                      //       width: ResponsiveFlutter.of(context).moderateScale(28),
                      //       child: Icon(
                      //         Icons.search,
                      //         size: ResponsiveFlutter.of(context).moderateScale(28),
                      //         color: appColors.lightColor,
                      //       ),
                      //     )
                      // ),
                      // SizedBox(
                      //   width: ResponsiveFlutter.of(context).moderateScale(15),
                      // ),
                      GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const ProfileScreen(),
                            //   ),
                            // );
                          },
                          child: SizedBox(
                            height: ResponsiveFlutter.of(context).moderateScale(28),
                            width: ResponsiveFlutter.of(context).moderateScale(28),
                            child: Icon(
                              Icons.person,
                              size: ResponsiveFlutter.of(context).moderateScale(28),
                              color: appColors.lightColor,
                            ),
                          )
                      ),
                      SizedBox(
                        width: ResponsiveFlutter.of(context).moderateScale(15),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomBarScreen(),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: ResponsiveFlutter.of(context).moderateScale(28),
                            width: ResponsiveFlutter.of(context).moderateScale(28),
                            child: Icon(
                              Icons.refresh,
                              size: ResponsiveFlutter.of(context).moderateScale(28),
                              color: appColors.lightColor,
                            ),
                          )
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  MyTextView(
                    "Salut,\n" + (user.firstname == null ? "" : user.firstname!) + " " + (user.lastname == null ? "" : user.lastname!),
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w600,
                      size: ResponsiveFlutter.of(context).fontSize(2.5),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  // CupertinoSearchTextField(
                  //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  //   style: TextStyle(
                  //       color: appColors.lightColor
                  //   ),
                  //   placeholder: "Rechercher",
                  //   onChanged: (String value) {
                  //   },
                  //   onSubmitted: (String value) {
                  //   },
                  // ),
                  // const SizedBox(height: 15,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateEventScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: ResponsiveFlutter.of(context).moderateScale(40),
                      margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ResponsiveFlutter.of(context).moderateScale(25),
                        ), // Creates border
                        color: appColors.btnColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 20,),
                          SizedBox(width: ResponsiveFlutter.of(context).moderateScale(5),),
                          MyTextView(
                            Strings.createEvent,
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
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: MyEventsScreen(),
              ),
            ),
          ],
        ),
      )
    );
  }
}
