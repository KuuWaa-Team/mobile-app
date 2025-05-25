import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:shimmer/shimmer.dart';

class CircleImageShimmer extends StatelessWidget {
  final bool rounded;
  const CircleImageShimmer({Key? key, this.rounded = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();

    return Shimmer.fromColors(
        baseColor: appColors.white.withOpacity(.05),
        highlightColor: appColors.white.withOpacity(.1),
        child: Container(
          width: 55,
          height: 55,
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: appColors.appLightColor,
          ),
        )
    );
  }
}