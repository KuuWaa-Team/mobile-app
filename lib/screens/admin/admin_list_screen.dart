import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/eventAdmin/event_admin_controller.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/screens/events/payment_screen.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/eventAdmin/event_admin_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class AdminListScreen extends StatefulWidget {
  EventModel event;
  List<String> roles;
  AdminListScreen({Key? key, required this.event, required this.roles}) : super(key: key);

  @override
  _AdminListScreenState createState() => _AdminListScreenState();
}

class _AdminListScreenState extends State<AdminListScreen> {
  AppColors appColors = AppColors();
  EventAdminViewModel adminViewModel = EventAdminViewModel();

  bool loading = false;
  bool sending = false;

  UserModel? user;

  final TextEditingController _nameController = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(
      mask: '*## ### ###',
      filter: { "#": RegExp(r'\d'), "*": RegExp(r'[1-9]') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    adminViewModel.listingApi(context, widget.event.id!);
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: SafeArea(
        child: Column(
          children: [
            commonAppBar(
              context: context,
              title: "Gestionnaires",
              backArrow: true,
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    List<String> selectedPermissions = [EventAdminRoles.verifyInvitations];
            
                    final Map<String, String> permissionLabels = {
                      "Vérifier les invitations": EventAdminRoles.verifyInvitations,
                      "Envoyer des invitations": EventAdminRoles.sendInvitations,
                      "Ajouter des gestionnaires": EventAdminRoles.addAdmins,
                      "Gestion des tables": EventAdminRoles.manageTables,
                      "Gestion des boissons": EventAdminRoles.manageDrinks,
                      "Gérer le livre d'or": EventAdminRoles.manageGuestbook,
                      "Gérer l'album photo": EventAdminRoles.managePhotoAlbum,
                      "Consulter les demandes musicales": EventAdminRoles.viewMusicRequests,
                      "Gérer le jeu interactif": EventAdminRoles.manageInteractiveGame,
                    };
            
                    if (widget.roles.isNotEmpty) {
                      permissionLabels.removeWhere((label, value) => !widget.roles.contains(value));
                    }
            
                    const String alwaysCheckedLabel = "Vérifier les invitations";
            
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: appColors.appMediumColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            bool isAllChecked() =>
                                selectedPermissions.length == permissionLabels.length;
            
                            void toggleAll(bool value) {
                              setState(() {
                                selectedPermissions = value
                                    ? [...permissionLabels.values]
                                    : [EventAdminRoles.verifyInvitations];
                              });
                            }
            
                            return Padding(
                              padding: EdgeInsets.only(
                                top: 20,
                                left: 20,
                                right: 20,
                                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    MyTextView(
                                      "Ajouter un Gestionnaires",
                                      textAligntNew: TextAlign.center,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.lightColor,
                                        fontWeightNew: FontWeight.w600,
                                        size: ResponsiveFlutter.of(context).fontSize(1.5),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      height: ResponsiveFlutter.of(context).verticalScale(40),
                                      padding: EdgeInsets.symmetric(
                                        vertical: ResponsiveFlutter.of(context).moderateScale(6),
                                        horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                                      ),
                                      margin: EdgeInsets.only(
                                        bottom: ResponsiveFlutter.of(context).moderateScale(10),
                                      ),
                                      decoration: BoxDecoration(
                                        color: appColors.appLightColor,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveFlutter.of(context).moderateScale(25),
                                        ),
                                      ),
                                      child: commonTestField(
                                        context: context,
                                        controller: _nameController,
                                        hintText: "Nom du Gestionnaires",
                                        keyboardType: TextInputType.text,
                                        icon: true,
                                      ),
                                    ),
            
                                    // Tout cocher
                                    CheckboxListTile(
                                      title: MyTextView(
                                        "Tout cocher",
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.black,
                                          fontWeightNew: FontWeight.w600,
                                          size: ResponsiveFlutter.of(context).fontSize(1.6),
                                        ),
                                      ),
                                      activeColor: appColors.btnColor,
                                      value: isAllChecked(),
                                      onChanged: (val) => toggleAll(val ?? false),
                                      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                    ),
            
                                    // Liste des permissions
                                    ...permissionLabels.entries.map((entry) {
                                      final label = entry.key;
                                      final value = entry.value;
                                      final isMandatory = label == alwaysCheckedLabel;
            
                                      return Column(
                                        children: [
                                          Divider(
                                            height: 1,
                                            color: Colors.black.withOpacity(.05),
                                            thickness: 1,
                                          ),
                                          CheckboxListTile(
                                            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                            title: MyTextView(
                                              label,
                                              styleNew: MyTextStyle(
                                                colorNew: appColors.black,
                                                size: ResponsiveFlutter.of(context).fontSize(1.6),
                                              ),
                                            ),
                                            activeColor: appColors.btnColor,
                                            value: selectedPermissions.contains(value),
                                            onChanged: isMandatory
                                                ? null
                                                : (bool? checked) {
                                              setState(() {
                                                if (checked == true) {
                                                  selectedPermissions.add(value);
                                                } else {
                                                  selectedPermissions.remove(value);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    }).toList(),
            
                                    const SizedBox(height: 10),
                                    if (user != null)
                                    GestureDetector(
                                      onTap: () async {
                                        if (_nameController.text.trim().isEmpty) {
                                          Utils.flushBarErrorMessage("Vous devez entrer le nom du Gestionnaires", context);
                                          return;
                                        }
                                        if (selectedPermissions.isEmpty) {
                                          Utils.flushBarErrorMessage("Veuillez sélectionner au moins une autorisation", context);
                                          return;
                                        }
            
                                        setState(() => loading = true);
            
                                        Map data = {
                                          "name": _nameController.text.trim(),
                                          "eventId": widget.event.id!,
                                          "userId": user!.id!,
                                          "permissions": selectedPermissions,
                                        };
            
                                        await adminViewModel.addAdmin(context, data).then((value) {
                                          setState(() {
                                            loading = false;
                                            _nameController.text = "";
                                            selectedPermissions = [EventAdminRoles.verifyInvitations];
                                          });
                                        });
                                      },
                                      child: CommonButton(
                                        title: "Enrégistrer",
                                        loading: loading,
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10),
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                      color: appColors.btnColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 20),
                        const SizedBox(width: 5),
                        MyTextView(
                          Strings.add,
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.white,
                            fontWeightNew: FontWeight.w600,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    adminViewModel.listingApi(context, widget.event.id!);
                  },
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                        color: appColors.darkGreyText,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.arrow_clockwise, color: Colors.white, size: 20,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            ChangeNotifierProvider<EventAdminViewModel>(
                create: (BuildContext context) => adminViewModel,
                child: Consumer<EventAdminViewModel>(
                    builder: (context, value, _) {
                      switch (value.adminsList.status) {
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
                            child: Text(value.adminsList.message.toString()),
                          );
                        case Status.COMPLETED:
                          List<EventAdminModel> admins = value.adminsList.data;
                          if (admins.isEmpty) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: appColors.appLightColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20
                              ),
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.block_outlined, color: appColors.lightColor.withOpacity(.2),),
                                  const SizedBox(width: 10,),
                                  MyTextView(
                                    "Vous n'avez ajouté aucun Gestionnaires",
                                    textAligntNew: TextAlign.start,
                                    maxLinesNew: 3,
                                    styleNew: MyTextStyle(
                                      colorNew: appColors.lightColor.withOpacity(.2),
                                      fontWeightNew: FontWeight.w400,
                                      size: ResponsiveFlutter.of(context).fontSize(1.6),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: ResponsiveFlutter.of(context).verticalScale(15),
                                  left: ResponsiveFlutter.of(context).scale(20),
                                  right: ResponsiveFlutter.of(context).scale(20),
                                ),
                                child: ListView.builder(
                                  itemCount: adminViewModel.adminsList.data!.length,
                                  itemBuilder: (context, index) {
                                    EventAdminModel admin = adminViewModel.adminsList.data![index];
            
                                    return GestureDetector(
                                      onTap: () => _showAdminDetailsModal(context, admin),
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                          bottom: ResponsiveFlutter.of(context).moderateScale(10),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                        decoration: BoxDecoration(
                                          color: appColors.appLightColor,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(width: 10,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                MyTextView(
                                                                  admin.name.toString(),
                                                                  textAligntNew: TextAlign.center,
                                                                  styleNew: MyTextStyle(
                                                                    colorNew: appColors.lightColor,
                                                                    fontWeightNew: FontWeight.w600,
                                                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                if (admin.status == 'refused')
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: appColors.red
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        MyTextView(
                                                          "Pas disponible",
                                                          textAligntNew: TextAlign.center,
                                                          styleNew: MyTextStyle(
                                                            colorNew: appColors.lightColor,
                                                            fontWeightNew: FontWeight.w700,
                                                            size: ResponsiveFlutter.of(context).fontSize(1.3),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (admin.status == 'refused')
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: appColors.lightColor.withOpacity(.1)
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.close, color: appColors.lightColor, size: 15,)
                                                      ],
                                                    ),
                                                  ),
                                                if (admin.status == 'waiting')
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.orange
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                    child: Row(
                                                      children: [
                                                        MyTextView(
                                                          'En attente' ,
                                                          textAligntNew: TextAlign.center,
                                                          styleNew: MyTextStyle(
                                                            colorNew: appColors.lightColor,
                                                            fontWeightNew: FontWeight.w400,
                                                            size: ResponsiveFlutter.of(context).fontSize(1.2),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                if (admin.status == 'accepted')
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.green
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                    child: Row(
                                                      children: [
                                                        MyTextView(
                                                          'Actif' ,
                                                          textAligntNew: TextAlign.center,
                                                          styleNew: MyTextStyle(
                                                            colorNew: appColors.lightColor,
                                                            fontWeightNew: FontWeight.w400,
                                                            size: ResponsiveFlutter.of(context).fontSize(1.2),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                          );
                      }
                    }
                )
            ),
          ],
        ),
      ),
    );
  }

  void _showAdminDetailsModal(BuildContext context, EventAdminModel admin) {
    final List<String> rolesList = admin.roles.toString().split(',');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      backgroundColor: appColors.appLightColor,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyTextView(
                  admin.name.toString(),
                  textAligntNew: TextAlign.center,
                  styleNew: MyTextStyle(
                    colorNew: appColors.black,
                    fontWeightNew: FontWeight.w700,
                    size: ResponsiveFlutter.of(context).fontSize(2),
                  ),
                ),
                const SizedBox(height: 10),
                MyTextView(
                  admin.invitationCode ?? "—",
                  textAligntNew: TextAlign.center,
                  styleNew: MyTextStyle(
                    colorNew: appColors.btnColor,
                    fontWeightNew: FontWeight.bold,
                    size: ResponsiveFlutter.of(context).fontSize(3.5),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyTextView(
                    "Autorisations :",
                    styleNew: MyTextStyle(
                      colorNew: appColors.black,
                      fontWeightNew: FontWeight.w600,
                      size: ResponsiveFlutter.of(context).fontSize(1.6),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ...rolesList.map((role) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MyTextView(
                            EventAdminRoles.getLabel(role),
                            styleNew: MyTextStyle(
                              colorNew: appColors.black,
                              size: ResponsiveFlutter.of(context).fontSize(1.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 25),GestureDetector(
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Confirmer la suppression"),
                        content: const Text("Voulez-vous vraiment supprimer cet administrateur ?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Annuler"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await adminViewModel.removeApi(context, admin.id!).then((value) {
                        if (value) {
                          adminViewModel.listingApi(context, widget.event.id!);
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.delete_outline_sharp, color: Colors.red, size: 20,),
                          Text(
                            "Supprimer",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveFlutter.of(context).fontSize(1.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    final labelRoles = rolesList.map((r) => "- ${EventAdminRoles.getLabel(r)}").join("\n");

                    final message = '''
Bonjour ${admin.name},
                      
Vous avez été sélectionné comme gestionnaire de l'évènement "${widget.event.title}" (${widget.event.category!.name}).
                      
Votre code d’accès : 
${admin.invitationCode}
                      
Rôles assignés :
$labelRoles
                      
Ouvrez ce lien pour accéder a l'invitation : https://invitation.kuuwaa.com/event-admins/${admin.invitationCode}
                      ''';

                    Share.share(message);
                  },
                  child: CommonButton(title: "Envoyer l'invitation"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}