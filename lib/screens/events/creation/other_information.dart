import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/model/event/event_specification_model.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';

class OtherInformation extends StatefulWidget {
  final List<EventSpecificationModel> specifications;
  final void Function(EventSpecificationModel) addSpecification;
  final void Function(EventSpecificationModel) removeSpecification;

  const OtherInformation({
    Key? key,
    required this.specifications,
    required this.addSpecification,
    required this.removeSpecification,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OtherInformationState();
}

class _OtherInformationState extends State<OtherInformation> {
  AppColors appColors = AppColors();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveFlutter.of(context).moderateScale(15),
        horizontal: ResponsiveFlutter.of(context).moderateScale(20),
      ),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: MyTextView(
            "Ce menu est optionnel, vous pouvez le passer",
            maxLinesNew: 5,
            styleNew: MyTextStyle(
              colorNew: Colors.orange,
              fontWeightNew: FontWeight.w400,
              size: ResponsiveFlutter.of(context).fontSize(1.4),
            ),
          ),
        ),
        SizedBox(
          height: ResponsiveFlutter.of(context).verticalScale(10),
        ),
        MyTextView(
          "Veuillez ajouter d'autres informations rélatives à votre événement (Dress code, cadeau non embalé,...)",
          maxLinesNew: 5,
          styleNew: MyTextStyle(
            colorNew: appColors.lightColor.withOpacity(.7),
            fontWeightNew: FontWeight.w400,
            size: ResponsiveFlutter.of(context).fontSize(1.5),
          ),
        ),
        SizedBox(
          height: ResponsiveFlutter.of(context).verticalScale(10),
        ),
        Container(
          height: ResponsiveFlutter.of(context)
              .verticalScale(40),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveFlutter.of(context)
                .moderateScale(6),
            horizontal: ResponsiveFlutter.of(context)
                .moderateScale(15),
          ),
          margin: EdgeInsets.only(
              bottom: ResponsiveFlutter.of(context)
                  .moderateScale(10)),
          decoration: BoxDecoration(
            color: appColors.appLightColor,
            borderRadius: BorderRadius.circular(
              ResponsiveFlutter.of(context)
                  .moderateScale(25),
            ),
          ),
          child: commonTestField(
            context: context,
            controller: _controller,
            hintText: "Spécification",
            keyboardType: TextInputType.text,
            icon: true,
          ),
        ),
        GestureDetector(
          onTap: () {
            String text = _controller.text.trim();
            if (text.isNotEmpty) {
              setState(() {
                widget.addSpecification(EventSpecificationModel(name: text));
                _controller.clear();
              });
            }
          },
          child: CommonButton(
            icon: Icons.add,
            btnColor: appColors.black,
            title: "Ajouter",
          ),
        ),
        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(20)),
        ...widget.specifications.map((spec) => Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveFlutter.of(context).moderateScale(10),
            horizontal: ResponsiveFlutter.of(context).moderateScale(15),
          ),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: appColors.appLightColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: appColors.borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyTextView(
                  spec.name.toString(),
                  styleNew: MyTextStyle(
                    colorNew: appColors.lightColor,
                    fontWeightNew: FontWeight.w400,
                    size: ResponsiveFlutter.of(context).fontSize(1.7),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.removeSpecification(spec);
                  });
                },
                child: Icon(Icons.close, color: appColors.btnColor, size: 18,),
              )
            ],
          ),
        )),
      ],
    );
  }
}