import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/common_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/invitation/invitation_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/details_screen.dart';
import 'package:kuuwaa/screens/invitations/invitation_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/circle_image_shimmer.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/event/event_view_model.dart';
import 'package:kuuwaa/view_model/invitation/invitation_view_model.dart';
import 'package:provider/provider.dart';

class InvitationEventScreen extends StatefulWidget {
  const InvitationEventScreen({Key? key}) : super(key: key);
  @override
  _InvitationEventScreenState createState() => _InvitationEventScreenState();
}

class _InvitationEventScreenState extends State<InvitationEventScreen> {
  AppColors appColors = AppColors();
  InvitationViewModel invitationViewModel = InvitationViewModel();

  @override
  void initState() {
    invitationViewModel.myInvitationsListingApi(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: ChangeNotifierProvider<InvitationViewModel>(
            create: (BuildContext context) => invitationViewModel,
            child: Consumer<InvitationViewModel>(
                builder: (context, value, _) {
                  switch (value.invitationsList.status) {
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
                        child: Text(value.invitationsList.message.toString()),
                      );
                    case Status.COMPLETED:
                      List<InvitationModel> invitations = value.invitationsList.data;
                      if (invitations.isEmpty) {
                        return Container(
                          decoration: BoxDecoration(
                              color: appColors.appLightColor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          margin: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.block_outlined, color: appColors.lightColor.withOpacity(.2),),
                              const SizedBox(width: 10,),
                              MyTextView(
                                "Vous n'avez aucune invitation",
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
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              itemCount: invitations.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                vertical: ResponsiveFlutter.of(context).moderateScale(15),
                              ),
                              itemBuilder: (context, index) {
                                InvitationModel current = invitations[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InvitationDetailsScreen(id: current.id!,),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveFlutter.of(context).moderateScale(17),
                                      vertical: ResponsiveFlutter.of(context).moderateScale(15),
                                    ),
                                    decoration: BoxDecoration(
                                      color: appColors.appLightColor,
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveFlutter.of(context).moderateScale(15),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Stack(
                                                children: [
                                                  CircleImageShimmer(),
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    margin: const EdgeInsets.only(right: 15),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: Image.network(
                                                        AppUrl.domainName + current.event!.imagePath.toString(),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          MyTextView(
                                                            current.event!.name.toString(),
                                                            textAligntNew: TextAlign.start,
                                                            maxLineWrap: true,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.lightColor,
                                                              fontWeightNew: FontWeight.w600,
                                                              size: ResponsiveFlutter.of(context).fontSize(2),
                                                            ),
                                                          ),
                                                          MyTextView(
                                                            current.event!.category!.name.toString(),
                                                            textAligntNew: TextAlign.start,
                                                            maxLineWrap: true,
                                                            styleNew: MyTextStyle(
                                                              colorNew: Colors.orange.withOpacity(.4),
                                                              fontWeightNew: FontWeight.w400,
                                                              size: ResponsiveFlutter.of(context).fontSize(1.4),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        ImagePath.calender,
                                                        color: appColors.lightColor.withOpacity(.5),
                                                        height: ResponsiveFlutter.of(context).moderateScale(14),
                                                      ),
                                                      SizedBox(
                                                        width: ResponsiveFlutter.of(context).moderateScale(6),
                                                      ),
                                                      MyTextView(
                                                        DateFormat('dd MMM, yyyy').format(current.event!.date!),
                                                        textAligntNew: TextAlign.start,
                                                        maxLineWrap: true,
                                                        styleNew: MyTextStyle(
                                                          colorNew: appColors.lightColor.withOpacity(.5),
                                                          fontWeightNew: FontWeight.w500,
                                                          size: ResponsiveFlutter.of(context).fontSize(1.4),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: ResponsiveFlutter.of(context).moderateScale(10),
                                                      ),
                                                      Image.asset(
                                                        ImagePath.time,
                                                        color: appColors.lightColor.withOpacity(.5),
                                                        height: ResponsiveFlutter.of(context).moderateScale(14),
                                                      ),
                                                      SizedBox(
                                                        width: ResponsiveFlutter.of(context).moderateScale(6),
                                                      ),
                                                      MyTextView(
                                                        DateFormat('kk:mm').format(current.event!.date!),
                                                        textAligntNew: TextAlign.start,
                                                        maxLineWrap: true,
                                                        styleNew: MyTextStyle(
                                                          colorNew: appColors.lightColor.withOpacity(.5),
                                                          fontWeightNew: FontWeight.w500,
                                                          size: ResponsiveFlutter.of(context).fontSize(1.4),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: ResponsiveFlutter.of(context).moderateScale(10),
                                                      ),
                                                      SizedBox(
                                                        width: ResponsiveFlutter.of(context).moderateScale(6),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: ResponsiveFlutter.of(context).moderateScale(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveFlutter.of(context).verticalScale(65),
                          ),
                        ],
                      );
                  }
                }
            )
        )
      ),
    );
  }
}
