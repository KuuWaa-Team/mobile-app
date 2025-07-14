import 'package:flutter/cupertino.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/model/wallet/operation_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:kuuwaa/view_model/wallet/wallet_view_model.dart';
import 'package:provider/provider.dart';

class MyOperationsListScreen extends StatefulWidget {
  const MyOperationsListScreen({Key? key}) : super(key: key);
  @override
  _MyOperationsListScreenState createState() => _MyOperationsListScreenState();
}

class _MyOperationsListScreenState extends State<MyOperationsListScreen> {
  AppColors appColors = AppColors();
  bool fetched = false;
  WalletViewModel walletViewModel = WalletViewModel();
  UserModel user = UserModel();

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });

      if (!fetched && user.id != null) {
        walletViewModel.operations(context, user.id!);
        setState(() {
          fetched = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      _showCreditsInfoDialog();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: ChangeNotifierProvider<WalletViewModel>(
            create: (BuildContext context) => walletViewModel,
            child: Consumer<WalletViewModel>(
                builder: (context, value, _) {
                  switch (value.operationsList.status) {
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
                        child: Text(value.operationsList.message.toString()),
                      );
                    case Status.COMPLETED:
                      List<OperationModel>? operations = value.operationsList.data?.reversed.toList();
                      if (operations == null || operations.isEmpty) {
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
                                "Vous n'avez aucune opération",
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ListView.separated(
                          itemCount: operations.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            OperationModel operation = operations[index];
                            return SizedBox(
                              height: ResponsiveFlutter.of(context).moderateScale(50),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  operation.type == OperationType.recharge ? Container(
                                    height: ResponsiveFlutter.of(context).moderateScale(50),
                                    width: ResponsiveFlutter.of(context).moderateScale(50),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1.5,
                                        color: operation.status == OperationStatus.paid ? appColors.greenOpacity :
                                          (operation.status == OperationStatus.waiting ? Colors.orange.withOpacity(.5) : Colors.red.withOpacity(.5)),
                                      ),
                                    ),
                                    child: operation.status == OperationStatus.paid ?
                                    Image.asset(
                                      ImagePath.greenUp,
                                      height: ResponsiveFlutter.of(context).moderateScale(8),
                                    ) :
                                    (operation.status == OperationStatus.waiting ? const Icon(Icons.refresh, color: Colors.orange,) : const Icon(CupertinoIcons.xmark, color: Colors.red,)),
                                  )
                                      : Container(
                                    height: ResponsiveFlutter.of(context).moderateScale(50),
                                    width: ResponsiveFlutter.of(context).moderateScale(50),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1.5,
                                        color: appColors.redOpacity,
                                      ),
                                    ),
                                    child: Image.asset(
                                      ImagePath.redDown,
                                      height: ResponsiveFlutter.of(context).moderateScale(8),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: ResponsiveFlutter.of(context).moderateScale(15),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          MyTextView(
                                            operation.title.toString(),
                                            textAligntNew: TextAlign.start,
                                            styleNew: MyTextStyle(
                                              colorNew: appColors.lightColor,
                                              fontWeightNew: FontWeight.w500,
                                              size: ResponsiveFlutter.of(context).fontSize(2.1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: ResponsiveFlutter.of(context).moderateScale(2),
                                      ),
                                      Row(
                                        children: [
                                          MyTextView(
                                            "#",
                                            textAligntNew: TextAlign.start,
                                            styleNew: MyTextStyle(
                                              colorNew: appColors.black,
                                              fontWeightNew: FontWeight.w400,
                                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                                            ),
                                          ),
                                          MyTextView(
                                            operation.reference.toString(),
                                            textAligntNew: TextAlign.start,
                                            styleNew: MyTextStyle(
                                              colorNew: appColors.transactionText,
                                              fontWeightNew: FontWeight.w400,
                                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      MyTextView(
                                        operation.amount.toString() + "\$",
                                        textAligntNew: TextAlign.start,
                                        styleNew: MyTextStyle(
                                          colorNew: operation.type == OperationType.recharge ? appColors.greenText : appColors.redText,
                                          fontWeightNew: FontWeight.w500,
                                          size: ResponsiveFlutter.of(context).fontSize(2.2),
                                        ),
                                      ),
                                      SizedBox(
                                        height: ResponsiveFlutter.of(context).moderateScale(2),
                                      ),
                                      // MyTextView(
                                      //   operation.date.toString(),
                                      //   textAligntNew: TextAlign.start,
                                      //   styleNew: MyTextStyle(
                                      //     colorNew: appColors.transactionText,
                                      //     fontWeightNew: FontWeight.w400,
                                      //     size: ResponsiveFlutter.of(context).fontSize(1.4),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: ResponsiveFlutter.of(context).verticalScale(15),
                            );
                          },
                        ),
                      );
                  }
                }
            )
        ),
      ),
    );
  }
  void _showCreditsInfoDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColors.appLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          title: Column(
            children: [
              Icon(Icons.info_outline_rounded, size: 30, color: appColors.appMediumColorDark),
              const SizedBox(height: 5),
              MyTextView(
                "À propos des crédits",
                textAligntNew: TextAlign.center,
                maxLinesNew: 5,
                styleNew: MyTextStyle(
                  colorNew: appColors.lightColor,
                  fontWeightNew: FontWeight.w700,
                  size: ResponsiveFlutter.of(context).fontSize(3.5),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              MyTextView(
                "Les crédits permettent de partager les invitations électroniques.",
                textAligntNew: TextAlign.left,
                maxLinesNew: 5,
                styleNew: MyTextStyle(
                  colorNew: appColors.appMediumColorDark,
                  fontWeightNew: FontWeight.w600,
                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                ),
              ),
              const SizedBox(height: 10),
              MyTextView(
                "Chaque template de design a un prix en crédit par invitation (1 crédit pour le moins coûteux).",
                textAligntNew: TextAlign.left,
                maxLinesNew: 10,
                styleNew: MyTextStyle(
                  colorNew: appColors.appMediumColorDark.withOpacity(0.8),
                  fontWeightNew: FontWeight.w500,
                  size: ResponsiveFlutter.of(context).fontSize(1.7),
                ),
              ),
              const SizedBox(height: 10),
              MyTextView(
                "5 \$ = 20 crédits",
                textAligntNew: TextAlign.left,
                styleNew: MyTextStyle(
                  colorNew: appColors.btnColor,
                  fontWeightNew: FontWeight.w700,
                  size: ResponsiveFlutter.of(context).fontSize(3.5),
                ),
              ),
              const SizedBox(height: 15),
              MyTextView(
                "La recharge peut se faire via Mobile Money ou carte de crédit.",
                textAligntNew: TextAlign.left,
                maxLinesNew: 10,
                styleNew: MyTextStyle(
                  colorNew: appColors.appMediumColorDark.withOpacity(0.8),
                  fontWeightNew: FontWeight.w500,
                  size: ResponsiveFlutter.of(context).fontSize(1.7),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Compris",
                style: TextStyle(color: appColors.btnColor, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

}
