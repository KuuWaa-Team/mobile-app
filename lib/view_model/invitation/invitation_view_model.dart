import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/check_dialog.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/api_response.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/invitation/invitation_model.dart';
import 'package:kuuwaa/repository/invitation/invitation_repository.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/events/payment_screen.dart';
import 'package:kuuwaa/screens/invitations/invitation_details_screen.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class InvitationViewModel with ChangeNotifier{
  final _repository = InvitationRepository();

  bool _loading = false;
  bool get loading => _loading;
  ApiResponse<dynamic> invitationsList = ApiResponse.loading();
  ApiResponse<InvitationModel> invitation = ApiResponse.loading();

  AppColors appColors = AppColors();

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }


  setInvitationsList (ApiResponse<dynamic> response) {
    invitationsList = response;
    notifyListeners();
  }
  
  setInvitation (ApiResponse<InvitationModel> response) {
    invitation = response;
    notifyListeners();
  }

  Future<bool> listingApi(BuildContext context, int id,
      {bool withMusicRequest = false}) async {
    setInvitationsList(ApiResponse.loading());
    setLoading(true);
    await _repository.getEventInvitationsApi(context: context, id: id, withMusicRequest: false).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List invitationsJson = value['data'];
        List<InvitationModel> invitationsData = [];
        if (invitationsJson.isNotEmpty) {
          for (var element in invitationsJson) {
            invitationsData.add(InvitationModel.fromJson(element));
          }
        }
        setInvitationsList(ApiResponse.completed(invitationsData));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      print(error);
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> myInvitationsListingApi(BuildContext context) async {
    setInvitationsList(ApiResponse.loading());
    setLoading(true);
    await _repository.getMyInvitationsApi(context: context).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List invitationsJson = value['data'];
        List<InvitationModel> invitationsData = [];
        if (invitationsJson.isNotEmpty) {
          for (var element in invitationsJson) {
            invitationsData.add(InvitationModel.fromJson(element));
          }
        }
        setInvitationsList(ApiResponse.completed(invitationsData));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> invitationDetailApi(BuildContext context, int id) async {
    setInvitationsList(ApiResponse.loading());
    setLoading(true);
    await _repository.invitationDetailApi(context: context, id: id).then((value) {
      setLoading(false);
      setInvitation(ApiResponse.completed(InvitationModel.fromJson(value)));
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> addInvitation(BuildContext context, Map data) async {
    setLoading(true);
    await _repository.addInvitationsApi(context: context, data: data).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List invitationsJson = value['invitations'];
        List<InvitationModel> invitationsData = [];
        if (invitationsJson.isNotEmpty) {
          for (var element in invitationsJson) {
            invitationsData.add(InvitationModel.fromJson(element));
          }
        }
        setInvitationsList(ApiResponse.completed(invitationsData));
        Navigator.pop(context);
      } else {
        if (value['full'] == true) {
          Navigator.pop(context);
          showDialog(
            context: context,
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
                                const SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.xmark_circle,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Vous ne pouvez pas ajouter une invitation", style: TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.red
                                    ), textAlign: TextAlign.center,),
                                    SizedBox(height: 10,),
                                    Text(value['message'], style: const TextStyle(
                                        fontSize: 12
                                    ), textAlign: TextAlign.center),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                GestureDetector(
                                  onTap: () async {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => PaymentScreen(event: event),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: appColors.appLightColor.withOpacity(.5), width: 1),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Icon(CupertinoIcons.check_mark_circled, size: 20,),
                                            const SizedBox(width: 7,),
                                            MyTextView(
                                              "Elargir mon évenement",
                                              textAligntNew: TextAlign.start,
                                              maxLineWrap: true,
                                              styleNew: MyTextStyle(
                                                colorNew: appColors.black,
                                                fontWeightNew: FontWeight.w500,
                                                size: ResponsiveFlutter.of(context).fontSize(1.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    });
    // .onError((error, stackTrace) {
    //   Utils.flushBarErrorMessage(Utils.errorMessage, context);
    //   print(error);
    //   setLoading(false);
    // });
    return true;
  }

  Future<bool> selectInvitation(BuildContext context, int id, Map data) async {
    setLoading(true);
    await _repository.selectInvitationsApi(context: context, data: data, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => InvitationDetailsScreen(id: id,),
        //   ),
        // );
        Utils.toastMessage("Préférence envoyée avec succès");
        setInvitation(ApiResponse.completed(InvitationModel.fromJson(value['invitation'])));
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<bool> sendInvitation(BuildContext context, Map data, int id, EventModel event) async {
    setLoading(true);
    bool success = false;
    await _repository.sendInvitationsApi(context: context, data: data, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        success = true;
        UserViewModel().updateCredits(value['credits']);
        setLoading(false);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return success;
  }

  Future<bool> editInvitation(BuildContext context, Map data, int id) async {
    setLoading(true);
    await _repository.editInvitationsApi(context: context, data: data, id: id).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List invitationsJson = value['invitations'];
        List<InvitationModel> invitationsData = [];
        if (invitationsJson.isNotEmpty) {
          for (var element in invitationsJson) {
            invitationsData.add(InvitationModel.fromJson(element));
          }
        }
        setInvitationsList(ApiResponse.completed(invitationsData));
        Utils.toastMessage(value['message']);
        Navigator.pop(context);
      } else {
        Utils.flushBarErrorMessage(value['message'], context);
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

  Future<dynamic> checkInvitation(BuildContext context, Map data, EventModel event) async {
    setLoading(true);
    await _repository.checkInvitationsCodeApi(context: context, data: data).then((value) {
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          InvitationModel? dataInvitation;
          if (value['success']) {
            dataInvitation = InvitationModel.fromJson(value['data']);
            if (dataInvitation.event!.id != event.id) {
              return  CheckDialog(
                color: Colors.red,
                message: "Vous essayez de vérifier une invitation d'un évenement auquel vous n'êtes pas controlleur.",
                status: "Vérification non autorisée",
                icon: CupertinoIcons.nosign,
                onClose: () {
                  Navigator.pop(context);
                },
                onValidate: () {
                  Navigator.pop(context);
                },
                btnTitle: "D'accord",
              );
            }
          }

          return CheckDialog(
            color: value['success'] ? Colors.green: Colors.red,
            message: value['message'],
            status: value['success'] ? "Invitation valide" : "Invitation invalide",
            icon: value['success'] ? CupertinoIcons.check_mark_circled_solid: CupertinoIcons.xmark_circle_fill,
            onClose: () {
              Navigator.pop(context);
            },
            onValidate: () {
              if (value['success'] && dataInvitation != null) {
                validateInvitation(context, dataInvitation.id!);
              }
              Navigator.pop(context);
            },
            btnTitle: value['success'] ? "Valider" : "D'accord",
            data: value['success'] ? [
              Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.1),
                    borderRadius: BorderRadius.circular(5)
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Nom", style: TextStyle(
                        color: Colors.black.withOpacity(.5)
                    ),),
                    Text(dataInvitation!.civility.toString() + " " + dataInvitation.name.toString(), style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.1),
                    borderRadius: BorderRadius.circular(5)
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Table", style: TextStyle(
                        color: Colors.black.withOpacity(.5)
                    ),),
                    Text(dataInvitation.table == null ? "-" : dataInvitation!.table!.name.toString(), style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ),
              if (dataInvitation.count! > 1)
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Nombre de personnes", style: TextStyle(
                          color: Colors.black.withOpacity(.5)
                      ),),
                      Text(dataInvitation.count.toString(), style: const TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                ),
          ] : null
          );
        },
      );
      setLoading(false);
      return value;
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return null;
  }

  Future<void> validateInvitation(BuildContext context, int id) async {
    setLoading(true);
    await _repository.validateInvitationApi(context: context, id: id);
  }

  Future<void> playMusic(BuildContext context, String slug, {bool unPlay = false}) async {
    setLoading(true);
    await _repository.playMusicApi(context: context, slug: slug, unPlay: unPlay).then((value) {
      print("------------------------------");
      print(value);
    });
  }

  Future<bool> sendAllInvitations(BuildContext context, Map data, EventModel event) async {
    setLoading(true);
    await _repository.sendAllInvitationsApi(context: context, data: data).then((value) {
      setLoading(false);
      if (value['success'] == true  ) {
        List invitationsJson = value['invitations'];
        List<InvitationModel> invitationsData = [];
        if (invitationsJson.isNotEmpty) {
          for (var element in invitationsJson) {
            invitationsData.add(InvitationModel.fromJson(element));
          }
        }
        setInvitationsList(ApiResponse.completed(invitationsData));
        Utils.toastMessage(value['message']);
        Navigator.pop(context);
      } else {
        if (value['notpaid'] == true) {
          Navigator.pop(context);
          showDialog(
            context: context,
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
                                const SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.xmark_circle,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Cet évenement n'est pas activé", style: TextStyle(
                                        fontWeight: FontWeight.bold, color: Colors.red
                                    ), textAlign: TextAlign.center,),
                                    SizedBox(height: 10,),
                                    Text("Vous ne pouvez pas partager les invitations d'un évenement non activé.", style: TextStyle(
                                        fontSize: 12
                                    ), textAlign: TextAlign.center,),
                                    Divider(),
                                    Text("Pour activer l'évenement, vous devez payer les frais d'abonnement.", style: TextStyle(
                                        fontSize: 12
                                    ), textAlign: TextAlign.center,),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentScreen(event: event),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: appColors.appLightColor.withOpacity(.5), width: 1),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Icon(CupertinoIcons.check_mark_circled, size: 20,),
                                            const SizedBox(width: 7,),
                                            MyTextView(
                                              "Activer l'évenement",
                                              textAligntNew: TextAlign.start,
                                              maxLineWrap: true,
                                              styleNew: MyTextStyle(
                                                colorNew: appColors.black,
                                                fontWeightNew: FontWeight.w500,
                                                size: ResponsiveFlutter.of(context).fontSize(1.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
        } else {
          Utils.flushBarErrorMessage(value['message'], context);
        }
      }
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(Utils.errorMessage, context);
      setLoading(false);
    });
    return true;
  }

}