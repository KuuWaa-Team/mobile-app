import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/invitation/invitation_model.dart';
import 'package:kuuwaa/model/table/table_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/invitation/invitation_view_model.dart';
import 'package:kuuwaa/view_model/table/table_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class InvitationsListScreen extends StatefulWidget {
  int id;
  InvitationsListScreen({Key? key, required this.id}) : super(key: key);

  @override
  _InvitationsListScreenState createState() => _InvitationsListScreenState();
}

class _InvitationsListScreenState extends State<InvitationsListScreen> {
  AppColors appColors = AppColors();
  InvitationViewModel invitationViewModel = InvitationViewModel();

  bool loading = false;
  bool sending = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  TableViewModel tableViewModel = TableViewModel();

  var maskFormatter = MaskTextInputFormatter(
      mask: '### ### ###',
      filter: { "#": RegExp(r'\d') },
      type: MaskAutoCompletionType.lazy
  );

  Object dropDownValue = {
    "name": "Civilité",
    "count": 0
  };

  Object tableDropDownValue = TableModel(
    id: null,
    name: "Table"
  );

  List<TableModel> tables = [];

  List<Map> civilities = [
    {
      "name": "Mr.",
      "count": 1
    },
    {
      "name": "Mme.",
      "count": 1
    },
    {
      "name": "Mlle.",
      "count": 1
    },
    {
      "name": "Couple",
      "count": 2
    },
    {
      "name": "Gp.",
      "count": null
    },
  ];

  List items = [];

