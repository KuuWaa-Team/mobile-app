import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/auth/auth_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class DeletedAccountScreen extends StatefulWidget {
  DateTime deletedAt;
  int id;
  DeletedAccountScreen({Key? key, required this.id, required this.deletedAt}) : super(key: key);

  @override
  _DeletedAccountScreenState createState() => _DeletedAccountScreenState();
}

class _DeletedAccountScreenState extends State<DeletedAccountScreen> {
  AppColors appColors = AppColors();
  bool loading = false;
  AuthViewModel authViewModel = AuthViewModel();

  @override
  void initState() {
    UserViewModel().remove();
    super.initState();
  }

  int daysUntilPermanentDeletion(DateTime deletedAt) {
    final now = DateTime.now();
    final deletionDeadline = deletedAt.add(const Duration(days: 10));
    final remaining = deletionDeadline.difference(now).inDays;
    return remaining < 0 ? 0 : remaining;
  }

  @override
  Widget build(BuildContext context) {
    final deletedAtFormatted = DateFormat("dd/MM/yyyy 'à' HH:mm").format(widget.deletedAt);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFFDF2F8),
        systemNavigationBarDividerColor: Color(0xFFFDF2F8),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE6E6FA),
                  Color(0xFFFDF2F8),
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/remove.png",
                  height: ResponsiveFlutter.of(context).moderateScale(200),
                ),
                SizedBox(height: ResponsiveFlutter.of(context).moderateScale(40)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      MyTextView(
                        "Suppression du compte en cours",
                        textAligntNew: TextAlign.center,
                        maxLineWrap: true,
                        styleNew: MyTextStyle(
                          colorNew: appColors.btnColor,
                          fontWeightNew: FontWeight.w600,
                          size: ResponsiveFlutter.of(context).fontSize(3.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      MyTextView("Une demande de suppression de votre compte a été faite le $deletedAtFormatted.",
                        textAligntNew: TextAlign.center,
                        maxLineWrap: true,
                        styleNew: MyTextStyle(
                          colorNew: appColors.black.withOpacity(.5),
                          size: ResponsiveFlutter.of(context).fontSize(1.9),
                        ),
                      ),
                      Divider(),
                      MyTextView("Votre compte sera supprimé définitivement dans ${daysUntilPermanentDeletion(widget.deletedAt) + 1} jours, à moins que vous décidiez de le récupérer d'ici là.",
                        textAligntNew: TextAlign.center,
                        maxLineWrap: true,
                        styleNew: MyTextStyle(
                          colorNew: appColors.black.withOpacity(.7),
                          fontWeightNew: FontWeight.w600,
                          size: ResponsiveFlutter.of(context).fontSize(1.9),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveFlutter.of(context).moderateScale(35)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveFlutter.of(context).moderateScale(80),
                  ),
                  child: GestureDetector(
                    onTap: loading ? null : () {
                      setState(() {
                        loading = true;
                      });
                      authViewModel.restoreApi(context, widget.id);
                    },
                    child: CommonButton(
                      loading: loading,
                      context: context,
                      title: "Récupérer mon compte",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
