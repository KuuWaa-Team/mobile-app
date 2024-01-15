import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/constants.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/invitations/my_invitations_screen.dart';
import 'package:kuuwaa/screens/home_page_screen.dart';
import 'package:kuuwaa/screens/setting_screen.dart';
import 'package:kuuwaa/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomBarScreen extends StatefulWidget {
  final String isFrom;
  const BottomBarScreen({Key? key, this.isFrom = ""}) : super(key: key);

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  AppColors appColors = AppColors();
  ImagePath imagePath = ImagePath();
  Widget? tabBar;

  bool? home = true;
  bool? favorites = false;
  bool? create = false;
  bool? wallet = false;
  bool? setting = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFrom == "Setting") {
      tabBar = const SettingScreen();
      home = false;
      favorites = false;
      create = false;
      wallet = false;
      setting = true;
      setState(() {});
    } else {
      tabBar = const HomeScreen();
      home = true;
      favorites = false;
      create = false;
      wallet = false;
      setting = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Constants.darkTheme ? Brightness.light : Brightness.dark,
        statusBarBrightness: Constants.darkTheme ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: appColors.lightColor,
        // systemNavigationBarDividerColor: appColors.appDarkColor,
        systemNavigationBarIconBrightness: Constants.darkTheme ? Brightness.light : Brightness.dark,
      ),
    );
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            tabBar!,
            Stack(
              children: [
                Container(
                  height: ResponsiveFlutter.of(context).verticalScale(72),
                  margin: EdgeInsets.only(top: ResponsiveFlutter.of(context).moderateScale(10)),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage(imagePath.bottomBar),
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: ResponsiveFlutter.of(context).moderateScale(20),
                    left: ResponsiveFlutter.of(context).moderateScale(20),
                  ),
                  child: SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(65),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tabBar = const HomeScreen();
                              home = true;
                              favorites = false;
                              create = false;
                              wallet = false;
                              setting = false;
                            });
                          },
                          child: Container(
                            height: ResponsiveFlutter.of(context).verticalScale(40),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(home! ? Icons.event_note_rounded : Icons.event_note_outlined, color: home! ? appColors.btnColor : appColors.iconColor.withOpacity(.5), size: 25,),
                                const SizedBox(height: 8,),
                                Text("Evenements", style: TextStyle(
                                  color: appColors.lightColor,
                                  fontSize: 9
                                ),)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tabBar = const FavoritesScreen();
                              home = false;
                              favorites = true;
                              create = false;
                              wallet = false;
                              setting = false;
                            });
                          },
                          child: Container(
                            height: ResponsiveFlutter.of(context).verticalScale(40),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(favorites! ? Icons.message : Icons.message_outlined, color: favorites! ? appColors.btnColor : appColors.iconColor.withOpacity(.5), size: 25,),
                                const SizedBox(height: 8,),
                                Text("Invitations", style: TextStyle(
                                    color: appColors.lightColor,
                                    fontSize: 9
                                ),)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tabBar = const WalletScreen();
                              home = false;
                              favorites = false;
                              create = false;
                              wallet = true;
                              setting = false;
                            });
                          },
                          child: Container(
                            height: ResponsiveFlutter.of(context).verticalScale(40),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(wallet! ? Icons.card_membership : Icons.card_membership_outlined, color: wallet! ? appColors.btnColor : appColors.iconColor.withOpacity(.5), size: 25,),
                                const SizedBox(height: 8,),
                                Text("Tickets", style: TextStyle(
                                    color: appColors.lightColor,
                                    fontSize: 9
                                ),)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tabBar = const SettingScreen();
                              home = false;
                              favorites = false;
                              create = false;
                              wallet = false;
                              setting = true;
                            });
                          },
                          child: Container(
                            height: ResponsiveFlutter.of(context).verticalScale(40),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(setting! ? Icons.settings : Icons.settings_outlined, color: setting! ? appColors.btnColor : appColors.iconColor.withOpacity(.5), size: 25,),
                                const SizedBox(height: 8,),
                                Text("Paramètres", style: TextStyle(
                                    color: appColors.lightColor,
                                    fontSize: 9
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
