import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/eventAdmin/event_admin_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SharedEventInvitationScreen extends StatefulWidget {
  EventModel event;
  SharedEventInvitationScreen({Key? key, required this.event}) : super(key: key);

  @override
  _SharedEventInvitationScreenState createState() => _SharedEventInvitationScreenState();
}

class _SharedEventInvitationScreenState extends State<SharedEventInvitationScreen> {
  AppColors appColors = AppColors();

  EventAdminViewModel eventAdminViewModel = EventAdminViewModel();

  bool loading = false;
  bool loadingAccept = false;
  bool loadingRefuse = false;

  var maskFormatter = MaskTextInputFormatter(
      mask: '### ### ###',
      filter: { "#": RegExp(r'\d') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              commonAppBar(
                context: context,
                title: "Invitation protocoleur",
                backArrow: true,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  image: DecorationImage(
                    image: NetworkImage(
                      AppUrl.domainName + widget.event.imagePath.toString(),
                    ),
                    fit: BoxFit.cover
                  )
                ),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 20
                ),
                width: 200,
                height: 200,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              ),
              const SizedBox(height: 40,),
              MyTextView(
                widget.event.title.toString(),
                textAligntNew: TextAlign.start,
                maxLineWrap: true,
                styleNew: MyTextStyle(
                  colorNew: appColors.lightColor,
                  fontWeightNew: FontWeight.w600,
                  size: ResponsiveFlutter.of(context).fontSize(2.2),
                ),
              ),
              SizedBox(height: ResponsiveFlutter.of(context).moderateScale(10)),
              Container(
                height: ResponsiveFlutter.of(context).moderateScale(30),
                width: ResponsiveFlutter.of(context).moderateScale(120),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appColors.blurBtnColor,
                  borderRadius: BorderRadius.circular(
                    ResponsiveFlutter.of(context).moderateScale(20),
                  ),
                ),
                child: MyTextView(
                  widget.event.category!.name.toString(),
                  textAligntNew: TextAlign.center,
                  maxLineWrap: true,
                  styleNew: MyTextStyle(
                    colorNew: appColors.lightPinkColor,
                    fontWeightNew: FontWeight.w500,
                    size: ResponsiveFlutter.of(context).fontSize(1.2),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveFlutter.of(context).moderateScale(40)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagePath.calender,
                    color: appColors.lightColor,
                    height: ResponsiveFlutter.of(context).moderateScale(15),
                  ),
                  SizedBox(width: ResponsiveFlutter.of(context).moderateScale(8)),
                  MyTextView(
                    DateFormat('dd MMM, yyyy').format(widget.event.startDate!),
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(1.6),
                    ),
                  ),
                  SizedBox(width: ResponsiveFlutter.of(context).moderateScale(20)),
                  Image.asset(
                    ImagePath.time,
                    color: appColors.lightColor,
                    height: ResponsiveFlutter.of(context).moderateScale(15),
                  ),
                  SizedBox(width: ResponsiveFlutter.of(context).moderateScale(8)),
                  MyTextView(
                    DateFormat('kk:mm').format(widget.event.startDate!),
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(1.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: MyTextView(
                  "Vous êtes invité à servir comme protocoleur à cet évenement. Vous avez le choix d'accepter ou de réfuser.",
                  maxLinesNew: 10,
                  textAligntNew: TextAlign.center,
                  styleNew: MyTextStyle(
                    colorNew: appColors.lightColor.withOpacity(.5),
                    fontWeightNew: FontWeight.w400,
                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              GestureDetector(
                  onTap: () async {
                    setState(() {
                      loadingAccept = true;
                    });
                    eventAdminViewModel.acceptInvitationApi(context, {}, widget.event.adminId!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: CommonButton(
                      loading: loadingAccept,
                      title: "Accepter l'invitation",
                    ),
                  )
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: ()  {
                  setState(() {
                    loadingRefuse = true;
                  });
                  eventAdminViewModel.refuseInvitationApi(context, {}, widget.event.adminId!);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: CommonButton(
                    textColor: appColors.lightColor,
                    btnColor: appColors.appLightColor,
                    loading: loadingRefuse,
                    title: "Réfuser l'invitation",
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}