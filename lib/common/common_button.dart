import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';

class CommonButton extends StatefulWidget {
  BuildContext? context;
  String? title;
  Color? btnColor;
  Color? textColor;
  bool? loading;
  EdgeInsetsGeometry? padding;

  CommonButton({
    Key? key,
    this.context,
    this.btnColor,
    this.padding,
    this.loading,
    this.title,
    this.textColor,
  }) : super(key: key);

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      height: ResponsiveFlutter.of(context).scale(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.btnColor ?? appColors.btnColor,
        borderRadius: BorderRadius.circular(
          ResponsiveFlutter.of(context).moderateScale(30),
        ),
      ),
      child: widget.loading == true ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: appColors.lightColor.withOpacity(.4),
          strokeWidth: 2,
        ),
      ) :  MyTextView(
        widget.title!,
        textAligntNew: TextAlign.center,
        styleNew: MyTextStyle(
          colorNew: widget.textColor ?? appColors.white,
          fontWeightNew: FontWeight.w600,
          size: ResponsiveFlutter.of(context).fontSize(2),
        ),
      ),
    );
  }
}