import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/table/table_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/table/table_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class TableListScreen extends StatefulWidget {
  EventModel event;
  TableListScreen({Key? key, required this.event}) : super(key: key);

  @override
  _TableListScreenState createState() => _TableListScreenState();
}

class _TableListScreenState extends State<TableListScreen> {
  AppColors appColors = AppColors();
  TableViewModel tableViewModel = TableViewModel();

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
    tableViewModel.listingApi(context, widget.event.id!);
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
              title: "Gestion des tables",
              backArrow: true,
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: widget.event.shared != true ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                if (widget.event.shared != true)
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
                                          "Ajouter une table",
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
                                            hintText: "Nom de la table",
                                            keyboardType: TextInputType.text,
                                            icon: true,
                                          ),
                                        ),
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
                                            controller: _countController,
                                            hintText: "Nombre de places",
                                            keyboardType: TextInputType.number,
                                            icon: true,
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap: () async {
                                            if (_nameController.text == "") {
                                              Utils.flushBarErrorMessage("Vous devez enter le nom de la table", context);
                                            } else if (_countController.text == "") {
                                              Utils.flushBarErrorMessage("Vous devez enter le nombre des place dispo à la table", context);
                                            } else {
                                              setState(() {
                                                loading = true;
                                              });
                                              Map data = {
                                                "name": _nameController.text,
                                                "count": int.parse(_countController.text),
                                                "eventId": widget.event.id
                                              };

                                              await tableViewModel.addTable(context, data).then((value) {
                                                setState(() {
                                                  loading = false;
                                                  _nameController.text = "";
                                                  _countController.text = "";
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
                    tableViewModel.listingApi(context, widget.event.id!);
                  },
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: appColors.black,
                      shape: BoxShape.circle
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

            ChangeNotifierProvider<TableViewModel>(
                create: (BuildContext context) => tableViewModel,
                child: Consumer<TableViewModel>(
                    builder: (context, value, _) {
                      switch (value.tablesList.status) {
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
                            child: Text(value.tablesList.message.toString()),
                          );
                        case Status.COMPLETED:
                          List<TableModel> tables = value.tablesList.data;
                          if (tables.isEmpty) {
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
                                    "Vous n'avez ajouté aucune table",
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
                                  itemCount: tableViewModel.tablesList.data!.length,
                                  itemBuilder: (context, index) {
                                    TableModel table = tableViewModel.tablesList.data![index];
                                    List<Widget> tableIvitations = [];

                                    if (table.invitations != null) {
                                      for (var element in table.invitations!) {
                                        tableIvitations.add(
                                          Container(
                                            decoration: BoxDecoration(
                                              color: appColors.appLightColor,
                                              borderRadius: BorderRadius.circular(4)
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                            child: MyTextView(
                                              element.civility.toString() + " " + element.name.toString() + (element.count! >= 2 ? " (" +  element.count.toString() + ")" : ""),
                                              styleNew: MyTextStyle(
                                                colorNew: appColors.lightColor,
                                                fontWeightNew: FontWeight.w400,
                                                size: ResponsiveFlutter.of(context).fontSize(1.4),
                                              ),
                                            ),
                                          )
                                        );
                                      }
                                    }

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
                                                        "Table " + table.name!,
                                                        textAligntNew: TextAlign.center,
                                                        styleNew: MyTextStyle(
                                                          colorNew: appColors.lightColor,
                                                          fontWeightNew: FontWeight.w400,
                                                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10,),

                                                      const SizedBox(height: 10,),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: appColors.appLightColor
                                                        ),
                                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            MyTextView(
                                                              "Nombre de places",
                                                              textAligntNew: TextAlign.center,
                                                              styleNew: MyTextStyle(
                                                                colorNew: appColors.lightColor.withOpacity(.5),
                                                                fontWeightNew: FontWeight.w400,
                                                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                              ),
                                                            ),
                                                            MyTextView(
                                                              table.count.toString(),
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
                                                      const SizedBox(height: 10,),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (table.invitations != null && table.invitations!.isNotEmpty) {
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
                                                                                  "Invités (Table " + table.name.toString() + ")",
                                                                                  textAligntNew: TextAlign.center,
                                                                                  styleNew: MyTextStyle(
                                                                                    colorNew: appColors.lightColor,
                                                                                    fontWeightNew: FontWeight.w600,
                                                                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: ResponsiveFlutter.of(context).verticalScale(20)),
                                                                                Wrap(
                                                                                  spacing: 10,
                                                                                  runSpacing: 10,
                                                                                  children: [
                                                                                    ...tableIvitations
                                                                                  ],
                                                                                ),
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
                                                                "Invétés affectés",
                                                                textAligntNew: TextAlign.center,
                                                                styleNew: MyTextStyle(
                                                                  colorNew: appColors.lightColor,
                                                                  fontWeightNew: FontWeight.w400,
                                                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                ),
                                                              ),
                                                              MyTextView(
                                                                table.countTaken.toString(),
                                                                textAligntNew: TextAlign.center,
                                                                styleNew: MyTextStyle(
                                                                  colorNew: Colors.orange,
                                                                  fontWeightNew: FontWeight.w600,
                                                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10,),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: appColors.appLightColor
                                                        ),
                                                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            MyTextView(
                                                              "Paces disponibles",
                                                              textAligntNew: TextAlign.center,
                                                              styleNew: MyTextStyle(
                                                                colorNew: appColors.lightColor.withOpacity(.5),
                                                                fontWeightNew: FontWeight.w400,
                                                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                              ),
                                                            ),
                                                            MyTextView(
                                                              (table.countTaken! >= table.count! ? "Aucune": (table.count! - table.countTaken!).toString()),
                                                              textAligntNew: TextAlign.center,
                                                              styleNew: MyTextStyle(
                                                                colorNew: table.countTaken! >= table.count! ? appColors.red : Colors.green,
                                                                fontWeightNew: FontWeight.w600,
                                                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                              ),
                                                            ),
                                                          ],
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
                                          bottom: ResponsiveFlutter.of(context).moderateScale(5),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(5, 8,8, 8),
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
                                                                  "Table",
                                                                  textAligntNew: TextAlign.center,
                                                                  styleNew: MyTextStyle(
                                                                    colorNew: appColors.btnColor.withOpacity(.8),
                                                                    fontWeightNew: FontWeight.w400,
                                                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 5,),
                                                                MyTextView(
                                                                  table.name.toString(),
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
                                                              table.count.toString() + " places",
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
                                                if (table.countTaken! >= table.count!)
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: appColors.red
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        MyTextView(
                                                          "Remplie",
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
                                                if (table.countTaken! < table.count!)
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: appColors.lightColor.withOpacity(.3), width: 1)
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                    child: Row(
                                                      children: [
                                                        MyTextView(
                                                          ((table.count! - table.countTaken!).toString() + " Places dispo") ,
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