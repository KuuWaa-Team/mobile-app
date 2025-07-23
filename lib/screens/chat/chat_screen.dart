import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/all_friends_screen.dart';
import 'package:kuuwaa/screens/friends_screen.dart';
import 'package:kuuwaa/screens/invite_friends_screen.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  EventModel event;
  ChatScreen({Key? key, required this.event}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AppColors appColors = AppColors();
  TabController? tabController;
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: appColors.appMediumColor,
          body: Column(
            children: [
              Container(
                color: appColors.appLightColor,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: ResponsiveFlutter.of(context).moderateScale(10),
                    top: MediaQuery.of(context).viewInsets.top + ResponsiveFlutter.of(context).moderateScale(40),
                    left: ResponsiveFlutter.of(context).moderateScale(20),
                    right: ResponsiveFlutter.of(context).moderateScale(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: appColors.lightColor,
                              size: ResponsiveFlutter.of(context).moderateScale(23),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ResponsiveFlutter.of(context).moderateScale(20),
                      ),
                      Row(
                        children: [
                          MyTextView(
                            Strings.welcomeParty,
                            textAligntNew: TextAlign.start,
                            maxLineWrap: true,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w600,
                              size: ResponsiveFlutter.of(context).fontSize(3.3),
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveFlutter.of(context).moderateScale(15),
                          ),
                          Container(
                            height: ResponsiveFlutter.of(context).moderateScale(30),
                            width: ResponsiveFlutter.of(context).moderateScale(60),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: appColors.blurBtnColor,
                              borderRadius: BorderRadius.circular(
                                ResponsiveFlutter.of(context).moderateScale(20),
                              ),
                            ),
                            child: MyTextView(
                              Strings.dance,
                              textAligntNew: TextAlign.center,
                              maxLineWrap: true,
                              styleNew: MyTextStyle(
                                colorNew: appColors.lightPinkColor,
                                fontWeightNew: FontWeight.w500,
                                size: ResponsiveFlutter.of(context).fontSize(1.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ResponsiveFlutter.of(context).moderateScale(15),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            ImagePath.calender,
                            color: appColors.lightColor,
                            height: ResponsiveFlutter.of(context).moderateScale(15),
                          ),
                          SizedBox(
                            width: ResponsiveFlutter.of(context).moderateScale(6),
                          ),
                          MyTextView(
                            Strings.dummyText22,
                            textAligntNew: TextAlign.start,
                            maxLineWrap: true,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w500,
                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveFlutter.of(context).moderateScale(10),
                          ),
                          Image.asset(
                            ImagePath.time,
                            color: appColors.lightColor,
                            height: ResponsiveFlutter.of(context).moderateScale(15),
                          ),
                          SizedBox(
                            width: ResponsiveFlutter.of(context).moderateScale(6),
                          ),
                          MyTextView(
                            Strings.dummyText23,
                            textAligntNew: TextAlign.start,
                            maxLineWrap: true,
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.w500,
                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ResponsiveFlutter.of(context).moderateScale(15),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      AllFriendsScreen(),
                      FriendsScreen(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
