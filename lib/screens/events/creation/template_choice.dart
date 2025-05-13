import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';

class TemplateChoice extends StatefulWidget {
  final List<EventTemplateModel> templates;

  const TemplateChoice({
    Key? key,
    required this.templates,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TemplateChoiceState();
}

class _TemplateChoiceState extends State<TemplateChoice> {
  AppColors appColors = AppColors();
  String? selectedCategory;

  // List<String> get categories {
  //   final allCategories = widget.templates.map((t) => t.category).toSet().toList();
  //   allCategories.sort();
  //   return ["Tous", ...allCategories];
  // }

  @override
  Widget build(BuildContext context) {
    var filteredTemplates = selectedCategory == null || selectedCategory == "Tous"
        ? widget.templates
        : widget.templates.where((t) => t.name == selectedCategory).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveFlutter.of(context).moderateScale(20),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 0.67,
        children: filteredTemplates.map((template) {
          return Stack(
            children: [
              Card(
                elevation: 3,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: appColors.white,
                        image: DecorationImage(
                        image: NetworkImage("http://10.100.17.117:8000/images/templates/${template.imagePath}"),fit: BoxFit.cover
                      ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextView(
                            template.name!,
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.black,
                              fontWeightNew: FontWeight.w600,
                              size: ResponsiveFlutter.of(context).fontSize(1.6),
                            ),
                          ),
                          MyTextView(
                            template.price.toString() + " crédits / invitation",
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.btnColor,
                              fontWeightNew: FontWeight.w400,
                              size: ResponsiveFlutter.of(context).fontSize(1.3),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: appColors.black.withOpacity(.5),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.remove_red_eye, color: Colors.white, size: 15,),
                        const SizedBox(width: 5,),
                        MyTextView(
                          "Voir",
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.white,
                            fontWeightNew: FontWeight.w600,
                            size: ResponsiveFlutter.of(context).fontSize(1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        }).toList(),
      ),
    );

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     // Padding(
    //     //   padding: EdgeInsets.only(
    //     //     left: ResponsiveFlutter.of(context).moderateScale(20),
    //     //     right: ResponsiveFlutter.of(context).moderateScale(20),
    //     //     top: ResponsiveFlutter.of(context).moderateScale(10),
    //     //   ),
    //     //   child: DropdownButton<String>(
    //     //     isExpanded: true,
    //     //     dropdownColor: appColors.white,
    //     //     value: selectedCategory ?? "Tous",
    //     //     icon: const Icon(Icons.filter_list_outlined),
    //     //     items: [],
    //     //     // items: categories.map((cat) {
    //     //     //   return DropdownMenuItem(
    //     //     //     value: cat,
    //     //     //     child: Text(cat),
    //     //     //   );
    //     //     // }).toList(),
    //     //     onChanged: (value) {
    //     //       setState(() {
    //     //         selectedCategory = value;
    //     //       });
    //     //     },
    //     //   ),
    //     // ),
    //     Expanded(
    //       child: ,
    //     ),
    //   ],
    // );
  }
}
