import 'package:kuuwaa/common/constants.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class MyTextView extends Text {
  final TextAlign? textAligntNew;
  final int? maxLinesNew;
  final TextStyle? styleNew;
  final TextOverflow? overflowText;
  final bool? maxLineWrap;
  final TextDirection? textDirectionNew;
  MyTextView(
    String s, {
    Key? key,
    this.textDirectionNew,
    this.textAligntNew = TextAlign.start,
    this.maxLinesNew = 1,
    this.overflowText = TextOverflow.ellipsis,
    this.maxLineWrap = false,
    this.styleNew,
  }) : assert(maxLinesNew != null),
        super(
          s,
          key: key,
          textAlign: textAligntNew,
          maxLines: maxLineWrap! ? null : maxLinesNew,
          overflow: maxLineWrap ? null : overflowText,
          style: styleNew,
          textDirection: textDirectionNew,
        );
}

class MyTextStyle extends TextStyle {
  final Color? colorNew;
  final FontWeight? fontWeightNew;
  final double? size;
  final String? fontFamilyNew;
  final TextDecoration? decorationNew;
  final Paint? backGround;
  final double? letterSpacingNew;
  final double? textHeight;
  const MyTextStyle({
    this.textHeight,
    this.colorNew = Colors.black,
    this.fontWeightNew = FontWeight.normal,
    this.size = 14,
    this.fontFamilyNew = Constants.carosSoft,
    this.decorationNew = TextDecoration.none,
    this.backGround,
    this.letterSpacingNew = 0.0,
  })  : assert(colorNew != null && fontWeightNew != null),
        super(
          color: colorNew,
          fontWeight: fontWeightNew,
          fontSize: size,
          fontFamily: fontFamilyNew,
          decoration: decorationNew,
          background: backGround,
          letterSpacing: letterSpacingNew,
          height: textHeight,
        );
}

Widget commonTestField({
  BuildContext? context,
  bool? icon = false,
  String? image = "",
  String? initial = "",
  String? hintText,
  Color? textColor,
  bool? obscureText = false,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
  TextEditingController? controller,
}) {
  AppColors appColors = AppColors();
  return Row(
    children: [
      Visibility(
        visible: icon!,
        child: Container(
          height: ResponsiveFlutter.of(context).verticalScale(17),
          margin: EdgeInsets.only(right: ResponsiveFlutter.of(context).scale(10)),
          alignment: Alignment.center,
          child: image != null && image != "" ? Image.asset(
            image,
            color: appColors.iconColor,
          ) : (
            initial != null && initial != "" ? MyTextView(initial, styleNew: MyTextStyle(
              colorNew: textColor ?? appColors.lightColor.withOpacity(.5),
              fontWeightNew: FontWeight.w500,
              size: ResponsiveFlutter.of(context).fontSize(1.9),
            ),) : null
          ),
        ),
      ),
      Expanded(
        child: TextField(
          style: MyTextStyle(
            colorNew: textColor ?? appColors.lightColor,
            fontWeightNew: FontWeight.w500,
            size: ResponsiveFlutter.of(context).fontSize(1.9),
          ),
          obscureText: obscureText!,
          cursorColor: textColor ?? appColors.lightColor,
          keyboardType: keyboardType,
          controller: controller,
          inputFormatters: inputFormatters,
          scrollPadding: EdgeInsets.zero,
          expands: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            isDense: true,
            hintStyle: MyTextStyle(
              colorNew: textColor ?? appColors.mediumLightColor,
              fontWeightNew: FontWeight.w400,
              size: ResponsiveFlutter.of(context).fontSize(1.9),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget commonAppBar({
  BuildContext? context,
  String? title,
  bool? backArrow = false,
  bool? edit = false,
  bool? theme = false,
  Color? appBarColor,
  GestureTapCallback? backClick,
  GestureTapCallback? editClick,
  GestureTapCallback? themeClick,
}) {
  AppColors appColors = AppColors();
  ImagePath imagePath = ImagePath();
  return Container(
    height: AppBar().preferredSize.height + MediaQuery.of(context!).padding.top,
    width: double.infinity,
    padding: EdgeInsets.only(
      bottom: ResponsiveFlutter.of(context).moderateScale(20),
      left: ResponsiveFlutter.of(context).moderateScale(20),
      right: ResponsiveFlutter.of(context).moderateScale(20),
    ),
    decoration: BoxDecoration(
      color: appBarColor ?? appColors.appMediumColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(ResponsiveFlutter.of(context).moderateScale(30)),
        bottomRight: Radius.circular(ResponsiveFlutter.of(context).moderateScale(30)),
      ),
    ),
    alignment: Alignment.bottomCenter,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: backArrow!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: backClick ?? () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: ResponsiveFlutter.of(context).moderateScale(30),
                  width: ResponsiveFlutter.of(context).moderateScale(30),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: appColors.lightColor,
                    size: ResponsiveFlutter.of(context).moderateScale(20),
                  ),
                ),
              ),
              const Spacer(),
              Visibility(
                visible: edit!,
                child: GestureDetector(
                  onTap: editClick,
                  child: Container(
                    height: ResponsiveFlutter.of(context).moderateScale(25),
                    width: ResponsiveFlutter.of(context).moderateScale(25),
                    padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(2)),
                    child: Image.asset(imagePath.edit),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: theme!,
              child: GestureDetector(
                onTap: themeClick,
                child: Container(
                  height: ResponsiveFlutter.of(context).moderateScale(25),
                  width: ResponsiveFlutter.of(context).moderateScale(25),
                  padding: EdgeInsets.all(ResponsiveFlutter.of(context).moderateScale(2)),
                  child: Constants.darkTheme
                      ? Icon(
                          Icons.light_mode,
                          color: appColors.lightColor,
                        )
                      : Icon(
                          Icons.dark_mode,
                          color: appColors.lightColor,
                        ),
                ),
              ),
            ),
          ],
        ),
        MyTextView(
          title!.toUpperCase(),
          textAligntNew: TextAlign.center,
          styleNew: MyTextStyle(
            colorNew: appColors.lightColor,
            fontWeightNew: FontWeight.w600,
            size: ResponsiveFlutter.of(context).fontSize(2),
          ),
        ),
      ],
    ),
  );
}

Widget commonOtpFields({
  BuildContext? context,
  TextEditingController? otpController,
}) {
  AppColors appColors = AppColors();

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(
      5,
          (index) => Container(
        width: ResponsiveFlutter.of(context).scale(40),
        height: ResponsiveFlutter.of(context).verticalScale(40),
        decoration: BoxDecoration(
          border: Border.all(
            color: appColors.lightColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: MyTextStyle(
            colorNew: appColors.lightColor,
            fontWeightNew: FontWeight.w500,
            size: ResponsiveFlutter.of(context).fontSize(1.9),
          ),
          cursorColor: appColors.lightColor,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            counterText: "",
            border: InputBorder.none,
            isDense: true,
            hintStyle: MyTextStyle(
              colorNew: appColors.mediumLightColor,
              fontWeightNew: FontWeight.w400,
              size: ResponsiveFlutter.of(context).fontSize(1.9),
            ),
          ),
        ),
      ),
    ),
  );
}
