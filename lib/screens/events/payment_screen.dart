import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/screens/events/details_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  EventModel event;
  PaymentScreen({Key? key, required this.event}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  AppColors appColors = AppColors();
  bool loading = false;
  var maskFormatter = MaskTextInputFormatter(
      mask: '*## ### ###',
      filter: { "#": RegExp(r'\d'), "*": RegExp(r'[1-9]') },
      type: MaskAutoCompletionType.lazy
  );

  EventModel event = EventModel();
  bool paying = false;

  WebViewController controller = WebViewController();

  final TextEditingController _phoneController = TextEditingController();

  double total = 0;
  var loadingPercentage = 0;


  @override
  void initState() {
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://kuuwaa.com/events/${widget.event.id}/payment'),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> featuresWidget = [];

    return SafeArea(
      top: false,
bottom: !Platform.isIOS,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              title: "Activer l'évenement",
              backArrow: true,
              context: context,
              backClick: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(id: widget.event.id!),
                  ),
                );
              }
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
            if (loadingPercentage >= 100)
            Expanded(child: WebViewWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
