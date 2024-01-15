import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/beverage/beverage_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/beverage/beverage_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class BeverageListScreen extends StatefulWidget {
  int id;
  BeverageListScreen({Key? key, required this.id}) : super(key: key);

  @override
  _BeverageListScreenState createState() => _BeverageListScreenState();
}

class _BeverageListScreenState extends State<BeverageListScreen> {
  AppColors appColors = AppColors();
  BeverageViewModel beverageViewModel = BeverageViewModel();

  bool loading = false;
  bool sending = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(
      mask: '### ### ###',
      filter: { "#": RegExp(r'\d') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    beverageViewModel.listingApi(context, widget.id);
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
              title: "Gestion des boissons",
              backArrow: true,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
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
                                          "Ajouter une boisson",
                                          textAligntNew: TextAlign.center,
                                          styleNew: MyTextStyle(
                                            colorNew: appColors.lightColor,
                                            fontWeightNew: FontWeight.w600,
                                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
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
                                            hintText: "Nom de la boisson",
                                            keyboardType: TextInputType.text,
                                            icon: true,
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap: () {
                                            if (_nameController.text == "") {
                                              Utils.flushBarErrorMessage("Vous devez enter le nom de la boisson", context);
                                            } else {
                                              setState(() {
                                                loading = true;
                                              });
                                              Map data = {
                                                "name": _nameController.text,
                                                "eventId": widget.id
                                              };

                                              beverageViewModel.addBeverage(context, data).then((value) {
                                                setState(() {
                                                  loading = false;
                                                  _nameController.clear();
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
                    width: MediaQuery.of(context).size.width - 50 - 100 - 10,
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
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Colors.white, size: 20,),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file_outlined, color: Colors.white, size: 20,),
                    ],
                  ),
                ),
              ],
            ),

            ChangeNotifierProvider<BeverageViewModel>(
                create: (BuildContext context) => beverageViewModel,
                child: Consumer<BeverageViewModel>(
                    builder: (context, value, _) {
                      switch (value.beveragesList.status) {
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
                            child: Text(value.beveragesList.message.toString()),
                          );
                        case Status.COMPLETED:
                          List<BeverageModel> beverages = value.beveragesList.data;
                          if (beverages.isEmpty) {
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
                                    "Vous n'avez ajouté aucune boisson",
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
                                  itemCount: beverageViewModel.beveragesList.data!.length,
                                  itemBuilder: (context, index) {
                                    BeverageModel beverage = beverageViewModel.beveragesList.data![index];

                                    // List<Widget> tableIvitations = [];
                                    //
                                    // if (table.invitations != null) {
                                    //   for (var element in table.invitations!) {
                                    //     tableIvitations.add(
                                    //         Container(
                                    //           decoration: BoxDecoration(
                                    //               color: appColors.appLightColor,
                                    //               borderRadius: BorderRadius.circular(4)
                                    //           ),
                                    //           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    //           child: MyTextView(
                                    //             element.civility.toString() + " " + element.name.toString() + (element.count! >= 2 ? " (" +  element.count.toString() + ")" : ""),
                                    //             styleNew: MyTextStyle(
                                    //               colorNew: appColors.lightColor,
                                    //               fontWeightNew: FontWeight.w400,
                                    //               size: ResponsiveFlutter.of(context).fontSize(1.4),
                                    //             ),
                                    //           ),
                                    //         )
                                    //     );
                                    //   }
                                    // }

                                    return GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor: appColors.appMediumColor,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only( // <-- SEE HERE
                                                topLeft: Radius.circular(30.0),
                                                topRight: Radius.circular(30.0),
                                              ),
                                            ),
                                            builder: (context) {
                                              return Padding(
                                                padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      MyTextView(
                                                        beverage.name!,
                                                        textAligntNew: TextAlign.center,
                                                        styleNew: MyTextStyle(
                                                          colorNew: appColors.lightColor,
                                                          fontWeightNew: FontWeight.w400,
                                                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10,),

                                                      const SizedBox(height: 10,),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (beverage.countTaken != null && beverage.countTaken! > 0) {
                                                            showModalBottomSheet(
                                                                context: context,
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
                                                                                  "Invités (Boisson - " + beverage.name.toString() + ")",
                                                                                  textAligntNew: TextAlign.center,
                                                                                  styleNew: MyTextStyle(
                                                                                    colorNew: appColors.lightColor,
                                                                                    fontWeightNew: FontWeight.w600,
                                                                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: ResponsiveFlutter.of(context).verticalScale(20)),
                                                                                // Wrap(
                                                                                //   spacing: 10,
                                                                                //   runSpacing: 10,
                                                                                //   children: [
                                                                                //     ...tableIvitations
                                                                                //   ],
                                                                                // ),
                                                                                SizedBox(height: ResponsiveFlutter.of(context).verticalScale(20)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                  );
                                                                }
                                                            );
                                                          }

                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              color: appColors.appLightColor
                                                          ),
                                                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              MyTextView(
                                                                "Invétés ayant commendé",
                                                                textAligntNew: TextAlign.center,
                                                                styleNew: MyTextStyle(
                                                                  colorNew: appColors.lightColor,
                                                                  fontWeightNew: FontWeight.w400,
                                                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                ),
                                                              ),
                                                              MyTextView(
                                                                (beverage.countTaken! == 0 ? "Aucun": (beverage.countTaken!).toString()),
                                                                textAligntNew: TextAlign.center,
                                                                styleNew: MyTextStyle(
                                                                  colorNew: beverage.countTaken! == 0 ? appColors.red : Colors.green,
                                                                  fontWeightNew: FontWeight.w600,
                                                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 20,),
                                                      SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10)),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                        );
                                      },
                                      child: Container(
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
                                                                  beverage.name.toString(),
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
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: appColors.lightColor.withOpacity(.3), width: 1)
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                    child: Row(
                                                      children: [
                                                        MyTextView(
                                                          beverage.countTaken!.toString() + " commande" +  (beverage.countTaken! > 1 ? "s" : ""),
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
}