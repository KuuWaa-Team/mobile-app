import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:shimmer/shimmer.dart';

class EventDetailShimmer extends StatelessWidget {
  final bool rounded;
  const EventDetailShimmer({Key? key, this.rounded = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppColors appColors = AppColors();

    return Shimmer.fromColors(
        baseColor: appColors.appLightColor.withOpacity(.3),
        highlightColor: appColors.appLightColor!,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.32,
              decoration: BoxDecoration(
                color: appColors.appMediumColor,
                // borderRadius: BorderRadius.circular(20)
              ),
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: appColors.appMediumColor,
                      // borderRadius: BorderRadius.circular(20)
                    ),
                    width: MediaQuery.of(context).size.width * .6 - 10,
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: appColors.appMediumColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    width: MediaQuery.of(context).size.width * .25 - 10,
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    color: appColors.appMediumColor,
                    borderRadius: BorderRadius.circular(5)
                ),
                width: MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: appColors.appMediumColor,
                    borderRadius: BorderRadius.circular(30)
                ),
                width: MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(height: ResponsiveFlutter.of(context).moderateScale(20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                    color: appColors.appMediumColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        )
    );
  }
}