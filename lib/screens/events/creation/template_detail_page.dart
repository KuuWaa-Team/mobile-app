import 'package:flutter/material.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';

class TemplateDetailsPage extends StatelessWidget {
  final EventTemplateModel template;
  final VoidCallback onUseTemplate;

  const TemplateDetailsPage({
    Key? key,
    required this.template,
    required this.onUseTemplate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: MyTextView(
          "Détails du modèle",
          textAligntNew: TextAlign.center,
          styleNew: MyTextStyle(
            colorNew: appColors.white,
            fontWeightNew: FontWeight.w600,
            size: ResponsiveFlutter.of(context).fontSize(2),
          ),
        ),
        backgroundColor: appColors.btnColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 180,
                decoration: BoxDecoration(
                  boxShadow: [Utils.customShadow()]
                ),
                child: Image.network(
                  "${AppUrl.domainName}/images/templates/${template.imagePath}",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Nom
            MyTextView(
              template.name ?? "",
              textAligntNew: TextAlign.center,
              styleNew: MyTextStyle(
                colorNew: appColors.btnColor,
                fontWeightNew: FontWeight.w600,
                size: ResponsiveFlutter.of(context).fontSize(2),
              ),
            ),
            const SizedBox(height: 12),

            // Prix
            _buildInfoRow(
              icon: Icons.monetization_on,
              text: "${template.price} crédits / invitation",
              context: context
            ),

            // Animations
            if (template.hasAnimations == true)
              _buildInfoRow(
                icon: Icons.animation,
                text: "Inclut des animations",
                  context: context
              ),

            // Adaptation
            if (template.eventsAdapted != null)
              _buildInfoRow(
                icon: Icons.event_available,
                text: "Adapté pour ${template.eventsAdapted}",
                  context: context
              ),

            // Image requise ?
            _buildInfoRow(
              icon: template.imageRequired == true ? Icons.image : Icons.image_not_supported,
              text: "Image${template.imageRequired != true ? " non" : ""} requise",
                context: context
            ),

            if (template.primaryColor != null)
              _buildColorRow(
                label: "Couleur principale",
                color: Utils.hexToColor(template.primaryColor!),
                hex: template.primaryColor!,
                  context: context
              ),

            // Couleur secondaire
            if (template.secondaryColor != null)
              _buildColorRow(
                label: "Couleur secondaire",
                color: Utils.hexToColor(template.secondaryColor!),
                hex: template.secondaryColor!,
                  context: context
              ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check, color: Colors.white,),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.btnColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: onUseTemplate,
                label: const Text("Utiliser ce modèle", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: MyTextView(
              text,
              maxLinesNew: 3,
              textAligntNew: TextAlign.left,
              styleNew: MyTextStyle(
                colorNew: AppColors().darkGreyText,
                fontWeightNew: FontWeight.w500,
                size: ResponsiveFlutter.of(context).fontSize(1.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorRow({required String label, required Color color, required String hex, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: Colors.black12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: MyTextView(
              "$label : ${hex.toUpperCase()}",
              maxLinesNew: 2,
              textAligntNew: TextAlign.left,
              styleNew: MyTextStyle(
                colorNew: color,
                fontWeightNew: FontWeight.w500,
                size: ResponsiveFlutter.of(context).fontSize(1.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
