import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/creation/template_detail_page.dart';
import 'package:kuuwaa/screens/events/template_preview_page.dart';

class TemplateChoice extends StatelessWidget {
  final List<EventTemplateModel> templates;
  final EventTemplateModel? selectedTemplate;
  final ValueChanged<EventTemplateModel> onTemplateSelected;
  final ValueChanged<File?> onTemplateImageSelected;
  final File? imageFile;
  final File? templateImageFile;
  final EventCategoryModel selectedCategory;
  final TextEditingController detailsController;
  final TextEditingController titleController;
  final DateTime? startDate;
  final DateTime? endDate;
  final TextEditingController addressController;
  final TextEditingController placeNameController;

  const TemplateChoice({
    Key? key,
    required this.templates,
    required this.selectedTemplate,
    required this.onTemplateSelected,
    required this.onTemplateImageSelected,
    required this.selectedCategory,
    required this.detailsController,
    required this.imageFile,
    required this.templateImageFile,
    required this.titleController,
    required this.startDate,
    required this.endDate,
    required this.addressController,
    required this.placeNameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveFlutter.of(context).moderateScale(20),
      ),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: templates.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.67,
        ),
        itemBuilder: (context, index) {
          final template = templates[index];
          final isSelected = selectedTemplate?.id == template.id;

          return GestureDetector(
            onTap: () async {
              final shouldUse = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => TemplateDetailsPage(
                    template: template,
                    onUseTemplate: (File? templateImage) {
                      if (templateImage != null) {
                        onTemplateImageSelected(templateImage);
                      }
                      Navigator.pop(context, true);
                    },
                  ),
                ),
              );

              if (shouldUse == true) {
                onTemplateSelected(template);
              }
            },
            onLongPress: () async {
              if (imageFile != null) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TemplatePreviewPage(
                      template: template,
                      data: {
                        "title": titleController.text,
                        "address": addressController.text,
                        "placeName": placeNameController.text,
                        "details": detailsController.text,
                        "category_id": selectedCategory.id,
                        "start_date": startDate?.toIso8601String(),
                        "end_date": endDate?.toIso8601String(),
                        "image": imageFile,
                        "image_base64": base64Encode(imageFile!.readAsBytesSync()),
                        "image_name": imageFile!.path.split('/').last,
                      },
                    ),
                  ),
                );
              }
            },
            child: Stack(
              children: [
                Card(
                  elevation: 3,
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
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          "${AppUrl.domainName}/images/templates/${template.imagePath}",
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            MyTextView(
                              template.name ?? "Modèle",
                              textAligntNew: TextAlign.center,
                              styleNew: MyTextStyle(
                                colorNew: appColors.black,
                                fontWeightNew: FontWeight.w600,
                                size: ResponsiveFlutter.of(context).fontSize(1.6),
                              ),
                            ),
                            const SizedBox(height: 4),
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
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: -5, right: -5,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(Icons.check_circle, color: appColors.btnColor),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
