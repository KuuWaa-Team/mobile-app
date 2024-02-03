import 'package:flutter/cupertino.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/eventAdmin/event_admin_controller.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/eventAdmin/event_admin_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class AdminListScreen extends StatefulWidget {
  int id;
  AdminListScreen({Key? key, required this.id}) : super(key: key);

  @override
  _AdminListScreenState createState() => _AdminListScreenState();
}

class _AdminListScreenState extends State<AdminListScreen> {
  AppColors appColors = AppColors();
  EventAdminViewModel adminViewModel = EventAdminViewModel();

  bool loading = false;
  bool sending = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(
      mask: '*## ### ###',
      filter: { "#": RegExp(r'\d'), "*": RegExp(r'[1-9]') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    adminViewModel.listingApi(context, widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              title: "Controlleurs",
              backArrow: true,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: appColors.appMediumColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only( // <-- SEE HERE
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (context, setState) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        MyTextView(
                                          "Ajouter un Controlleur",
                                          textAligntNew: TextAlign.center,
                                          styleNew: MyTextStyle(
                                            colorNew: appColors.lightColor,
                                            fontWeightNew: FontWeight.w600,
                                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        Container(
                                          height: ResponsiveFlutter.of(context).verticalScale(40),
                                          padding: EdgeInsets.symmetric(
                                            vertical: ResponsiveFlutter.of(context).moderateScale(6),
                                            horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                                          ),
                                          margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                                          decoration: BoxDecoration(
                                            color: appColors.appLightColor,
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveFlutter.of(context).moderateScale(25),
                                            ),
                                          ),
                                          child: commonTestField(
                                            context: context,
                                            controller: _nameController,
                                            hintText: "Nom du controlleur",
                                            keyboardType: TextInputType.text,
                                            icon: true,
                                          ),
                                        ),
                                        Container(
                                          height: ResponsiveFlutter.of(context).verticalScale(40),
                                          padding: EdgeInsets.symmetric(
                                            vertical: ResponsiveFlutter.of(context).moderateScale(5),
                                            horizontal: ResponsiveFlutter.of(context).moderateScale(25),
                                          ),
                                          margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(25)),
                                          decoration: BoxDecoration(
                                            color: appColors.appLightColor,
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveFlutter.of(context).moderateScale(25),
                                            ),
                                          ),
                                          child: commonTestField(
                                            context: context,
                                            controller: _phoneController,
                                            initial: "+243 ",
                                            hintText: Strings.yourPhoneNumber,
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [maskFormatter],
                                            icon: true,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (_nameController.text == "") {
                                              Utils.flushBarErrorMessage("Vous devez enter le nom du controlleur", context);
                                            } else if (_phoneController.text == "") {
                                              Utils.flushBarErrorMessage("Vous devez enter le numéro de téléphone du controlleur", context);
                                            } else {
                                              setState(() {
                                                loading = true;
                                              });
                                              Map data = {
                                                "name": _nameController.text,
                                                "phoneNumber": _phoneController.text,
                                                "eventId": widget.id
                                              };

                                              adminViewModel.addAdmin(context, data).then((value) {
                                                setState(() {
                                                  loading = false;
                                                });
                                              });
                                            }
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
                              }
                          );
                        }
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10),
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                        color: appColors.btnColor,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 20,),
                        const SizedBox(width: 5,),
                        MyTextView(
                          Strings.add,
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
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
                    adminViewModel.listingApi(context, widget.id);
                  },
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                        color: appColors.appLightColor,
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
                                    "Vous n'avez ajouté aucun controlleur",
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

                                    return Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                        bottom: ResponsiveFlutter.of(context).moderateScale(15),
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
                                                          const SizedBox(height: 3,),
                                                          MyTextView(
                                                            "+243 " + admin.phoneNumber!,
                                                            textAligntNew: TextAlign.center,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.lightColor.withOpacity(.5),
                                                              fontWeightNew: FontWeight.w400,
                                                              size: ResponsiveFlutter.of(context).fontSize(1.2),
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
}