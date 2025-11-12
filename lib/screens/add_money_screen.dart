import 'package:flutter/services.dart';
import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/add_wallet_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:kuuwaa/view_model/wallet/wallet_view_model.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({Key? key}) : super(key: key);
  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  AppColors appColors = AppColors();
  String? selectedPaymentMethod;
  bool loading = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  WalletViewModel walletViewModel = WalletViewModel();

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

  void showPhoneNumberModal() {
    final _formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: appColors.white,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 5,
                        width: 50,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: appColors.appMediumColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    MyTextView(
                      "Recharge avec mobile money",
                      maxLinesNew: 3,
                      styleNew: MyTextStyle(
                        colorNew: appColors.black,
                        fontWeightNew: FontWeight.bold,
                        size: ResponsiveFlutter.of(context).fontSize(2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextView(
                      "Numéro de téléphone",
                      maxLinesNew: 3,
                      styleNew: MyTextStyle(
                        colorNew: appColors.transactionText,
                        size: ResponsiveFlutter.of(context).fontSize(1.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [Utils.phoneNumberFormatter],
                      decoration: InputDecoration(
                        hintText: "Telephone",
                        filled: true,
                        fillColor: appColors.appLightColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: appColors.btnColor, width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: appColors.borderColor, width: 1),
                        ),
                      ),
                      validator: (value) {
                        final regex = RegExp(r'^\+243 \d{3} \d{3} \d{3}$');
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un numéro';
                        } else if (!regex.hasMatch(value)) {
                          return 'Format invalide. Exemple: +243 970 123 456';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    if (user != null)
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          await walletViewModel.recharge(context, {
                            'amount': amountController.text,
                            'payment_method': selectedPaymentMethod,
                            'phone_number': phoneController.text.replaceAll(' ', '').replaceAll('+', ''),
                            'user_id': user!.id
                          }, user!.id!);
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                      child: CommonButton(
                        context: context,
                        loading: loading,
                        title: "Valider",
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: Column(
        children: [
          commonAppBar(
            context: context,
            backArrow: true,
            title: Strings.addMoney,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveFlutter.of(context).moderateScale(15),
                horizontal: ResponsiveFlutter.of(context).moderateScale(20),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MyTextView(
                      Strings.paymentMethod,
                      textAligntNew: TextAlign.center,
                      styleNew: MyTextStyle(
                        colorNew: appColors.lightColor,
                        fontWeightNew: FontWeight.w600,
                        size: ResponsiveFlutter.of(context).fontSize(2.2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MyTextView(
                  "Montant (USD)",
                  maxLinesNew: 3,
                  styleNew: MyTextStyle(
                    colorNew: appColors.transactionText,
                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Montant",
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appColors.btnColor, width: 1.5),
                    ),
                    fillColor: appColors.appLightColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appColors.borderColor, width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                MyTextView(
                  "5\$ USD = 20 Credit",
                  maxLinesNew: 3,
                  styleNew: MyTextStyle(
                    colorNew: appColors.black,
                    size: ResponsiveFlutter.of(context).fontSize(1.5),
                  ),
                ),
                SizedBox(
                  height: ResponsiveFlutter.of(context).moderateScale(30),
                ),
                MyTextView(
                  "Veuillez choisir un moyen de paiement pour recharger les credits",
                  textAligntNew: TextAlign.left,
                  styleNew: MyTextStyle(
                    colorNew: appColors.transactionText,
                    fontWeightNew: FontWeight.w500,
                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                  ),
                  maxLinesNew: 5,
                ),
                SizedBox(
                  height: ResponsiveFlutter.of(context).moderateScale(10),
                ),
                GestureDetector(
                  onTap: loading ? null : () {
                    setState(() {
                      selectedPaymentMethod = PaymentMethod.mobile;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(20)),
                    decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      border: PaymentMethod.mobile == selectedPaymentMethod ? Border.all(
                        color: appColors.btnColor,
                        width: 2,
                      ) : Border.all(
                        color: appColors.borderColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveFlutter.of(context).moderateScale(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTextView(
                          Strings.mobileMoney,
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.black,
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(2),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveFlutter.of(context).moderateScale(5),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyTextView(
                              "M-Pesa",
                              textAligntNew: TextAlign.center,
                              styleNew: MyTextStyle(
                                colorNew: appColors.transactionText,
                                fontWeightNew: FontWeight.w400,
                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                              ),
                            ),
                            const SizedBox(width: 8,),
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                  color: appColors.black,
                                  shape: BoxShape.circle
                              ),
                            ),
                            const SizedBox(width: 8,),
                            MyTextView(
                              "Orange money",
                              textAligntNew: TextAlign.center,
                              styleNew: MyTextStyle(
                                colorNew: appColors.transactionText,
                                fontWeightNew: FontWeight.w400,
                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                              ),
                            ),
                            const SizedBox(width: 8,),
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                  color: appColors.black,
                                  shape: BoxShape.circle
                              ),
                            ),
                            const SizedBox(width: 8,),
                            MyTextView(
                              "Airtel money",
                              textAligntNew: TextAlign.center,
                              styleNew: MyTextStyle(
                                colorNew: appColors.transactionText,
                                fontWeightNew: FontWeight.w400,
                                size: ResponsiveFlutter.of(context).fontSize(1.5),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveFlutter.of(context).moderateScale(10),
                ),
                GestureDetector(
                  onTap: loading ? null : () {
                    setState(() {
                      selectedPaymentMethod = PaymentMethod.card;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(20)),
                    decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      border: PaymentMethod.card == selectedPaymentMethod ? Border.all(
                        color: appColors.btnColor,
                        width: 2,
                      ) : Border.all(
                        color: appColors.borderColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveFlutter.of(context).moderateScale(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTextView(
                          Strings.cardPayment,
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.black,
                            fontWeightNew: FontWeight.w400,
                            size: ResponsiveFlutter.of(context).fontSize(2),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveFlutter.of(context).moderateScale(5),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImagePath.masterCard,
                              height: ResponsiveFlutter.of(context).moderateScale(25),
                            ),
                            const SizedBox(width: 10,),
                            Image.asset(
                              ImagePath.visa,
                              height: ResponsiveFlutter.of(context).moderateScale(25),
                              width: 50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveFlutter.of(context).moderateScale(20),
                ),
                GestureDetector(
                  onTap: loading ? null : () async {
                    final amount = double.tryParse(amountController.text) ?? 0;

                    if (amount < 5) {
                      _showMinimumAmountModal(context);
                      return;
                    }

                    if (selectedPaymentMethod == PaymentMethod.mobile) {
                      showPhoneNumberModal();
                    } else if (selectedPaymentMethod == PaymentMethod.card) {
                      setState(() {
                        loading = true;
                      });

                      await walletViewModel.recharge(context, {
                        'amount': amountController.text,
                        'payment_method': selectedPaymentMethod,
                        'phone_number': '',
                        'user_id': user!.id,
                      }, user!.id!);

                      setState(() {
                        loading = false;
                      });
                    } else {
                      Utils.flushBarErrorMessage("Veuillez sélectionner un mode de paiement", context);
                    }
                  },
                  child: CommonButton(
                    context: context,
                    title: "Continuer",
                    loading: loading,
                  ),
                ),
                SizedBox(
                  height: ResponsiveFlutter.of(context).moderateScale(15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMinimumAmountModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: appColors.appLightColor,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 40),
              const SizedBox(height: 10),
              Text(
                "Montant insuffisant",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: appColors.darkGreyText,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Le montant minimum pour une recharge est de 5 \$ USD.\nVeuillez ajuster le montant.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: appColors.lightColor.withOpacity(.8),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                label: const Text("OK, compris", style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.btnColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
