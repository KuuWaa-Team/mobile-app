import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/events/create_event_screen.dart';
import 'package:kuuwaa/screens/events/my_events_screen.dart';
import 'package:kuuwaa/screens/notification_screen.dart';
import 'package:kuuwaa/screens/settings/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/screens/wallet_screen.dart';
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
      child: RefreshIndicator(
        color: appColors.btnColor,
        onRefresh: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomBarScreen(),
            ),
              (route) => false
          );
        },
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
                      children: [
                        MyTextView(
                          "Salut,\n" + user.displayName.toString(),
                          textAligntNew: TextAlign.start,
                          maxLineWrap: true,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w600,
                            size: ResponsiveFlutter.of(context).fontSize(2.5),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomBarScreen(isFrom: "Wallet",),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: appColors.grey.withOpacity(.1)
                            ),
                            child: Row(
                              children: [
                                Image.asset("assets/icon/coins.png", width: 25,),
                                const SizedBox(width: 5,),
                                MyTextView(
                                  user.credits == null ? '0' : user.credits.toString(),
                                  textAligntNew: TextAlign.start,
                                  maxLineWrap: true,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w600,
                                    size: ResponsiveFlutter.of(context).fontSize(2),
                                  ),
                                ),
                              ]
                            )
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
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
                          ),
                          color: appColors.btnColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add, color: Colors.white, size: 20),
                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(5)),
                            MyTextView(
                              Strings.createEvent,
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

                    GestureDetector(
                      onTap: () => _showJoinEventModal(context),
                      child: Container(
                        height: ResponsiveFlutter.of(context).moderateScale(40),
                        margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            ResponsiveFlutter.of(context).moderateScale(25),
                          ),
                          color: appColors.darkGreyText,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock_open_rounded, color: Colors.white, size: 20),
                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(5)),
                            MyTextView(
                              "Rejoindre un évènement",
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
                  child: const MyEventsScreen(),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
  void _showJoinEventModal(BuildContext context) {
    String code = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: appColors.appMediumColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: MyTextView(
                      "Rejoindre un évènement",
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.btnColor,
                        fontWeightNew: FontWeight.w700,
                        size: ResponsiveFlutter.of(context).fontSize(2.4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyTextView(
                    "Si une personne vous a ajouté comme gestionnaire de son évènement, vous avez sûrement reçu un code à 6 chiffres. Entrez ce code ci-dessous.",
                    maxLineWrap: true,
                    textAligntNew: TextAlign.left,
                    styleNew: MyTextStyle(
                      colorNew: appColors.black.withOpacity(0.85),
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(1.5),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: PinCodeTextField(
                  length: 6,

                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 45,
                    fieldWidth: 45,
                    activeColor: appColors.btnColor,
                    inactiveColor: Colors.grey,
                    selectedColor: appColors.btnColor.withOpacity(0.7),
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: false,
                  onChanged: (value) {
                    code = value.toUpperCase();
                  },
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  appContext: context,

                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: MyTextView(
                  "Si vous ne l’avez pas reçu, veuillez contacter la personne qui vous invite.",
                  maxLineWrap: true,
                  textAligntNew: TextAlign.left,
                  styleNew: MyTextStyle(
                    colorNew: appColors.black.withOpacity(0.7),
                    fontWeightNew: FontWeight.w400,
                    size: ResponsiveFlutter.of(context).fontSize(1.4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (code.length != 6) {
                    Utils.flushBarErrorMessage("Veuillez entrer un code valide à 6 chiffres", context);
                    return;
                  }

                  Navigator.pop(context);
                  // TODO: Appeler l’API pour rejoindre l’événement avec ce code
                  Utils.toastMessage("Code reçu : $code");
                },
                child: CommonButton(title: "Rejoindre"),
              ),
            ],
          ),
        );
      },
    );
  }


}
