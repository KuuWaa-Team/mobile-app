import 'package:flutter/services.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/invitation/invitation_model.dart';
import 'package:kuuwaa/model/table/table_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/events/payment_screen.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/invitation/invitation_view_model.dart';
import 'package:kuuwaa/view_model/table/table_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicListScreen extends StatefulWidget {
  EventModel event;
  MusicListScreen({Key? key, required this.event}) : super(key: key);

  @override
  _MusicListScreenState createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  AppColors appColors = AppColors();
  InvitationViewModel invitationViewModel = InvitationViewModel();

  bool loading = false;
  bool editing = false;
  bool sending = false;

  bool sendingAllSMS = false;
  bool sendingAllWpp = false;
  bool sendingSMS = false;
  bool sendingWpp = false;
  bool copying = false;

  Set<int> playedMusicIds = {};

  @override
  void initState() {
    invitationViewModel.listingApi(context, widget.event.id!, withMusicRequest: true);
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
              title: "Demandes musicales",
              backArrow: true,
            ),
            ChangeNotifierProvider<InvitationViewModel>(
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
                          List<InvitationModel> allInvites = value.invitationsList.data!
                              .where((i) => i.musicChoice != null && i.musicChoice!.trim().isNotEmpty)
                              .toList();

                          for (InvitationModel invite in allInvites) {
                            if (invite.musicPlayed == true) {
                              playedMusicIds.add(invite.id!);
                            }
                          }

                          List<InvitationModel> notPlayed = allInvites.where((i) => !playedMusicIds.contains(i.id)).toList();
                          List<InvitationModel> played = allInvites.where((i) => playedMusicIds.contains(i.id)).toList();

                          if (allInvites.isEmpty) {
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
                                    "Aucun choix musical",
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
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: ResponsiveFlutter.of(context).scale(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20,),
                                    ListView.builder(
                                      itemCount: notPlayed.length,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(bottom: 10),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final invitation = notPlayed[index];
                                        return musicItem(invitation, false);
                                      },
                                    ),

                                    if (played.isNotEmpty) ...[
                                      Text(
                                        "Déjà jouées",
                                        style: TextStyle(
                                          fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                                          fontWeight: FontWeight.bold,
                                          color: appColors.lightColor,
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      ListView.builder(
                                        itemCount: played.length,
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final invitation = played[index];
                                          return musicItem(invitation, true);
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
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

  Widget musicItem(InvitationModel invitation, bool isPlayed) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(8)),
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      decoration: BoxDecoration(
        color: isPlayed ? appColors.btnColor.withOpacity(.2) : appColors.appLightColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: isPlayed,
                onChanged: (_) {
                  setState(() {
                    if (isPlayed) {
                      invitationViewModel.playMusic(context, invitation.slug.toString(), unPlay: true);
                      playedMusicIds.remove(invitation.id);
                    } else {
                      invitationViewModel.playMusic(context, invitation.slug.toString());
                      playedMusicIds.add(invitation.id!);
                    }
                  });
                },
                activeColor: appColors.btnColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invitation.musicChoice ?? "",
                    style: TextStyle(
                      color: appColors.lightColor,
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.5),
                      fontWeight: FontWeight.w600,
                      decoration: isPlayed ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${invitation.civility ?? ""} ${invitation.name ?? ""}",
                    style: TextStyle(
                      color: appColors.lightColor.withOpacity(0.5),
                      fontSize: ResponsiveFlutter.of(context).fontSize(1.2),
                      decoration: isPlayed ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

}