  @override
  void initState() {
    civilities.insert(0, dropDownValue as Map);
    invitationViewModel.listingApi(context, widget.id);
    List<TableModel> fetchedTables = [tableDropDownValue as TableModel];
    tableViewModel.listingApi(context, widget.id).then((value) {
      for (var element in tableViewModel.tables) {
        fetchedTables.add(element);
      }
      setState(() {
        tables = fetchedTables;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            commonAppBar(
              context: context,
              title: Strings.myInvites,
              backArrow: true,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: appColors.appMediumColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only( // <-- SEE HERE
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Padding(
                                  padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        MyTextView(
                                          Strings.addInvite,
                                          textAligntNew: TextAlign.center,
                                          styleNew: MyTextStyle(
                                            colorNew: appColors.lightColor,
                                            fontWeightNew: FontWeight.w600,
                                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                                          ),
                                        ),
                                        const SizedBox(height: 15,),
                                        Container(
                                          height: ResponsiveFlutter.of(context).verticalScale(40),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: appColors.appLightColor,
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveFlutter.of(context).moderateScale(20),
                                            ),
                                            border: Border.all(
                                              color: appColors.borderColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: DropdownButton(
                                            value: dropDownValue,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: appColors.lightPinkColor,
                                            ),
                                            style: MyTextStyle(
                                              colorNew: appColors.lightColor,
                                              fontWeightNew: FontWeight.w400,
                                              size: ResponsiveFlutter.of(context).fontSize(1.8),
                                            ),
                                            iconSize: ResponsiveFlutter.of(context).moderateScale(30),
                                            isExpanded: true,
                                            dropdownColor: appColors.appLightColor,
                                            borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).moderateScale(20)),
                                            underline: Container(),
                                            alignment: Alignment.bottomCenter,
                                            items: civilities.map((civility) {
                                              return DropdownMenuItem(
                                                value: civility,
                                                alignment: Alignment.centerLeft,
                                                child: MyTextView(
                                                  civility["name"].toString(),
                                                  textAligntNew: TextAlign.center,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.lightColor,
                                                    fontWeightNew: FontWeight.w500,
                                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                dropDownValue = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Container(
                                          height: ResponsiveFlutter.of(context).verticalScale(40),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ResponsiveFlutter.of(context).moderateScale(20),
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: appColors.appLightColor,
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveFlutter.of(context).moderateScale(20),
                                            ),
                                            border: Border.all(
                                              color: appColors.borderColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: DropdownButton(
                                            value: tableDropDownValue,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: appColors.lightPinkColor,
                                            ),
                                            style: MyTextStyle(
                                              colorNew: appColors.lightColor,
                                              fontWeightNew: FontWeight.w400,
                                              size: ResponsiveFlutter.of(context).fontSize(1.8),
                                            ),
                                            iconSize: ResponsiveFlutter.of(context).moderateScale(30),
                                            isExpanded: true,
                                            dropdownColor: appColors.appLightColor,
                                            borderRadius: BorderRadius.circular(ResponsiveFlutter.of(context).moderateScale(20)),
                                            underline: Container(),
                                            alignment: Alignment.bottomCenter,
                                            items: tables.map((table) {
                                              return DropdownMenuItem(
                                                value: table,
                                                alignment: Alignment.centerLeft,
                                                child: MyTextView(
                                                  table.name.toString(),
                                                  textAligntNew: TextAlign.center,
                                                  styleNew: MyTextStyle(
                                                    colorNew: appColors.lightColor,
                                                    fontWeightNew: FontWeight.w500,
                                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                tableDropDownValue = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Container(
                                          height: ResponsiveFlutter.of(context).verticalScale(40),
                                          padding: EdgeInsets.symmetric(
                                            vertical: ResponsiveFlutter.of(context).moderateScale(6),
                                            horizontal: ResponsiveFlutter.of(context).moderateScale(15),
                                          ),
                                          margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(10)),
                                          decoration: BoxDecoration(
                                            color: appColors.appLightColor,
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveFlutter.of(context).moderateScale(25),
                                            ),
                                          ),
                                          child: commonTestField(
                                            context: context,
                                            controller: _nameController,
                                            hintText: "Nom complet",
                                            keyboardType: TextInputType.phone,
                                            icon: true,
                                          ),
                                        ),
                                        Container(
                                          height: ResponsiveFlutter.of(context).verticalScale(40),
                                          padding: EdgeInsets.symmetric(
                                            vertical: ResponsiveFlutter.of(context).moderateScale(5),
                                            horizontal: ResponsiveFlutter.of(context).moderateScale(25),
                                          ),
                                          margin: EdgeInsets.only(bottom: ResponsiveFlutter.of(context).moderateScale(25)),
                                          decoration: BoxDecoration(
                                            color: appColors.appLightColor,
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveFlutter.of(context).moderateScale(25),
                                            ),
                                          ),
                                          child: commonTestField(
                                            context: context,
                                            controller: _phoneController,
                                            initial: "+243 ",
                                            hintText: Strings.yourPhoneNumber,
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [maskFormatter],
                                            icon: true,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Map civility = dropDownValue as Map;
                                            if (civility["count"] == 0) {
                                              Utils.flushBarErrorMessage("Vous devez séléctionner une civilité", context);
                                            } else if (_nameController.text == "") {
                                              Utils.flushBarErrorMessage("Vous devez enter le nom de l'invité", context);
                                            } else if (_phoneController.text == "") {
                                              Utils.flushBarErrorMessage("Vous devez enter le numéro de téléphone de l'invité", context);
                                            } else {
                                              setState(() {
                                                loading = true;
                                              });

                                              Map data = {
                                                "civility": civility["name"],
                                                "count": civility["count"],
                                                "name": _nameController.text,
                                                "phoneNumber": _phoneController.text,
                                                "eventId": widget.id,
                                              };

                                              TableModel dropdownTable = tableDropDownValue as TableModel;

                                              if (dropdownTable.id != null) {
                                                data["tableId"] = dropdownTable.id;
                                              }

                                              invitationViewModel.addInvitation(context, data).then((value) {
                                                setState(() {
                                                  loading = false;
                                                });
                                              });
                                            }
                                          },
                                          child: CommonButton(
                                            title: "Enrégistrer",
                                            loading: loading,
                                          ),
                                        ),
                                        SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10)),
                                      ],
                                    ),
                                  ),
                                );
                            }
                          );
                        }
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10),
                    width: MediaQuery.of(context).size.width - 50 - 150 - 20,
                    decoration: BoxDecoration(
                        color: appColors.btnColor,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, color: Colors.white, size: 20,),
                        const SizedBox(width: 5,),
                        MyTextView(
                          Strings.add,
                          textAligntNew: TextAlign.center,
                          styleNew: MyTextStyle(
                            colorNew: appColors.lightColor,
                            fontWeightNew: FontWeight.w600,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Colors.white, size: 20,),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file_outlined, color: Colors.white, size: 20,),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                      color: appColors.appLightColor,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share_outlined, color: Colors.white, size: 20,),
                    ],
                  ),
                )
              ],
            ),

            ChangeNotifierProvider<InvitationViewModel>(
                create: (BuildContext context) => invitationViewModel,
                child: Consumer<InvitationViewModel>(
                    builder: (context, value, _) {
                      switch (value.invitationsList.status) {
                        case Status.LOADING:
                          return const Column(
                            children: [
                              SizedBox(height: 20,),
                              EventShimmer(),
                              SizedBox(height: 20,),
                              EventShimmer(),
                              SizedBox(height: 20,),
                              EventShimmer(),
                            ],
                          );
                        case Status.ERROR:
                          return Center(
                            child: Text(value.invitationsList.message.toString()),
                          );
                        case Status.COMPLETED:
                          List<InvitationModel> events = value.invitationsList.data;
                          if (events.isEmpty) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: appColors.appLightColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 20
                              ),
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.block_outlined, color: appColors.lightColor.withOpacity(.2),),
                                  const SizedBox(width: 10,),
                                  MyTextView(
                                    "Vous n'avez ajouté aucune invitation",
                                    textAligntNew: TextAlign.start,
                                    maxLinesNew: 3,
                                    styleNew: MyTextStyle(
                                      colorNew: appColors.lightColor.withOpacity(.2),
                                      fontWeightNew: FontWeight.w400,
                                      size: ResponsiveFlutter.of(context).fontSize(1.8),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: ResponsiveFlutter.of(context).verticalScale(15),
                                left: ResponsiveFlutter.of(context).scale(20),
                                right: ResponsiveFlutter.of(context).scale(20),
                              ),
                              child: ListView.builder(
                                itemCount: invitationViewModel.invitationsList.data!.length,
                                itemBuilder: (context, index) {
                                  InvitationModel invitation = invitationViewModel.invitationsList.data![index];
                                  return GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          backgroundColor: appColors.appMediumColor,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only( // <-- SEE HERE
                                              topLeft: Radius.circular(30.0),
                                              topRight: Radius.circular(30.0),
                                            ),
                                          ),
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    MyTextView(
                                                      invitation.civility! + " " + invitation.name!,
                                                      textAligntNew: TextAlign.center,
                                                      styleNew: MyTextStyle(
                                                        colorNew: appColors.lightColor,
                                                        fontWeightNew: FontWeight.w400,
                                                        size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: Colors.orange
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                      child: MyTextView(
                                                        "En attente de la réponse",
                                                        textAligntNew: TextAlign.center,
                                                        styleNew: MyTextStyle(
                                                          colorNew: appColors.lightColor,
                                                          fontWeightNew: FontWeight.w600,
                                                          size: ResponsiveFlutter.of(context).fontSize(1.3),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20,),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: appColors.appLightColor
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          MyTextView(
                                                            "Téléphone",
                                                            textAligntNew: TextAlign.center,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.lightColor.withOpacity(.5),
                                                              fontWeightNew: FontWeight.w400,
                                                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                            ),
                                                          ),
                                                          MyTextView(
                                                            "+243 " + invitation.phoneNumber!,
                                                            textAligntNew: TextAlign.center,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.lightColor,
                                                              fontWeightNew: FontWeight.w600,
                                                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: appColors.appLightColor
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          MyTextView(
                                                            "Table",
                                                            textAligntNew: TextAlign.center,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.lightColor.withOpacity(.5),
                                                              fontWeightNew: FontWeight.w400,
                                                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                            ),
                                                          ),
                                                          MyTextView(
                                                            " - ",
                                                            textAligntNew: TextAlign.center,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.lightColor,
                                                              fontWeightNew: FontWeight.w600,
                                                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: appColors.appLightColor
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          MyTextView(
                                                            "Boisson",
                                                            textAligntNew: TextAlign.center,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.lightColor.withOpacity(.5),
                                                              fontWeightNew: FontWeight.w400,
                                                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                            ),
                                                          ),
                                                          MyTextView(
                                                            " - ",
                                                            textAligntNew: TextAlign.center,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.lightColor,
                                                              fontWeightNew: FontWeight.w600,
                                                              size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20,),
                                                    SizedBox(height: ResponsiveFlutter.of(context).verticalScale(10)),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                        bottom: ResponsiveFlutter.of(context).moderateScale(15),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                      decoration: BoxDecoration(
                                        color: appColors.appLightColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              MyTextView(
                                                                invitation.civility.toString(),
                                                                textAligntNew: TextAlign.center,
                                                                styleNew: MyTextStyle(
                                                                  colorNew: appColors.lightPinkColor.withOpacity(.5),
                                                                  fontWeightNew: FontWeight.w400,
                                                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                ),
                                                              ),
                                                              const SizedBox(width: 5,),
                                                              MyTextView(
                                                                invitation.name.toString(),
                                                                textAligntNew: TextAlign.center,
                                                                styleNew: MyTextStyle(
                                                                  colorNew: appColors.lightColor,
                                                                  fontWeightNew: FontWeight.w600,
                                                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 3,),
                                                          MyTextView(
                                                            "+243 " + invitation.phoneNumber.toString(),
                                                            textAligntNew: TextAlign.center,
                                                            styleNew: MyTextStyle(
                                                              colorNew: appColors.lightColor.withOpacity(.5),
                                                              fontWeightNew: FontWeight.w400,
                                                              size: ResponsiveFlutter.of(context).fontSize(1.2),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              if (invitation.status == 'created')
                                                GestureDetector(
                                                  onTap: () {
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
                                                                          SizedBox(
                                                                            height: 60,
                                                                            width: 60,
                                                                            child: Center(
                                                                              child: Icon(
                                                                                Icons.question_mark_rounded,
                                                                                color: appColors.btnColor,
                                                                                size: 50,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 10,),
                                                                          Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text("Comment voulez-vous partagere ${ invitation.count == null || invitation.count! > 1 ? 'au' : 'à' } ${invitation.civility! + " " + invitation.name!} son invitaion ?", style: const TextStyle(
                                                                                  fontWeight: FontWeight.bold
                                                                              ), textAlign: TextAlign.center,),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(height: 20,),
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                              if (!sending) {
                                                                                setState(() {
                                                                                  sending = true;
                                                                                });
                                                                                invitationViewModel.sendInvitation(context,
                                                                                    {
                                                                                      "method": "sms"
                                                                                    }, invitation.id!);
                                                                              }
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
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  const Icon(Icons.sms_outlined, size: 22,),
                                                                                  const SizedBox(width: 7,),
                                                                                  MyTextView(
                                                                                    "Envoyer par SMS",
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
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                  border: Border.all(color: appColors.appLightColor.withOpacity(.5), width: 1),
                                                                                  borderRadius: BorderRadius.circular(10)
                                                                              ),
                                                                              margin: const EdgeInsets.only(bottom: 10),
                                                                              width: MediaQuery.of(context).size.width,
                                                                              padding: const EdgeInsets.all(10),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Image.asset(ImagePath.wpp, width: 25,),
                                                                                      const SizedBox(width: 7,),
                                                                                      MyTextView(
                                                                                        "Envoyer par WhatsApp",
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
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                  border: Border.all(color: appColors.appLightColor.withOpacity(.5), width: 1),
                                                                                  borderRadius: BorderRadius.circular(10)
                                                                              ),
                                                                              margin: const EdgeInsets.only(bottom: 10),
                                                                              width: MediaQuery.of(context).size.width,
                                                                              padding: const EdgeInsets.all(10),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Image.asset(ImagePath.telegram, width: 25,),
                                                                                      const SizedBox(width: 7,),
                                                                                      MyTextView(
                                                                                        "Envoyer par Telegram",
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
                                                                          GestureDetector(
                                                                            onTap: () {
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                  border: Border.all(color: appColors.appLightColor.withOpacity(.5), width: 1),
                                                                                  borderRadius: BorderRadius.circular(10)
                                                                              ),
                                                                              margin: const EdgeInsets.only(bottom: 10),
                                                                              width: MediaQuery.of(context).size.width,
                                                                              padding: const EdgeInsets.all(10),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      const Icon(Icons.copy_rounded, size: 22,),
                                                                                      const SizedBox(width: 7,),
                                                                                      MyTextView(
                                                                                        "Copier le lien",
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
                                                                          const SizedBox(height: 20,),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                },
                                                                                child: CommonButton(
                                                                                  title: "Continuer",
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
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: appColors.btnColor
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        MyTextView(
                                                          "Envoyer",
                                                          textAligntNew: TextAlign.center,
                                                          styleNew: MyTextStyle(
                                                            colorNew: appColors.lightColor,
                                                            fontWeightNew: FontWeight.w700,
                                                            size: ResponsiveFlutter.of(context).fontSize(1.3),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 5,),
                                                        Icon(Icons.share_outlined, color: appColors.lightColor, size: 12,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              if (invitation.status == 'sent')
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.orange
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                                                  child: Icon(Icons.history_rounded, color: appColors.lightColor, size: 15,)
                                                ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          );
                      }
                    }
                )
            ),
          ],
        ),
      ),
    );
  }
}