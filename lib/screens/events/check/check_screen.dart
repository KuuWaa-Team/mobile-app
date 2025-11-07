import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/check_dialog.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/view_model/invitation/invitation_view_model.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class CheckScreen extends StatefulWidget {
  EventModel event;
  CheckScreen({Key? key, required this.event}) : super(key: key);

  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  AppColors appColors = AppColors();

  bool loading = false;
  bool loadingCode = false;
  bool checked = false;

  InvitationViewModel invitationViewModel = InvitationViewModel();

  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TextEditingController _codeController = TextEditingController();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: <Widget>[
            commonAppBar(
              context: context,
              title: "Vérifier Invitation",
              backArrow: true,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, icon: const Icon(Icons.close)
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                    child:
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(CupertinoIcons.barcode, size: 50,),
                                        const SizedBox(height: 10,),
                                        const Text("Entrez le code de l'invitation", style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ), textAlign: TextAlign.center,),
                                        const SizedBox(height: 20,),
                                        Container(
                                          height: ResponsiveFlutter.of(context).verticalScale(40),
                                          padding: EdgeInsets.symmetric(
                                            vertical: ResponsiveFlutter.of(context).moderateScale(5),
                                            horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                                          ),
                                          margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(25)),
                                          decoration: BoxDecoration(
                                              color: appColors.lightColor,
                                              borderRadius: BorderRadius.circular(
                                                ResponsiveFlutter.of(context).moderateScale(25),
                                              ),
                                              border: Border.all(color: appColors.borderColor, width: 1)
                                          ),
                                          child: commonTestField(
                                            textColor: appColors.borderColor,
                                            context: context,
                                            controller: _codeController,
                                            hintText: "XXXXXX",
                                            keyboardType: TextInputType.number,
                                            icon: true,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (_codeController.text.length < 6) {
                                                  Utils.flushBarErrorMessage("Vous devez entrer un code valide", context);
                                                } else {
                                                  setState(() {
                                                    loadingCode = true;
                                                  });
                                                  Map data = {
                                                    "code": _codeController.text
                                                  };
                                                  await invitationViewModel.checkInvitation(context, data, widget.event).then((value) {
                                                    setState(() {
                                                      loadingCode = false;
                                                      _codeController.text = "";
                                                    });
                                                  });
                                                }
                                              },
                                              child: CommonButton(
                                                loading: loadingCode,
                                                title: "Vérifier",
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          );
                        },
                      );
                    },
                  );
                },
                child: CommonButton(
                  title: "Vérifier avec le code",
                ),
              ),
            ),
            Expanded(flex: 4, child: _buildQrView(context)),
          ],
        ),
      )
    );
  }

  Widget _buildQrView(BuildContext context) {
    final scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: appColors.btnColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && !checked) {
        setState(() => checked = true);
        _handleScannedCode(scanData.code!);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pas de permission caméra')),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleScannedCode(String code) async {
    bool unknown = true;
    Map result = {};
    try {
      result = jsonDecode(code);
      unknown = false;
    } catch (e) {
      if (kDebugMode) print(e);
    }

    if (unknown || !result.containsKey("type") || result['type'] != 'KuuWaa' || !result.containsKey("kwEv")) {
      _showDialogError("Ce codeQR n'est pas reconnu par KuuWaa...");
    } else if (int.parse(result['kwEv'].toString().replaceAll('KW000', '')) != widget.event.id!) {
      _showDialogError("Vous essayez de vérifier une invitation d'un autre événement.");
    } else {
      String code = result['code'];
      setState(() {
        loadingCode = true;
      });
      Map data = {
        "code": code
      };
      await invitationViewModel.checkInvitation(context, data, widget.event).then((value) {
        setState(() {
          loadingCode = false;
          _codeController.text = "";
        });
      });
      // _showDialogValid(result);
    }
  }

  void _showDialogError(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CheckDialog(
        color: Colors.red,
        message: message,
        status: "Erreur",
        icon: CupertinoIcons.xmark_circle_fill,
        onClose: () => setState(() => checked = false),
        onValidate: () => setState(() => checked = false),
        btnTitle: "D'accord",
      ),
    );
  }

  void _showDialogValid(Map result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CheckDialog(
        color: result["status"] == "verified" ? Colors.red : Colors.green,
        message: result["status"] == "verified"
            ? "Cette invitation a déjà été vérifiée."
            : "L'invitation est valide. Vérifiez pour confirmer.",
        status: result["status"] == "verified"
            ? "Déjà vérifiée"
            : "Valide",
        icon: result["status"] == "verified"
            ? CupertinoIcons.xmark_circle_fill
            : CupertinoIcons.check_mark_circled_solid,
        onClose: () => setState(() => checked = false),
        onValidate: () {
          if (result["status"] != 'verified') {
            invitationViewModel.validateInvitation(context, result['id']);
          }
          setState(() => checked = false);
          Navigator.pop(context);
        },
        btnTitle: result['status'] == 'verified' ? "D'accord" : "Vérifier",
        data: result['status'] == 'verified'
            ? null
            : _buildGuestInfoWidgets(result),
      ),
    );
  }

  List<Widget> _buildGuestInfoWidgets(Map result) {
    return [
      _infoItem("Nom", "${result['civility']} ${result['name']}"),
      _infoItem("Table", result['table'] ?? "-"),
      if (result["status"] != "verified" && result['count'] > 1)
        _infoItem("Nombre de personnes", result['count'].toString()),
    ];
  }

  Widget _infoItem(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.1),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.black.withOpacity(.5))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
