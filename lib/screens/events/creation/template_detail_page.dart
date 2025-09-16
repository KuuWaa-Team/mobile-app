import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart'; // <--- ajout cropper
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';

class TemplateDetailsPage extends StatefulWidget {
  final EventTemplateModel template;
  final VoidCallback onUseTemplate;

  const TemplateDetailsPage({
    Key? key,
    required this.template,
    required this.onUseTemplate,
  }) : super(key: key);

  @override
  State<TemplateDetailsPage> createState() => _TemplateDetailsPageState();
}

class _TemplateDetailsPageState extends State<TemplateDetailsPage> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? cropped = await _cropImage(pickedFile.path);
      if (cropped != null) {
        setState(() {
          _selectedImage = cropped;
        });
      }
    }
  }

  Future<File?> _cropImage(String path) async {
    // ratio défini par le template
    final ratioX = widget.template.widthImage ?? 1;
    final ratioY = widget.template.heighImage ?? 1;

    final cropStyle = widget.template.imageRounded == true
        ? CropStyle.circle
        : CropStyle.rectangle;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      // cropStyle: cropStyle,
      aspectRatio: CropAspectRatio(ratioX: ratioX.toDouble(), ratioY: ratioY.toDouble()),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recadrer l’image',
          toolbarColor: AppColors().btnColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Recadrer l’image',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  void _handleUseTemplate() {
    if (widget.template.imageRequired == true) {
      _showImageRequiredDialog();
    } else {
      widget.onUseTemplate();
    }
  }

  void _showImageRequiredDialog() {
    final appColors = AppColors();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Image requise"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Ce template exige une image. Veuillez en uploader une avant de continuer."),
              const SizedBox(height: 12),
              if (_selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(widget.template.imageRounded == true ? 100 : 8),
                  child: Image.file(_selectedImage!, height: 120, fit: BoxFit.cover),
                ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload),
                label: const Text("Uploader une image"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.btnColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: _selectedImage == null
                  ? null
                  : () {
                Navigator.pop(context);
                widget.onUseTemplate(); // on continue
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.btnColor,
                foregroundColor: Colors.white,
              ),
              child: const Text("Continuer"),
            ),
          ],
        );
      },
    );
  }

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
                  boxShadow: [Utils.customShadow()],
                ),
                child: Image.network(
                  "${AppUrl.domainName}/images/templates/${widget.template.imagePath}",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            MyTextView(
              widget.template.name ?? "",
              textAligntNew: TextAlign.center,
              styleNew: MyTextStyle(
                colorNew: appColors.btnColor,
                fontWeightNew: FontWeight.w600,
                size: ResponsiveFlutter.of(context).fontSize(2),
              ),
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              icon: Icons.monetization_on,
              text: "${widget.template.price} crédits / invitation",
              context: context,
            ),

            if (widget.template.hasAnimations == true)
              _buildInfoRow(
                icon: Icons.animation,
                text: "Inclut des animations",
                context: context,
              ),

            if (widget.template.eventsAdapted != null)
              _buildInfoRow(
                icon: Icons.event_available,
                text: "Adapté pour ${widget.template.eventsAdapted}",
                context: context,
              ),

            _buildInfoRow(
              icon: widget.template.imageRequired == true
                  ? Icons.image
                  : Icons.image_not_supported,
              text: "Image${widget.template.imageRequired != true ? " non" : ""} requise",
              context: context,
            ),

            if (widget.template.primaryColor != null)
              _buildColorRow(
                label: "Couleur principale",
                color: Utils.hexToColor(widget.template.primaryColor!),
                hex: widget.template.primaryColor!,
                context: context,
              ),

            if (widget.template.secondaryColor != null)
              _buildColorRow(
                label: "Couleur secondaire",
                color: Utils.hexToColor(widget.template.secondaryColor!),
                hex: widget.template.secondaryColor!,
                context: context,
              ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.btnColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _handleUseTemplate,
                label: const Text("Utiliser ce modèle",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
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

  Widget _buildColorRow({
    required String label,
    required Color color,
    required String hex,
    required BuildContext context,
  }) {
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
