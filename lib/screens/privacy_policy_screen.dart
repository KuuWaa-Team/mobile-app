import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  AppColors appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              backArrow: true,
              title: Strings.privacyPolicy,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                  vertical: ResponsiveFlutter.of(context).moderateScale(15),
                ),
                shrinkWrap: false,
                children: [
                  MyTextView(
                    "La présente politique de confidentialité régit la manière dont l'application KuuWaa collecte, utilise, conserve et divulgue les informations recueillies auprès des utilisateurs de l'application KuuWaa.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(15),
                  ),
                  MyTextView(
                    "Collecte des informations",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w600,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "Lorsque vous utilisez l'application KuuWaa, nous pouvons collecter les informations suivantes :",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "* Informations personnelles : Nous pouvons collecter des informations personnelles telles que votre nom, votre adresse e-mail, votre numéro de téléphone et votre adresse postale lorsque vous vous inscrivez ou utilisez notre application.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "* Informations sur l'événement : Nous pouvons collecter des informations relatives à vos événements, y compris les détails de l'événement, les participants invités, les commentaires et les photos associées aux événements.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(15),
                  ),
                  MyTextView(
                    "Utilisation des informations",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w600,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "Les informations collectées par l'application KuuWaa peuvent être utilisées aux fins suivantes :",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "* Fourniture de services : Nous utilisons les informations pour vous permettre d'utiliser les fonctionnalités de l'application KuuWaa, y compris la création, la gestion et l'envoi d'invitations électroniques, la gestion des participants et la communication liée aux événements.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "* Amélioration de l'expérience utilisateur : Nous pouvons utiliser les informations pour améliorer notre application, personnaliser votre expérience et fournir un support client efficace.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "* Communication : Nous pouvons utiliser votre adresse e-mail pour vous envoyer des notifications relatives à l'application, des mises à jour, des nouvelles fonctionnalités ou des informations sur les événements.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(15),
                  ),
                  MyTextView(
                    "Protection des informations",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w600,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "Nous mettons en place des mesures de sécurité appropriées pour protéger les informations collectées auprès des utilisateurs de l'application KuuWaa contre tout accès non autorisé, altération, divulgation ou destruction.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(15),
                  ),
                  MyTextView(
                    "Divulgation des informations à des tiers",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w600,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "Nous ne vendons, n'échangeons ni ne louons les informations personnelles des utilisateurs à des tiers. Cependant, nous pouvons partager des informations agrégées et anonymisées avec des partenaires ou des annonceurs à des fins de statistiques, de marketing ou d'amélioration de nos services.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(15),
                  ),
                  MyTextView(
                    "Conservation des informations",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w600,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "Nous conservons les informations collectées aussi longtemps que nécessaire pour fournir nos services et nous conformer aux obligations légales",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(15),
                  ),
                  MyTextView(
                    "Modifications de la politique de confidentialité",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w600,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "Nous nous réservons le droit de modifier cette politique de confidentialité à tout moment. Les modifications seront effectives dès leur publication dans l'application KuuWaa. Il est recommandé de consulter régulièrement cette politique pour rester informé de toute mise à jour.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(15),
                  ),
                  MyTextView(
                    "Contactez-nous",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w600,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(5),
                  ),
                  MyTextView(
                    "Si vous avez des questions ou des préoccupations concernant cette politique de confidentialité ou nos pratiques en matière de confidentialité, veuillez nous contacter à l'adresse suivante : contact@kuuwaa.com.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(15),
                  ),
                  MyTextView(
                    "En utilisant l'application KuuWaa, vous acceptez les termes de cette politique de confidentialité.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveFlutter.of(context).verticalScale(15),
                  ),
                  MyTextView(
                    "Date d'entrée en vigueur : 10 mai 2024.",
                    textAligntNew: TextAlign.start,
                    maxLineWrap: true,
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.w400,
                      textHeight: 1.3,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
