import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/common/common_button.dart';

class CheckDialog extends StatelessWidget {
  final String status;
  final String message;
  final Color color;
  final IconData icon;
  final void Function()? onClose;
  final void Function()? onValidate;
  final String btnTitle;
  final List<Widget>? data;
  final String? secondaryBtnTitle;
  final void Function()? onSecondaryValidate;

  const CheckDialog({
    Key? key,
    required this.status,
    required this.message,
    required this.color,
    required this.icon,
    this.onClose,
    this.onValidate,
    this.btnTitle = "",
    this.data,
    this.secondaryBtnTitle,
    this.onSecondaryValidate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 80),
                  const SizedBox(height: 15),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (data != null) ...[
                    const SizedBox(height: 15),
                    ...data!,
                  ],
                  const SizedBox(height: 25),
                  if (btnTitle.isNotEmpty)
                    GestureDetector(
                      onTap: onValidate,
                      child: CommonButton(
                        title: btnTitle,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  if (secondaryBtnTitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: onSecondaryValidate,
                        child: CommonButton(
                          title: secondaryBtnTitle!,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          btnColor: Colors.grey.shade300,
                          textColor: Colors.black87,
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (onClose != null)
                    TextButton(
                      onPressed: onClose,
                      child: const Text(
                        "Fermer",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
