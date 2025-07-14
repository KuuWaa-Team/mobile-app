import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';

class PageSlider extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  bool firstPage;
  bool templates;

  Color textColor;
  AppColors appColors = AppColors();

  PageSlider({Key? key,
    required this.title,
    required this.description,
    required this.image,
    this.firstPage = false,
    this.templates = false,
    this.textColor  = Colors.black
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: textColor == Colors.white ? appColors.btnColor: null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (firstPage != true && templates != true)
          Image.asset(image, width: width * 0.5,),
          if (firstPage == true)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: Colors.white,
                boxShadow: [Utils.customShadow()]
              ),
              child: Image.asset(image, width: width * 0.2,),
            ),
          if (templates == true)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: -0.2,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 80,
                    height: 120,
                    decoration: BoxDecoration(
                      image: const DecorationImage(image: AssetImage("assets/on_boarding/temp2.png"), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(color: appColors.btnColor),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 90,
                  height: 130,
                  decoration: BoxDecoration(
                    image: const DecorationImage(image: AssetImage("assets/on_boarding/temp1.png"), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(color: appColors.btnColor),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                Transform.rotate(
                  angle: 0.2,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 80,
                    height: 120,
                    decoration: BoxDecoration(
                      image: const DecorationImage(image: AssetImage("assets/on_boarding/temp3.png"), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(color: appColors.btnColor),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30,),
          MyTextView(
            title,
            textAligntNew: TextAlign.center,
            maxLinesNew: 5,
            styleNew: MyTextStyle(
              colorNew: appColors.lightColor,
              fontWeightNew: FontWeight.w700,
              size: ResponsiveFlutter.of(context).fontSize(3.8),
            ),
          ),
          const SizedBox(height: 20,),
          MyTextView(
            description,
            textAligntNew: TextAlign.center,
            maxLinesNew: 5,
            styleNew: MyTextStyle(
              colorNew: appColors.lightColor.withOpacity(.5),
              size: ResponsiveFlutter.of(context).fontSize(1.9),
            ),
          ),
          if (firstPage)
            const SizedBox(height: 10,),
          if (firstPage)
          MyTextView(
            "Transformez vos événements en expériences inoubliables avec des invitations digitales interactives.",
            textAligntNew: TextAlign.center,
            maxLinesNew: 5,
            styleNew: MyTextStyle(
              colorNew: appColors.lightColor,
              size: ResponsiveFlutter.of(context).fontSize(1.9),
            ),
          ),
          const SizedBox(height: 60,)
        ],
      ),
    );
  }
}
