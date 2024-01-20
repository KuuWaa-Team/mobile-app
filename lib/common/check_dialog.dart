import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/common/common_button.dart';

class CheckDialog extends StatelessWidget {

  final BuildContext context;
  final String status;
  final String message;
  final Color color;
  final IconData icon;
  final void Function()? onClose;
  final void Function()? onValidate;
  final String btnTitle;
  List? data;

  CheckDialog({
    Key? key,
    required this.context,
    required this.status,
    required this.message,
    required this.color,
    required this.icon,
    required this.onClose,
    required this.onValidate,
    this.btnTitle = "",
    List? data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Icon(
                    icon,
                    color: color,
                    size: 100,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.black.withOpacity(.4),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (btnTitle != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onValidate,
                        child: CommonButton(
                          title: btnTitle,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ],
                  ),
                if (data != null)
                  ...data!
              ],
            ),
          ),
        ],
      ),
    );
  }
}