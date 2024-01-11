import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/ticket_listing_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  AppColors appColors = AppColors();
  TabController? tabController;
  int? tab = 0;
  bool? like = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              title: "Tickets",
              backArrow: false,
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: appColors.appMediumColor,
                  body: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: appColors.appLightColor,
                            borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).moderateScale(25),)
                          ),
                          child: TabBar(
                            controller: tabController,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                ResponsiveFlutter.of(context).moderateScale(25),
                              ), // Creates border
                              color: appColors.btnColor,
                            ),
                            onTap: (value) {
                              tab = value;
                              setState(() {});
                              debugPrint("value ------>> $value");
                            },
                            tabs: [
                              Container(
                                height: ResponsiveFlutter.of(context).moderateScale(35),
                                alignment: Alignment.center,
                                child: MyTextView(
                                  "Events Publics",
                                  textAligntNew: TextAlign.start,
                                  maxLineWrap: true,
                                  styleNew: MyTextStyle(
                                    colorNew: tab == 0 ? appColors.white : appColors.darkGreyText,
                                    fontWeightNew: FontWeight.w600,
                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                  ),
                                ),
                              ),
                              Container(
                                height: ResponsiveFlutter.of(context).moderateScale(35),
                                alignment: Alignment.center,
                                child: MyTextView(
                                  "Mes tickets",
                                  textAligntNew: TextAlign.start,
                                  maxLineWrap: true,
                                  styleNew: MyTextStyle(
                                    colorNew: tab == 1 ? appColors.white : appColors.darkGreyText,
                                    fontWeightNew: FontWeight.w600,
                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left : 20,
                          right : 20,
                          top : 10,
                          bottom : 10,
                        ),
                        child: CupertinoSearchTextField(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          style: TextStyle(
                              color: appColors.lightColor
                          ),
                          placeholder: "Rechercher",
                          onChanged: (String value) {
                          },
                          onSubmitted: (String value) {
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: TabBarView(
                            controller: tabController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              TicketListingScreen(),
                              TicketListingScreen(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
