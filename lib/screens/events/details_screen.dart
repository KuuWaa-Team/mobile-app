import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/screens/admin/admin_list_screen.dart';
import 'package:kuuwaa/screens/beverage/beverage_list_screen.dart';
import 'package:kuuwaa/screens/book/book_screen.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/events/check/check_screen.dart';
import 'package:kuuwaa/screens/events/informations_screen.dart';
import 'package:kuuwaa/screens/game/game_screen.dart';
import 'package:kuuwaa/screens/music/music_list_screen.dart';
import 'package:kuuwaa/screens/table/table_list_screen.dart';
import 'package:kuuwaa/shimmer/event_owner_detail_shimmer.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:provider/provider.dart';

import '../invitations/invitations_list_screen.dart';

class DetailsScreen extends StatefulWidget {
  int id;

  DetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  AppColors appColors = AppColors();
  EventViewModel eventViewModel = EventViewModel();

  final ImagePicker picker = ImagePicker();
  XFile? image;
  File? imageFile;
  bool loadingImage = false;
  bool loadingDelete = false;
  UserModel? user;

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      if (value != null) {
        setState(() {
          user = value;
        });
        eventViewModel.getEventDetailApi(context, widget.id, user!.id!);
      }
    });
    super.initState();
  }

  void showUnlockDialog(int price, String key) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.lock_circle_fill, size: 60, color: appColors.btnColor),
              const SizedBox(height: 15),
              Text(
                "Fonctionnalité verrouillée",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: appColors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Cette fonctionnalité nécessite un déverrouillage pour y accéder.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: appColors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icon/coins.png", width: 25,),
                  const SizedBox(width: 5),
                  Text(
                    "$price pièces",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: appColors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (key == "TABLE") {
                    eventViewModel.openTables(context, widget.id).then((value) {
                      if (value) {
                        Navigator.push(context, CupertinoPageRoute(
                          builder: (context) => DetailsScreen(id: widget.id),
                        ));
                      }
                    });
                  } else if (key == "BEVERAGE") {
                    eventViewModel.openBeverage(context, widget.id).then((value) {
                      if (value) {
                        Navigator.push(context, CupertinoPageRoute(
                          builder: (context) => DetailsScreen(id: widget.id),
                        ));
                      }
                    });
                  } else if (key == "BOOK") {
                    eventViewModel.openBook(context, widget.id).then((value) {
                      if (value) {
                        Navigator.push(context, CupertinoPageRoute(
                          builder: (context) => DetailsScreen(id: widget.id),
                        ));
                      }
                    });
                  } else if (key == "MUSIC") {
                    eventViewModel.openMusic(context, widget.id).then((value) {
                      if (value) {
                        Navigator.push(context, CupertinoPageRoute(
                          builder: (context) => DetailsScreen(id: widget.id),
                        ));
                      }
                    });
                  } else if (key == "GAME") {
                    eventViewModel.openGame(context, widget.id).then((value) {
                      if (value) {
                        Navigator.push(context, CupertinoPageRoute(
                          builder: (context) => DetailsScreen(id: widget.id),
                        ));
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.btnColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(CupertinoIcons.lock_open_fill, color: Colors.white),
                label: const Text(
                  "Déverrouiller",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ChangeNotifierProvider<EventViewModel>(
              create: (BuildContext context) => eventViewModel,
              child: Consumer<EventViewModel>(
                  builder: (context, value, _) {
                    switch (value.event.status) {
                      case Status.LOADING:
                        return const EventOwnerDetailShimmer();
                      case Status.ERROR:
                        return Center(
                          child: Text(value.event.message.toString()),
                        );
                      case Status.COMPLETED:
                        EventModel event = value.event.data!;

                        List<String> roles = [];
                        if (event.shared == true && event.adminRoles != null) {
                          roles = event.adminRoles!.split(',');
                        }
                        return Stack(
                          children: [
                            imageFile == null || !loadingImage?
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.32,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(AppUrl.domainName + event.imagePath.toString(), fit: BoxFit.cover,)
                            )
                            : Stack(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.32,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.file(imageFile!, fit: BoxFit.cover),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.32,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.7),
                                    // borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: CircularProgressIndicator(color: Colors.white.withOpacity(.7), strokeWidth: 2),
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.height * 0.25,
                                        left: ResponsiveFlutter.of(context).moderateScale(20),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const BottomBarScreen(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: appColors.appDarkColor,
                                            borderRadius: BorderRadius.circular(40),
                                              boxShadow: [Utils.customShadow()]
                                          ),
                                          child: Center(
                                            child: Icon(
                                              CupertinoIcons.back,
                                              color: appColors.lightColor,
                                              size: ResponsiveFlutter.of(context).moderateScale(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (user != null) {
                                          setState(() {
                                            eventViewModel.getEventDetailApi(context, widget.id, user!.id!);
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height * 0.25,
                                          right: ResponsiveFlutter.of(context).moderateScale(10),
                                          left: ResponsiveFlutter.of(context).moderateScale(10),
                                        ),
                                        decoration: BoxDecoration(
                                          color: appColors.appDarkColor,
                                          borderRadius: BorderRadius.circular(40),
                                            boxShadow: [Utils.customShadow()]
                                        ),
                                        child: Center(
                                          child: Icon(
                                            CupertinoIcons.refresh,
                                            color: appColors.lightColor,
                                            size: ResponsiveFlutter.of(context).moderateScale(15),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (event.shared != true)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            imagePick(event);
                                          });
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          margin: EdgeInsets.only(
                                            top: MediaQuery.of(context).size.height * 0.25,
                                          ),
                                          decoration: BoxDecoration(
                                            color: appColors.appDarkColor,
                                            borderRadius: BorderRadius.circular(40),
                                            boxShadow: [Utils.customShadow()]
                                          ),
                                          child: Center(
                                            child: Icon(
                                              CupertinoIcons.photo,
                                              color: appColors.lightColor,
                                              size: ResponsiveFlutter.of(context).moderateScale(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (event.shared != true)
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                                            child:
                                                            Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                SizedBox(
                                                                  height: 60,
                                                                  width: 60,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      CupertinoIcons.question_circle,
                                                                      color: appColors.btnColor,
                                                                      size: 50,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                const Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text("Êtes vous sûr de vouloir supprimer cet évenement ?", style: TextStyle(
                                                                        fontWeight: FontWeight.bold
                                                                    ), textAlign: TextAlign.center,),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 20,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        if (!loadingDelete) {
                                                                          setState(() {
                                                                            loadingDelete = true;
                                                                          });
                                                                          EventViewModel eventViewModel4 = EventViewModel();
                                                                          eventViewModel4.deleteEventApi(context, event);
                                                                        }
                                                                      },
                                                                      child: CommonButton(
                                                                        loading: loadingDelete,
                                                                        title: "Supprimer",
                                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      ),
                                                                    ),
                                                                    if (!loadingDelete)
                                                                    const SizedBox(width: 5,),
                                                                    if (!loadingDelete)
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: CommonButton(
                                                                        loading: false,
                                                                        btnColor: appColors.appLightColor,
                                                                        title: "Annuler",
                                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          margin: EdgeInsets.only(
                                            top: MediaQuery.of(context).size.height * 0.25,
                                            left: ResponsiveFlutter.of(context).moderateScale(10),
                                          ),
                                          decoration: BoxDecoration(
                                            color: appColors.appDarkColor,
                                            borderRadius: BorderRadius.circular(40),
                                            boxShadow: [Utils.customShadow()]
                                          ),
                                          child: Center(
                                            child: Icon(
                                              CupertinoIcons.trash_fill,
                                              color: appColors.lightColor,
                                              size: ResponsiveFlutter.of(context).moderateScale(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.22),
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top + ResponsiveFlutter.of(context).moderateScale(50),
                                // bottom: MediaQuery.of(context).padding.bottom + ResponsiveFlutter.of(context).moderateScale(20),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                MyTextView(
                                                  event.title.toString(),
                                                  textAligntNew: TextAlign.start,
                                                  maxLinesNew: 3,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.lightColor,
                                                    fontWeightNew: FontWeight.w600,
                                                    size: ResponsiveFlutter.of(context).fontSize(2.1),
                                                  ),
                                                ),
                                                MyTextView(
                                                  event.category!.name.toString(),
                                                  textAligntNew: TextAlign.start,
                                                  maxLineWrap: true,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.btnColor,
                                                    fontWeightNew: FontWeight.w500,
                                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                              ],
                                            ),
                                          ),
                                          if (event.shared == true)
                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: appColors.btnColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(30),
                                                border: Border.all(color: appColors.btnColor.withOpacity(0.3), width: 3),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.link, size: 12, color: appColors.btnColor),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "Invité",
                                                    style: TextStyle(
                                                      color: appColors.btnColor,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                                    GestureDetector(
                                      onTap: () {
                                        if (event.invitationsCount == null || event.invitationsCount! < 1) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                                            child:
                                                            Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                SizedBox(
                                                                  height: 60,
                                                                  width: 60,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.lightbulb_outline,
                                                                      color: appColors.btnColor,
                                                                      size: 50,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                const Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text("Aucune invitation n'a encore été enrégistrée pour cet évenement.", style: TextStyle(
                                                                        fontWeight: FontWeight.bold
                                                                    ), textAlign: TextAlign.center,),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 20,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: CommonButton(
                                                                        loading: false,
                                                                        title: "Compris",
                                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CheckScreen(event: event),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                            boxShadow: [Utils.customShadow()]
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        margin: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Row (
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.qrcode_viewfinder,
                                              size: 15,
                                              color: appColors.btnColor,
                                            ),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              "Vérifier invitation",
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
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => InformationsScreen(event: event),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                            boxShadow: [Utils.customShadow()]
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        margin: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Row (
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.text_justify, size: 15, color: appColors.btnColor,),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              "Details de l'évenement",
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
                                      ),
                                    ),
                                    if (event.shared != true || roles.contains(EventAdminRoles.sendInvitations))
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    if (event.shared != true || roles.contains(EventAdminRoles.sendInvitations))
                                    GestureDetector(
                                      onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => InvitationsListScreen(event: event),
                                            ),
                                          );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: appColors.darkGreyText, width: 1),
                                          boxShadow: [Utils.customShadow()]
                                        ),
                                        margin: const EdgeInsets.symmetric(horizontal: 20),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row (
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.mail_solid,
                                              size: 15,
                                              color: appColors.btnColor,
                                            ),
                                            SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                            MyTextView(
                                              Strings.invites,
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
                                      ),
                                    ),
                                    if (event.shared != true || roles.contains(EventAdminRoles.addAdmins))
                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    if (event.shared != true || roles.contains(EventAdminRoles.addAdmins))
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AdminListScreen(event: event, roles: roles,),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: appColors.appLightColor,
                                            borderRadius: BorderRadius.circular(5),
                                              boxShadow: [Utils.customShadow()]
                                          ),
                                          margin: const EdgeInsets.symmetric(horizontal: 20),
                                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                          child: Row (
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.admin_panel_settings_rounded, size: 15, color: appColors.btnColor,),
                                              SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                              MyTextView(
                                                "Gestionnaires",
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
                                        ),
                                      ),
                                    if (event.shared != true)
                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                      Divider(color: Colors.black.withOpacity(.05),),
                                    if (event.shared != true || roles.contains(EventAdminRoles.manageTables))
                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    if (event.shared != true || roles.contains(EventAdminRoles.manageTables))
                                    GestureDetector(
                                      onTap: () {
                                        if (event.hasTables == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TableListScreen(event: event),
                                            ),
                                          );
                                        } else {
                                          showUnlockDialog(1, "TABLE");
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                          boxShadow: [Utils.customShadow()]
                                        ),
                                        margin: const EdgeInsets.symmetric(horizontal: 20),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row (
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(CupertinoIcons.table_fill, size: 15, color: appColors.btnColor,),
                                                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                MyTextView(
                                                  Strings.tables,
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
                                            if (event.hasTables != true)
                                              Icon(event.hasTables == true ? CupertinoIcons.lock_open_fill : CupertinoIcons.lock_fill, color: appColors.black, size: 20,)
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (event.shared != true || roles.contains(EventAdminRoles.manageDrinks))
                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    if (event.shared != true || roles.contains(EventAdminRoles.manageDrinks))
                                    GestureDetector(
                                      onTap: () {
                                        if (event.hasBeverage == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BeverageListScreen(event: event),
                                            ),
                                          );
                                        } else {
                                          showUnlockDialog(2, "BEVERAGE");
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                          boxShadow: [Utils.customShadow()]
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row (
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.wine_bar_outlined, size: 15, color: appColors.btnColor,),
                                                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                MyTextView(
                                                  Strings.beverage,
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
                                            if (event.hasBeverage != true)
                                              Icon(CupertinoIcons.lock_fill, color: appColors.black, size: 20,)
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (event.shared != true || roles.contains(EventAdminRoles.manageGuestbook))
                                      SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
                                    if (event.shared != true || roles.contains(EventAdminRoles.manageGuestbook))
                                    GestureDetector(
                                      onTap: () {
                                        if (event.hasBook == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BookScreen(event: event),
                                            ),
                                          );
                                        } else {
                                          showUnlockDialog(6, "BOOK");
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                            boxShadow: [Utils.customShadow()]
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(CupertinoIcons.book_fill, size: 15, color: appColors.btnColor),
                                                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                MyTextView(
                                                  "Livre d'or",
                                                  textAligntNew: TextAlign.start,
                                                  maxLineWrap: true,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.lightColor,
                                                    fontWeightNew: FontWeight.w500,
                                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                            if (event.hasBook != true)
                                              Icon(CupertinoIcons.lock_fill, color: appColors.black, size: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (event.shared != true || roles.contains(EventAdminRoles.viewMusicRequests))
                                    GestureDetector(
                                      onTap: () {
                                        if (event.hasMusic == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MusicListScreen(event: event),
                                            ),
                                          );
                                        } else {
                                          showUnlockDialog(1, "MUSIC");
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                            boxShadow: [Utils.customShadow()]
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(CupertinoIcons.music_note_list, size: 15, color: appColors.btnColor),
                                                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                MyTextView(
                                                  "Demandes musicales",
                                                  textAligntNew: TextAlign.start,
                                                  maxLineWrap: true,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.lightColor,
                                                    fontWeightNew: FontWeight.w500,
                                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                            if (event.hasMusic != true)
                                              Icon(CupertinoIcons.lock_fill, color: appColors.black, size: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (event.shared != true || roles.contains(EventAdminRoles.manageInteractiveGame))
                                    GestureDetector(
                                      onTap: () {
                                        if (event.hasGame == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => GameScreen(event: event),
                                            ),
                                          );
                                        } else {
                                          showUnlockDialog(2, "GAME");
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(5),
                                            boxShadow: [Utils.customShadow()]
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(CupertinoIcons.question_circle, size: 15, color: appColors.btnColor),
                                                SizedBox(width: ResponsiveFlutter.of(context).moderateScale(10)),
                                                MyTextView(
                                                  "Jeu intéractif",
                                                  textAligntNew: TextAlign.start,
                                                  maxLineWrap: true,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.lightColor,
                                                    fontWeightNew: FontWeight.w500,
                                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                            if (event.hasGame != true)
                                              Icon(CupertinoIcons.lock_fill, color: appColors.black, size: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).moderateScale(50)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                    }
                  }
              )
          ),
        ),
      ),
    );
  }

  void imagePick(EventModel event) async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image!.path);
      setState(() {
        loadingImage = true;
      });
      await eventViewModel.editEventImageApi(context, image, event.id!).then((value) {
        setState(() {
          loadingImage = false;
          imageFile = null;
        });
      });
    }
  }
}
