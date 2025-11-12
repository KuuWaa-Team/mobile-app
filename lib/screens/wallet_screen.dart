import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/model/common_model.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/add_money_screen.dart';
import 'package:kuuwaa/screens/wallet/my_operations_list_screen.dart';
import 'package:kuuwaa/screens/withdraw_money_screen.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  AppColors appColors = AppColors();
  UserModel? user;

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
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
bottom: !Platform.isIOS,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + ResponsiveFlutter.of(context).moderateScale(75),
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                    vertical: ResponsiveFlutter.of(context).moderateScale(15),
                  ),
                  decoration: BoxDecoration(
                    color: appColors.btnColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(ResponsiveFlutter.of(context).moderateScale(30)),
                      bottomRight: Radius.circular(ResponsiveFlutter.of(context).moderateScale(30)),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: appColors.white.withOpacity(.1)
                              ),
                              child: Row(
                                  children: [
                                    Image.asset("assets/icon/coins.png", width: 25,),
                                    const SizedBox(width: 5,),
                                    if (user != null)
                                    MyTextView(
                                      user!.credits == null ? '0' : user!.credits.toString(),
                                      textAligntNew: TextAlign.start,
                                      maxLineWrap: true,
                                      styleNew: MyTextStyle(
                                        colorNew: appColors.white,
                                        fontWeightNew: FontWeight.w600,
                                        size: ResponsiveFlutter.of(context).fontSize(2),
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddMoneyScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: ResponsiveFlutter.of(context).moderateScale(45),
                          padding: EdgeInsets.symmetric(vertical: ResponsiveFlutter.of(context).moderateScale(5), horizontal: 15),
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            children: [
                              Image.asset(ImagePath.add),
                              const SizedBox(width: 10,),
                              MyTextView(
                                "Recharger",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.black,
                                  fontWeightNew: FontWeight.w500,
                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                commonAppBar(
                  title: Strings.wallet,
                  context: context,
                  backArrow: false,
                ),
              ],
            ),
            SizedBox(
              height: ResponsiveFlutter.of(context).verticalScale(10),
            ),
            MyTextView(
              Strings.transactions,
              textAligntNew: TextAlign.start,
              styleNew: MyTextStyle(
                colorNew: appColors.lightColor,
                fontWeightNew: FontWeight.w500,
                size: ResponsiveFlutter.of(context).fontSize(2.5),
              ),
            ),
            SizedBox(
              height: ResponsiveFlutter.of(context).verticalScale(10),
            ),
            const Expanded(
              child: MyOperationsListScreen(),
            ),
            SizedBox(
              height: ResponsiveFlutter.of(context).verticalScale(70),
            ),
          ],
        ),
      ),
    );
  }
}
