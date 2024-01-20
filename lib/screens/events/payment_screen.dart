import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PaymentScreen extends StatefulWidget {
  EventModel event;
  PaymentScreen({Key? key, required this.event}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  AppColors appColors = AppColors();
  bool loading = false;
  var maskFormatter = MaskTextInputFormatter(
      mask: '*## ### ###',
      filter: { "#": RegExp(r'\d'), "*": RegExp(r'[1-9]') },
      type: MaskAutoCompletionType.lazy
  );

  EventModel event = EventModel();

  final TextEditingController _phoneController = TextEditingController();

  double total = 0;

  @override
  void initState() {
    setState(() {
      event = widget.event;
    });
    total = double.parse(event.eventPack!.price.toString());
    if (event.features != null) {
      event.features!.forEach((element) {
        total += double.parse(element.price.toString());
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> featuresWidget = [];

    if (event.features != null && event.features!.isNotEmpty) {
      for (var element in event.features!) {
        featuresWidget.add(
          Column(
            children: [
              Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTextView(
                    "+ ${element.name}",
                    textAligntNew: TextAlign.center,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor.withOpacity(.5),
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(1.5),
                    ),
                  ),
                  MyTextView(
                    "+" + element.price!.toInt().toString() + "\$",
                    textAligntNew: TextAlign.center,
                    styleNew: MyTextStyle(
                      colorNew: appColors.green,
                      fontWeightNew: FontWeight.w600,
                      size: ResponsiveFlutter.of(context).fontSize(1.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              title: "Activer l'évenement",
              backArrow: true,
              context: context,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveFlutter.of(context).moderateScale(15),
                  horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                ),
                children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: appColors.appLightColor,
                        borderRadius: BorderRadius.circular(
                          ResponsiveFlutter.of(context).moderateScale(20),
                        ),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          MyTextView(
                            "Résumés",
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.btnColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.8),
                            ),
                          ),
                          Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyTextView(
                                "Titre",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor.withOpacity(.5),
                                  fontWeightNew: FontWeight.w400,
                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                ),
                              ),
                              MyTextView(
                                event.name.toString(),
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor,
                                  fontWeightNew: FontWeight.w600,
                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyTextView(
                                "Catégorie",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor.withOpacity(.5),
                                  fontWeightNew: FontWeight.w400,
                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                ),
                              ),
                              MyTextView(
                                event.category == null ? "" :event.category!.name.toString(),
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor,
                                  fontWeightNew: FontWeight.w600,
                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                        ],
                      )
                  ),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: appColors.appLightColor,
                        borderRadius: BorderRadius.circular(
                          ResponsiveFlutter.of(context).moderateScale(20),
                        ),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          MyTextView(
                            "Facturation",
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.btnColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.8),
                            ),
                          ),
                          Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyTextView(
                                "Pack",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor.withOpacity(.5),
                                  fontWeightNew: FontWeight.w400,
                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                ),
                              ),
                              MyTextView(
                                event.eventPack == null ? "" : event.eventPack!.name.toString(),
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor,
                                  fontWeightNew: FontWeight.w600,
                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyTextView(
                                "Nombre d'invitations",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor.withOpacity(.5),
                                  fontWeightNew: FontWeight.w400,
                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                ),
                              ),
                              MyTextView(
                                event.eventPack == null ? "" : (event.eventPack!.maxTickets == null ? "illimités" : event.eventPack!.maxTickets.toString()),
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor,
                                  fontWeightNew: FontWeight.w600,
                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: appColors.lightColor.withOpacity(.1), height: 20, thickness: .5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyTextView(
                                "Coût du pack",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.lightColor.withOpacity(.5),
                                  fontWeightNew: FontWeight.w400,
                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                ),
                              ),
                              MyTextView(
                                event.eventPack == null ? "" : event.eventPack!.price!.toInt().toString() + "\$",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.green,
                                  fontWeightNew: FontWeight.w600,
                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                ),
                              ),
                            ],
                          ),
                          ...featuresWidget,
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1, color: appColors.lightColor.withOpacity(.1))
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyTextView(
                                  "Total à payer",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.lightColor,
                                    fontWeightNew: FontWeight.w400,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                                MyTextView(
                                  total.toInt().toString() + "\$",
                                  textAligntNew: TextAlign.center,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.green,
                                    fontWeightNew: FontWeight.w600,
                                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
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
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, icon: const Icon(Icons.close)
                                    )
                                ),
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
                                            Icons.question_mark_rounded,
                                            color: appColors.btnColor,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Comment voulez-vous payer ?", style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ), textAlign: TextAlign.center,),
                                        ],
                                      ),
                                      const SizedBox(height: 20,),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
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
                                                          Positioned(
                                                              right: 0,
                                                              top: 0,
                                                              child: IconButton(onPressed: (){
                                                                Navigator.pop(context);
                                                              }, icon: const Icon(Icons.close)
                                                              )
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                                            child:
                                                            Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                const Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text("Entre votre numéro mobile monney...", style: TextStyle(
                                                                        fontWeight: FontWeight.bold
                                                                    ), textAlign: TextAlign.center,),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10,),
                                                                Image.asset(ImagePath.map),
                                                                const SizedBox(height: 10,),
                                                                Container(
                                                                  height: ResponsiveFlutter.of(context).verticalScale(40),
                                                                  padding: EdgeInsets.symmetric(
                                                                    vertical: ResponsiveFlutter.of(context).moderateScale(5),
                                                                    horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                                                                  ),
                                                                  margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(25)),
                                                                  decoration: BoxDecoration(
                                                                    color: appColors.lightColor,
                                                                    borderRadius: BorderRadius.circular(
                                                                      ResponsiveFlutter.of(context).moderateScale(25),
                                                                    ),
                                                                    border: Border.all(color: appColors.borderColor, width: 1)
                                                                  ),
                                                                  child: commonTestField(
                                                                    textColor: appColors.borderColor,
                                                                    context: context,
                                                                    controller: _phoneController,
                                                                    initial: "+243",
                                                                    hintText: "XXX XXX XXX",
                                                                    keyboardType: TextInputType.phone,
                                                                    inputFormatters: [maskFormatter],
                                                                    icon: true,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Map data = {
                                                                          "phoneNumber": _phoneController.text
                                                                        };
                                                                        //
                                                                      },
                                                                      child: CommonButton(
                                                                        title: "Continuer",
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
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: appColors.appLightColor.withOpacity(.5), width: 1),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          margin: const EdgeInsets.only(bottom: 10),
                                          width: MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.mobile_screen_share_rounded, size: 17,),
                                                  const SizedBox(width: 7,),
                                                  MyTextView(
                                                    "Par mobile money",
                                                    textAligntNew: TextAlign.start,
                                                    maxLineWrap: true,
                                                    styleNew: MyTextStyle(
                                                      colorNew: appColors.black,
                                                      fontWeightNew: FontWeight.w500,
                                                      size: ResponsiveFlutter.of(context).fontSize(1.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: appColors.appLightColor.withOpacity(.5), width: 1),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          margin: const EdgeInsets.only(bottom: 10),
                                          width: MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.credit_card, size: 17,),
                                                  const SizedBox(width: 7,),
                                                  MyTextView(
                                                    "Par carte de crédit",
                                                    textAligntNew: TextAlign.start,
                                                    maxLineWrap: true,
                                                    styleNew: MyTextStyle(
                                                      colorNew: appColors.black,
                                                      fontWeightNew: FontWeight.w500,
                                                      size: ResponsiveFlutter.of(context).fontSize(1.6),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                            ],
                                          ),
                                        ),
                                      ),
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: CommonButton(
                  title: "Payer maintenant",
                ),
              )
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
