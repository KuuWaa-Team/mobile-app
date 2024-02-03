import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/model/common_model.dart';
import 'package:kuuwaa/screens/invitations/invitations_event_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../events/details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  AppColors appColors = AppColors();
  bool? like = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              title: "Mes invitations",
              backArrow: false,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     left : 20,
            //     right : 20,
            //     bottom : 10,
            //   ),
            //   child: CupertinoSearchTextField(
            //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            //     style: TextStyle(
            //         color: appColors.lightColor
            //     ),
            //     placeholder: "Rechercher",
            //     onChanged: (String value) {
            //     },
            //     onSubmitted: (String value) {
            //     },
            //   ),
            // ),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: const InvitationEventScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
