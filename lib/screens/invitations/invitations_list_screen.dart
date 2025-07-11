import 'package:flutter/services.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/event/event_category_model.dart';
import 'package:kuuwaa/model/event/event_model.dart';
import 'package:kuuwaa/model/invitation/invitation_model.dart';
import 'package:kuuwaa/model/table/table_model.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/resource/config/app_url.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/screens/bottom_bar_screen.dart';
import 'package:kuuwaa/screens/events/payment_screen.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/invitation/invitation_view_model.dart';
import 'package:kuuwaa/view_model/table/table_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InvitationsListScreen extends StatefulWidget {
  EventModel event;
  InvitationsListScreen({Key? key, required this.event}) : super(key: key);

  @override
  _InvitationsListScreenState createState() => _InvitationsListScreenState();
}

class _InvitationsListScreenState extends State<InvitationsListScreen> {
  AppColors appColors = AppColors();
  InvitationViewModel invitationViewModel = InvitationViewModel();

  bool loading = false;
  bool editing = false;
  bool sending = false;

  bool sendingAllSMS = false;
  bool sendingAllWpp = false;
  bool sendingSMS = false;
  bool sendingWpp = false;
  bool copying = false;

  UserModel? user;

  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  TableViewModel tableViewModel = TableViewModel();

  var maskFormatter = MaskTextInputFormatter(
      mask: '*## ### ###',
      filter: { "#": RegExp(r'\d'), "*": RegExp(r'[7-9]') },
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

  bool isGroup = false;

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
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    civilities.insert(0, dropDownValue as Map);
    invitationViewModel.listingApi(context, widget.event.id!);
    List<TableModel> fetchedTables = [tableDropDownValue as TableModel];
    tableViewModel.listingApi(context, widget.event.id!).then((value) {
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
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _nameController.text = "";
                    _countController.text = "";
                    showModalBottomSheet(
                      isScrollControlled: true,
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
                                                Map valueMap = value as Map;
                                                if (valueMap["count"] == null) {
                                                  isGroup = true;
                                                } else {
                                                  isGroup = false;
                                                }
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
                                            keyboardType: TextInputType.text,
                                            icon: true,
                                          ),
                                        ),
                                        if (isGroup)
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
                                            controller: _countController,
                                            hintText: "Nombre de personnes",
                                            keyboardType: TextInputType.number,
                                            icon: true,
                                          ),
                                        ),
                                        if (widget.event.hasTables == true)
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
                                        const SizedBox(height: 5,),
                                        if (widget.event.hasTables == true)
                                        Text("Pour attacher une table vous devez commencer par enrégistrer des tables dans le ménu Table. (Vous pouvez faire cette opération plutard puis modifier l'invitation pour attacher la table)", style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.black.withOpacity(.5),
                                          fontStyle: FontStyle.italic
                                        ),),
                                        const SizedBox(height: 10,),
                                        GestureDetector(
                                          onTap: () async {
                                            TableModel dropdownTable = tableDropDownValue as TableModel;
                                            Map civility = dropDownValue as Map;
                                            if (civility["count"] == 0) {
                                              Utils.flushBarErrorMessage("Vous devez séléctionner une civilité", context);
                                            } else if (_nameController.text == "") {
                                              Utils.flushBarErrorMessage("Vous devez enter le nom de l'invité", context);
                                            } else if (civility["count"] == null && _countController.text == "") {
                                              Utils.flushBarErrorMessage("Vous devez enter le nombre des invités pour une invitation de groupe", context);
                                            } else {
                                              setState(() {
                                                loading = true;
                                              });

                                              Map data = {
                                                "civility": civility["name"],
                                                "count": civility["count"] ?? int.parse(_countController.text),
                                                "name": _nameController.text,
                                                "eventId": widget.event.id,
                                              };

                                              if (dropdownTable.id != null) {
                                                data["tableId"] = dropdownTable.id;
                                              }

                                              await invitationViewModel.addInvitation(context, data).then((value) {
                                                setState(() {
                                                  loading = false;
                                                  _nameController.text = "";
                                                  for (var element in tables) {
                                                    if (element.id == null) {
                                                      tableDropDownValue = element;
                                                    }
                                                  }
                                                  for (var element in civilities) {
                                                    if (element['count'] == 0) {
                                                      dropDownValue = element;
                                                    }
                                                  }
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
                    width: MediaQuery.of(context).size.width - 95,
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
                            colorNew: appColors.white,
                            fontWeightNew: FontWeight.w600,
                            size: ResponsiveFlutter.of(context).fontSize(1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    invitationViewModel.listingApi(context, widget.event.id!);
                  },
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: appColors.black,
                      shape: BoxShape.circle
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.refresh, color: Colors.white, size: 20,),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase().trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Rechercher...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: appColors.appLightColor,
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: .5, color: appColors.darkGreyText.withOpacity(.2)),
                  ),
                ),
              ),
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
                          List<InvitationModel> invitations = value.invitationsList.data;
                          List<InvitationModel> filteredInvitations = invitations.where((invite) {
                            final name = invite.name?.toLowerCase() ?? '';
                            final table = invite.table?.name?.toLowerCase() ?? '';
                            final beverage = invite.beverage?.name?.toLowerCase() ?? '';

                            return name.contains(searchQuery) ||
                                table.contains(searchQuery) ||
                                beverage.contains(searchQuery);
                          }).toList();

                          if (filteredInvitations.isEmpty) {
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
                                    "Aucune invitation trouvée",
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
                                padding: EdgeInsets.zero,
                                itemCount: filteredInvitations.length,
                                itemBuilder: (context, index) {
                                  InvitationModel invitation = filteredInvitations[index];
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
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return Padding(
                                                  padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                                            if (invitation.status != 'created' && invitation.status != 'refused')
                                                            const SizedBox(width: 10,),
                                                            if (invitation.status != 'created' && invitation.status != 'refused')
                                                              const Icon(CupertinoIcons.check_mark_circled, color: Colors.green, size: 15,)
                                                          ],
                                                        ),
                                                        const SizedBox(height: 10,),
                                                        if (invitation.count! > 1)
                                                        const SizedBox(height: 10,),
                                                        if (invitation.count! > 1)
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
                                                                "Nombre d'invités",
                                                                textAligntNew: TextAlign.center,
                                                                styleNew: MyTextStyle(
                                                                  colorNew: appColors.lightColor.withOpacity(.5),
                                                                  fontWeightNew: FontWeight.w400,
                                                                  size: ResponsiveFlutter.of(context).fontSize(1.5),
                                                                ),
                                                              ),
                                                              MyTextView(
                                                                invitation.count.toString(),
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
                                                        if (widget.event.hasTables == true)
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
                                                                (invitation.table == null ? " - " : invitation.table!.name.toString()),
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
                                                        if (widget.event.hasTables == true)
                                                          const SizedBox(height: 10,),
                                                        if (widget.event.hasBeverage == true)
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
                                                                invitation.beverage == null ? "-" : invitation.beverage!.name!,
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
                                                        if (widget.event.hasBeverage == true)
                                                          const SizedBox(height: 10,),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _nameController.text = invitation.name.toString();
                                                              _countController.text = invitation.count.toString();
                                                              for (var element in civilities) {
                                                                if (element["name"] == invitation.civility) {
                                                                  dropDownValue = element;
                                                                }
                                                              }
                                                              if (invitation.table != null) {
                                                                for (var element in tables) {
                                                                  if (element.id == invitation.table!.id) {
                                                                    tableDropDownValue = element;
                                                                  }
                                                                }
                                                              }
                                                            });
                                                            showModalBottomSheet(
                                                                isScrollControlled: true,
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
                                                                                  "Modifier l'invitation " + (invitation.count! > 1 ? "du " : "de ") + invitation.civility! + " " + invitation.name!,
                                                                                  textAligntNew: TextAlign.center,
                                                                                  maxLinesNew: 4,
                                                                                  styleNew: MyTextStyle(
                                                                                    colorNew: appColors.black,
                                                                                    fontWeightNew: FontWeight.w600,
                                                                                    size: ResponsiveFlutter.of(context).fontSize(2),
                                                                                  ),
                                                                                ),const SizedBox(height: 15,),
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
                                                                                        Map valueMap = value as Map;
                                                                                        if (valueMap["count"] == null) {
                                                                                          isGroup = true;
                                                                                        } else {
                                                                                          isGroup = false;
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                if (isGroup)
                                                                                  const SizedBox(height: 10,),
                                                                                if (isGroup)
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
                                                                                      controller: _countController,
                                                                                      hintText: "Nombre de personnes",
                                                                                      keyboardType: TextInputType.number,
                                                                                      icon: true,
                                                                                    ),
                                                                                  ),
                                                                                if (!isGroup)
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
                                                                                    keyboardType: TextInputType.text,
                                                                                    icon: true,
                                                                                  ),
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    TableModel dropdownTable = tableDropDownValue as TableModel;
                                                                                    Map civility = dropDownValue as Map;
                                                                                    if (civility["count"] == 0) {
                                                                                      Utils.flushBarErrorMessage("Vous devez séléctionner une civilité", context);
                                                                                    } else if (_nameController.text == "") {
                                                                                      Utils.flushBarErrorMessage("Vous devez enter le nom de l'invité", context);
                                                                                    } else if (civility["count"] == null && _countController.text == "") {
                                                                                      Utils.flushBarErrorMessage("Vous devez enter le nombre des invités pour une invitation de groupe", context);
                                                                                    } else {
                                                                                      setState(() {
                                                                                        editing = true;
                                                                                      });

                                                                                      Map data = {
                                                                                        "civility": civility["name"],
                                                                                        "count": civility["count"] ?? int.parse(_countController.text),
                                                                                        "name": _nameController.text,
                                                                                      };

                                                                                      if (dropdownTable.id != null) {
                                                                                        data["tableId"] = dropdownTable.id;
                                                                                      }

                                                                                      invitationViewModel.editInvitation(context, data, invitation.id!).then((value) {
                                                                                        setState(() {
                                                                                          editing = false;
                                                                                        });
                                                                                        Navigator.pop(context);
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  child: CommonButton(
                                                                                    title: "Enrégistrer",
                                                                                    loading: editing,
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
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                color: appColors.appLightColor
                                                            ),
                                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                MyTextView(
                                                                  "Modifier",
                                                                  textAligntNew: TextAlign.center,
                                                                  styleNew: MyTextStyle(
                                                                    fontWeightNew: FontWeight.w400,
                                                                    colorNew: Colors.black,
                                                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                  ),
                                                                ),
                                                                Icon(Icons.edit, color: appColors.black, size: 15,)
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 10,),
                                                        if (user != null)
                                                        GestureDetector(
                                                          onTap: () {
                                                            if ((widget.event.template!.price ?? 0) <= (user!.credits ?? 0)) {
                                                              invitationViewModel.sendInvitation(context, {
                                                                'userId': user!.id
                                                              }, invitation.id!, widget.event).then((value) {
                                                                if (value) {
                                                                  SharePlus.instance.share(
                                                                      ShareParams(text: invitation.message)
                                                                  );
                                                                }
                                                              });
                                                            }  else {
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (
                                                                      context) {
                                                                    return StatefulBuilder(
                                                                      builder: (
                                                                          context,
                                                                          setState) {
                                                                        return Dialog(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                  10),
                                                                            ),
                                                                            child: Stack(
                                                                              children: [
                                                                                Positioned(
                                                                                    right: 0,
                                                                                    top: 0,
                                                                                    child: IconButton(
                                                                                        onPressed: () {
                                                                                          Navigator
                                                                                              .pop(
                                                                                              context);
                                                                                        },
                                                                                        icon: const Icon(
                                                                                            Icons
                                                                                                .close)
                                                                                    )
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets
                                                                                      .symmetric(
                                                                                      vertical: 20,
                                                                                      horizontal: 30),
                                                                                  child:
                                                                                  Column(
                                                                                    mainAxisSize: MainAxisSize
                                                                                        .min,
                                                                                    children: [
                                                                                      Image.asset("assets/icon/coins.png", width: 50,),
                                                                                      const SizedBox(
                                                                                        height: 10,),
                                                                                      Column(
                                                                                        mainAxisSize: MainAxisSize
                                                                                            .min,
                                                                                        children: [
                                                                                          MyTextView(
                                                                                            "Vous ne pouvez pas partager cette invitation",
                                                                                            textAligntNew: TextAlign
                                                                                                .start,
                                                                                            maxLineWrap: true,
                                                                                            styleNew: MyTextStyle(
                                                                                              colorNew: appColors
                                                                                                  .red,
                                                                                              fontWeightNew: FontWeight
                                                                                                  .w600,
                                                                                              size: ResponsiveFlutter
                                                                                                  .of(
                                                                                                  context)
                                                                                                  .fontSize(
                                                                                                  2),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 10,),
                                                                                          MyTextView(
                                                                                            "Vous devez avoir au moins " + (widget.event.template!.price!.toInt()).toString() + " crédits pour envoyer cette invitation.",
                                                                                            textAligntNew: TextAlign
                                                                                                .start,
                                                                                            maxLineWrap: true,
                                                                                            styleNew: MyTextStyle(
                                                                                              colorNew: appColors
                                                                                                  .black,
                                                                                              fontWeightNew: FontWeight
                                                                                                  .w500,
                                                                                              size: ResponsiveFlutter
                                                                                                  .of(
                                                                                                  context)
                                                                                                  .fontSize(
                                                                                                  1.5),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 20,),
                                                                                      GestureDetector(
                                                                                        onTap: () async {
                                                                                          Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                              builder: (context) => const BottomBarScreen(isFrom: "Wallet",),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        child: CommonButton(
                                                                                          title: "Recharger", icon: CupertinoIcons.money_dollar_circle, textColor: Colors.white, btnColor: Colors.black,
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
                                                                  }
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                color: appColors.btnColor
                                                            ),
                                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                MyTextView(
                                                                  "Envoyer",
                                                                  textAligntNew: TextAlign.center,
                                                                  styleNew: MyTextStyle(
                                                                    fontWeightNew: FontWeight.w400,
                                                                    colorNew: Colors.white,
                                                                    size: ResponsiveFlutter.of(context).fontSize(1.8),
                                                                  ),
                                                                ),
                                                                Icon(widget.event.canSendInvitations == true ? Icons.send : CupertinoIcons.lock_fill, color: appColors.white, size: 15,)
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 20,),
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
                                      width: double.infinity,
                                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      decoration: BoxDecoration(
                                        color: appColors.appLightColor,
                                        border: Border(bottom: BorderSide(color: appColors.appMediumColor, width: 2))
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
                                                              if (widget.event.canSendInvitations != true)
                                                              const Icon(CupertinoIcons.lock_fill, size: 15,),
                                                              if (widget.event.canSendInvitations != true)
                                                              const SizedBox(width: 5,),
                                                              MyTextView(
                                                                invitation.civility.toString(),
                                                                textAligntNew: TextAlign.center,
                                                                styleNew: MyTextStyle(
                                                                  colorNew: appColors.btnColor.withOpacity(.8),
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
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.menu, color: appColors.lightColor, size: 15,)
                                                    ],
                                                  ),
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