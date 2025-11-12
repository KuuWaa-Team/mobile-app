import 'package:flutter/material.dart';
import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:shimmer/shimmer.dart';

class EventShimmer extends StatelessWidget {
  final bool rounded;
  const EventShimmer({Key? key, this.rounded = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();

    return Shimmer.fromColors(
      baseColor: appColors.appLightColor.withOpacity(.3),
      highlightColor: appColors.appLightColor!,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveFlutter.of(context).moderateScale(20),
        ),
        height: ResponsiveFlutter.of(context).moderateScale(80),
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
      )
    );
  }
}