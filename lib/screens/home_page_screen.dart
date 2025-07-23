import 'package:confetti/confetti.dart';
import 'package:kuuwaa/view_model/eventAdmin/event_admin_view_model.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/events/create_event_screen.dart';
import 'package:kuuwaa/screens/events/my_events_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  bool invitationAccepted = false;
  HomeScreen({Key? key, this.invitationAccepted = false}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppColors appColors = AppColors();
  UserModel user = UserModel();

  bool loadingAccept = false;

  TabController? tabController;
  int? tab = 0;

  EventViewModel eventViewModel = EventViewModel();
  EventAdminViewModel adminViewModel = EventAdminViewModel();

  bool initScreenHome = false;

  @override
  void initState() {
    SharedPreferences preferences;
    SharedPreferences.getInstance().then((value) async {
      preferences = value;
      initScreenHome = preferences.getBool('initScreenHome') == true;
      if (initScreenHome != true) {
        await preferences.setBool('initScreenHome', true);
      }
      if (!initScreenHome) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _showFirstTimeInfoDialog();
        });
        super.initState();
      }
    });
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    if (widget.invitationAccepted) {
      Future.delayed(Duration.zero, () {
        _showInvitationAcceptedDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
      child: SafeArea(
        top: false,
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
        )
      ),
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
                onTap: loadingAccept ? null : () async {
                  setState(() {
                    loadingAccept = true;
                  });
                  if (code.length != 6) {
                    Utils.flushBarErrorMessage("Veuillez entrer un code valide à 6 chiffres", context);
                    return;
                  }

                  await adminViewModel.acceptInvitationApi(context, {
                    'userId' : user.id,
                    'invitationCode' : code
                  });
                  setState(() {
                    loadingAccept = false;
                  });
                },
                child: CommonButton(title: "Rejoindre", loading: loadingAccept,),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInvitationAcceptedDialog() {
    final ConfettiController _confettiController =
    ConfettiController(duration: const Duration(seconds: 5));

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        _confettiController.play();
        return Stack(
          alignment: Alignment.center,
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: appColors.appLightColor,
              title: Column(
                children: [
                  const Icon(Icons.celebration, color: Colors.orange, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    'Invitation acceptée !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: appColors.btnColor,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Vous êtes désormais gestionnaire de l'évènement.\nIl apparaîtra dans votre liste.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appColors.darkGreyText,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _confettiController.stop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      child: Text("Compris", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.blue,
                  Colors.red,
                  Colors.yellow,
                  Colors.green,
                  Colors.purple,
                ],
              ),
            ),
          ],
        );
      },
    ).then((_) {
      _confettiController.dispose();
    });
  }

  void _showFirstTimeInfoDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColors.appLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          titlePadding: const EdgeInsets.only(top: 20),
          title: Column(
            children: [
              Icon(Icons.info_outline_rounded, size: 30, color: appColors.appMediumColorDark),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MyTextView(
                "Bienvenue sur KuuWaa",
                  textAligntNew: TextAlign.center,
                  maxLinesNew: 5,
                  styleNew: MyTextStyle(
                    colorNew: appColors.lightColor,
                    fontWeightNew: FontWeight.w700,
                    size: ResponsiveFlutter.of(context).fontSize(3),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogOption(
                icon: Icons.event,
                title: "Créer un évènement",
                description:
                "Lancez la création de votre évènement et commencez à envoyer des invitations électroniques personnalisées.",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateEventScreen()),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildDialogOption(
                icon: Icons.lock_open,
                title: "Rejoindre un évènement",
                description:
                "Utilisez un code d’invitation pour rejoindre un évènement en tant que co-gestionnaire.",
                onTap: () {
                  Navigator.pop(context);
                  _showJoinEventModal(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Compris",
                style: TextStyle(color: appColors.btnColor, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogOption({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: appColors.btnColor, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextView(
                    title,
                    textAligntNew: TextAlign.left,
                    maxLinesNew: 5,
                    styleNew: MyTextStyle(
                      colorNew: appColors.appMediumColorDark,
                      fontWeightNew: FontWeight.w700,
                      size: ResponsiveFlutter.of(context).fontSize(1.9),
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextView(
                    description,
                    textAligntNew: TextAlign.left,
                    maxLinesNew: 15,
                    styleNew: MyTextStyle(
                      colorNew: appColors.appMediumColorDark.withOpacity(.6),
                      fontWeightNew: FontWeight.w700,
                      size: ResponsiveFlutter.of(context).fontSize(1.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: appColors.btnColor, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: appColors.btnColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: appColors.darkGreyText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
