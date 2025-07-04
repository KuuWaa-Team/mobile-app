import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_template_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TemplatePreviewPage extends StatefulWidget {
  final EventTemplateModel template;
  final Map<String, dynamic> data;

  const TemplatePreviewPage({Key? key, required this.template, required this.data}) : super(key: key);

  @override
  State<TemplatePreviewPage> createState() => _TemplatePreviewPageState();
}

class _TemplatePreviewPageState extends State<TemplatePreviewPage> {
  late final WebViewController _controller;
  final AppColors appColors = AppColors();

  @override
  void initState() {
    super.initState();

    final htmlForm = '''
      <html>
        <body onload="document.forms[0].submit()">
          <form method="POST" action="${AppUrl.domainName}/templates/preview/${widget.template.id}">
            <input type="hidden" name="template_id" value="${widget.template.id}" />
            ${widget.data.entries.where((e) => e.key != 'image').map((entry) {
            final key = entry.key;
            final value = entry.value?.toString().replaceAll('"', '&quot;') ?? '';
            return '<input type="hidden" name="$key" value="$value" />';
          }).join('\n')}
            ${widget.data['image_base64'] != null ? '<input type="hidden" name="image_base64" value="${widget.data['image_base64']}" />' : ''}
            ${widget.data['image_name'] != null ? '<input type="hidden" name="image_name" value="${widget.data['image_name']}" />' : ''}
          </form>
        </body>
      </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(htmlForm);
  }


  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    return Scaffold(
      backgroundColor: appColors.white,
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom + 55,
            right: 20,
            child: InkWell(
              onTap: () {
                Navigator.pop(context, widget.template);
              },
              child: CommonButton(
                context: context,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                icon: Icons.push_pin,
                title: "Selectionner",
              ),
            )
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            left: 20,
            child: FloatingActionButton(
              heroTag: "infoBtn",
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 3,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextView(
                            "Spécificités du template",
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.black,
                              fontWeightNew: FontWeight.w600,
                              size: ResponsiveFlutter.of(context).fontSize(2.5),
                            ),
                          ),
                          const SizedBox(height: 12),
                          MyTextView(
                            widget.template.name.toString(),
                            textAligntNew: TextAlign.center,
                            styleNew: MyTextStyle(
                              colorNew: appColors.btnColor,
                              fontWeightNew: FontWeight.w500,
                              size: ResponsiveFlutter.of(context).fontSize(2),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.monetization_on, size: 20),
                              const SizedBox(width: 15),
                              MyTextView(
                                "${widget.template.price} crédits / invitation",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.darkGreyText,
                                  fontWeightNew: FontWeight.w500,
                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          if (widget.template.hasAnimations == true)
                          Row(
                            children: [
                              const Icon(Icons.animation, size: 20),
                              const SizedBox(width: 15),
                              MyTextView(
                                "Inclut des animations",
                                textAligntNew: TextAlign.center,
                                styleNew: MyTextStyle(
                                  colorNew: appColors.darkGreyText,
                                  fontWeightNew: FontWeight.w500,
                                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                                ),
                              ),
                            ],
                          ),
                          if (widget.template.hasAnimations == true)
                            const SizedBox(height: 15),
                          if (widget.template.hasAnimations == true)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle, size: 20),
                              const SizedBox(width: 15),
                              Expanded(
                                child: MyTextView(
                                  "Adapté pour ${widget.template.eventsAdapted}",
                                  maxLinesNew: 5,
                                  textAligntNew: TextAlign.left,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.darkGreyText,
                                    fontWeightNew: FontWeight.w500,
                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.animation, size: 20),
                              const SizedBox(width: 15),
                              Expanded(
                                child: MyTextView(
                                  "Inclu des animations",
                                  maxLinesNew: 5,
                                  textAligntNew: TextAlign.left,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.darkGreyText,
                                    fontWeightNew: FontWeight.w500,
                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(widget.template.imageRequired == true ? Icons.image_outlined : Icons.image_not_supported, size: 20),
                              const SizedBox(width: 15),
                              Expanded(
                                child: MyTextView(
                                  "Image${widget.template.imageRequired != true ? ' non' : ''} requise",
                                  maxLinesNew: 5,
                                  textAligntNew: TextAlign.left,
                                  styleNew: MyTextStyle(
                                    colorNew: appColors.darkGreyText,
                                    fontWeightNew: FontWeight.w500,
                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Utils.hexToColor(widget.template.primaryColor!),
                                  border: Border.all(color: Colors.black12),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: MyTextView(
                                  "Couleur principale : ${widget.template.primaryColor!.toUpperCase()}",
                                  maxLinesNew: 2,
                                  textAligntNew: TextAlign.left,
                                  styleNew: MyTextStyle(
                                    colorNew: Utils.hexToColor(widget.template.primaryColor!),
                                    fontWeightNew: FontWeight.w500,
                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Utils.hexToColor(widget.template.secondaryColor!),
                                  border: Border.all(color: Colors.black12),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: MyTextView(
                                  "Couleur secondaire : ${widget.template.secondaryColor!.toUpperCase()}",
                                  maxLinesNew: 2,
                                  textAligntNew: TextAlign.left,
                                  styleNew: MyTextStyle(
                                    colorNew: Utils.hexToColor(widget.template.secondaryColor!),
                                    fontWeightNew: FontWeight.w500,
                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    );
                  },
                );
              },
              backgroundColor: appColors.white,
              child: const Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
    );
  }
}
