import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/settings/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppColors appColors = AppColors();
  TabController? tabController;
  int tab = 0;
  UserModel user = UserModel();

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      print(value);
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

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
              //backArrow: true,
              title: Strings.profile,
              appBarColor: appColors.appDarkColor,
              edit: true,
              editClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveFlutter.of(context).moderateScale(20),
                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(ResponsiveFlutter.of(context).moderateScale(30)),
                  bottomRight: Radius.circular(ResponsiveFlutter.of(context).moderateScale(30)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircularProfileAvatar( //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                    user.photoUrl.toString()
                    ,radius: 50, // sets radius, default 50.0
                    backgroundColor: appColors.btnColor, // sets background color, default Colors.white
                    initialsText: Text(
                      user.displayName.toString()[0] + "" + user.displayName.toString()[1],
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),  // sets initials text, set your own style, default Text('')
                    borderColor: Colors.brown, // sets border color, default Colors.white
                    elevation: 5.0, // sets elevation (shadow of the profile picture), default value is 0.0
                    foregroundColor: Colors.brown, //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                    cacheImage: true, // allow widget to cache image against provided url
                    imageFit: BoxFit.cover,
                    onTap: () {
                      print('adil');
                    }, // sets on tap
                    showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).moderateScale(10),
                  ),
                  MyTextView(
                    user.displayName.toString(),
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w600,
                      size: ResponsiveFlutter.of(context).fontSize(2.6),
                    ),
                  ),
                  MyTextView(
                    user.email.toString(),
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor.withOpacity(.5),
                      fontWeightNew: FontWeight.w400,
                      size: ResponsiveFlutter.of(context).fontSize(1.7),
                    ),
                  ),
                  // SizedBox(
                  //   height: ResponsiveFlutter.of(context).moderateScale(15),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const EditProfileScreen(),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: appColors.btnColor,
                  //       borderRadius: BorderRadius.circular(5)
                  //     ),
                  //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  //     child: const Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(Icons.edit, size: 15, color: Colors.white,),
                  //         SizedBox(width: 5,),
                  //         Text(
                  //           "Modifier",
                  //           style: TextStyle(
                  //             fontSize: 13,
                  //             color: Colors.white
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
