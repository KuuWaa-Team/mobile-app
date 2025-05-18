import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/template_preview_page.dart';

class TemplateChoice extends StatefulWidget {
  final List<EventTemplateModel> templates;
  EventTemplateModel? eventTemplateModel;
  void Function(EventTemplateModel) changeTemplate;
  final File? imageFile;
  final EventCategoryModel selectedCategory;
  final TextEditingController detailsController;
  final TextEditingController titleController;
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController addressController;
  final TextEditingController placeNameController;

  TemplateChoice({
    Key? key,
    required this.eventTemplateModel,
    required this.changeTemplate,
    required this.templates,
    required this.selectedCategory,
    required this.detailsController,
    required this.imageFile,
    required this.titleController,
    required this.startDate,
    required this.endDate,
    required this.addressController,
    required this.placeNameController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TemplateChoiceState();
}

class _TemplateChoiceState extends State<TemplateChoice> {
  AppColors appColors = AppColors();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    var filteredTemplates = selectedCategory == null || selectedCategory == "Tous"
        ? widget.templates
        : widget.templates.where((t) => t.name == selectedCategory).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveFlutter.of(context).moderateScale(20),
      ),
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.67,
              children: filteredTemplates.map((template) {
                final isSelected = widget.eventTemplateModel?.id == template.id;

                return Stack(
                  children: [
                    Card(
                      elevation: 3,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? appColors.btnColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: appColors.white,
                              image: DecorationImage(
                                image: NetworkImage(AppUrl.domainName + "/images/templates/${template.imagePath}"),
                                fit: BoxFit.cover,
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
                                  "${template.price} crédits / invitation",
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
                        GestureDetector(
                          onTap: () async {
                            final selected = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TemplatePreviewPage(template: template, data: {
                                  "title": widget.titleController.text,
                                  "address": widget.addressController.text,
                                  "placeName": widget.placeNameController.text,
                                  "details": widget.detailsController.text,
                                  "category_id": widget.selectedCategory.id,
                                  "start_date": widget.startDate.toString(),
                                  "end_date": widget.endDate.toString(),
                                  "image": widget.imageFile, //File
                                  "image_base64": base64Encode(widget.imageFile!.readAsBytesSync()),
                                  "image_name": widget.imageFile!.path.split('/').last,
                                },),
                              ),
                            );
                            if (selected != null && selected is EventTemplateModel) {
                              widget.changeTemplate(selected);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: appColors.black.withOpacity(.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: isSelected ? 5 : 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.remove_red_eye, color: Colors.white, size: 15),
                                const SizedBox(width: 5),
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
                        ),
                        if (isSelected)
                          Container(
                            decoration: BoxDecoration(
                                color: appColors.white,
                                shape: BoxShape.circle
                            ),
                            child: Icon(Icons.check_circle, color: appColors.btnColor),
                          ),
                        if (isSelected)
                          const SizedBox(width: 10),
                      ],
                    )
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const CustomTemplateRequestScreen(),
          //       ),
          //     );
          //   },
          //   child: CommonButton(
          //     btnColor: appColors.black,
          //     title: "",
          //     icon: Icons.design_services,
          //   ),
          // ),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }
}
