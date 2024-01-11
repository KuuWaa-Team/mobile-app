import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickdep/model/account/account_model.dart';
import 'package:quickdep/model/confirmation/shift_confirmation_model.dart';
import 'package:quickdep/model/shift/shift_model.dart';
import 'package:quickdep/model/timeSheet/time_sheet_model.dart';
import 'package:quickdep/utils/account_types.dart';
import 'package:standard_dialogs/standard_dialogs.dart';

class Utils {
  static String pusherAppId = "1543547";
  static String pusherKey = "edff47cb96049de87027";
  static String pusherSecret = "af29f17f93dac673ee31";
  static String pusherCluster = "us2";

  static String errorMessage = "Une erreur est survenue. Veuillez ressayer plutard";

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static Widget waitingStatusCard () {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20)
        ),
        child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.history_rounded, color: Colors.white, size: 17,),
              SizedBox(width: 7),
              Text("En attente d'approbation", style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500
              ),),
            ]
        )
    );
  }

  static Widget approvedStatusCard () {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20)
        ),
        child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 16,),
              SizedBox(width: 5,),
              Text("Approuvé", style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500
              ),),
            ]
        )
    );
  }

  static Widget consecutiveCard () {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20)
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cable, size: 16, color: Colors.white,),
          SizedBox(width: 5,),
          Text("Shifts consécutifs", style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500
          ),),
        ],
      )
    );
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(context: context, flushbar: Flushbar(
      message: message,
      forwardAnimationCurve: Curves.decelerate,
      icon: const Icon(Icons.error, size: 25, color: Colors.white,),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red.withOpacity(.88),
      borderRadius: BorderRadius.circular(5),
      flushbarPosition: FlushbarPosition.TOP,
      barBlur: 10,
      margin: const EdgeInsets.all(10),
    )..show(context));
  }

  static void showDialog (BuildContext context, title, {bool isSuccess = true, description}) {
    if (isSuccess) {
      showSuccessDialog(context,
          title: Text(title),
          content: Text(description.toString()),
          action: DialogAction(
            title: const Text('OK'),
          )
      );
    } else {
      showErrorDialog(context,
          title: Text(title));

    }
  }

  static Map<int, String> townList () {
     return {
      1: "Québec",
      2: "Levis",
      3: "Trois rivères",
      4: "Sherbrook",
      5: "Gatineau",
      6: "Laval",
      7: "Longueuil",
      8: "Drummondville",
    };
  }

  static snakBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
      ),
    );
  }

  static getMonthName (String date) {
    var month = date.split(' ')[0];
    Map<String, String> months = {
      "1": "Janvier",
      "2": "Fevrier",
      "3": "Mars",
      "4": "Avril",
      "5": "Mai",
      "6": "Juin",
      "7": "Juillet",
      "8": "Août",
      "9": "Septembre",
      "10": "Octobre",
      "11": "Novembre",
      "12": "Decembre",
    };
    return "${months[month]} ${date.split(' ')[1]}";
  }

  static getConfirmationsListFromMap(dynamic shifts) {
    List confirmationsList = [];
    shifts.forEach((date, value) {
      confirmationsList.add(date);
      for (var data in value) {
        confirmationsList.add(ShiftConfirmationModel.fromJson(data));
      }
    });

    return confirmationsList;
  }

  static isWorker(AccountModel? account) {
    return account != null && account.type == AccountType.worker;
  }

  static isEnterprise(AccountModel? account) {
    return account != null && account.type == AccountType.enterprise;
  }

  static getShiftsListFromMap(
    Map shifts,
  ) {
    List shiftsList = [];
    shifts.forEach((date, value) {
      shiftsList.add(date);
      for (var data in value) {
        shiftsList.add(ShiftModel.fromJson(data));
      }
    });

    return shiftsList;
  }

  static String getAttestationUrl() {
    return "https://documents.quickdep.ca/att.pdf";
  }

  static String getSpecimenUrl() {
    return "https://documents.quickdep.ca/spc.pdf";
  }

  static getTimeSheetListFromMap(Map timeSheets) {
    List shiftsList = [];
    timeSheets.forEach((date, value) {
      shiftsList.add(date);
      for (var data in value) {
        shiftsList.add(TimeSheetModel.fromJson(data));
      }
    });

    return shiftsList;
  }

  static BoxShadow customShadow () {
    return BoxShadow(
      color: Colors.grey.withOpacity(0.3),
      spreadRadius: .5,
      blurRadius: 7,
      offset: const Offset(0, 1), // changes position of shadow
    );
  }


  static bool emailValid (email) {
    return RegExp(r"^[a-zA-Z\d.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static empty (dynamic data) {
    return data != null || data != "" ||   data != "null";
  }
}