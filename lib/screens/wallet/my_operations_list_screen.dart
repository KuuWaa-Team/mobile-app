import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/data/response/status.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/model/wallet/operation_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/shimmer/event_card_shimmer.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';
import 'package:kuuwaa/view_model/wallet/wallet_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOperationsListScreen extends StatefulWidget {
  const MyOperationsListScreen({Key? key}) : super(key: key);

  @override
  State<MyOperationsListScreen> createState() => _MyOperationsListScreenState();
}

class _MyOperationsListScreenState extends State<MyOperationsListScreen> {
  AppColors appColors = AppColors();
  bool fetched = false;
  WalletViewModel walletViewModel = WalletViewModel();
  UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) async {
      final initScreenCredits = prefs.getBool('initScreenCredits') == true;
      if (!initScreenCredits) {
        await prefs.setBool('initScreenCredits', true);
        Future.delayed(const Duration(milliseconds: 300), _showCreditsInfoDialog);
      }
    });

    UserViewModel().getUser().then((value) {
      user = value;
      if (!fetched && user.id != null) {
        walletViewModel.operations(context, user.id!);
        fetched = true;
      }
    });
  }
  void _showOperationDetails(OperationModel op) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        Color statusColor;
        String statusText;

        switch (op.status?.toUpperCase()) {
          case 'STATUS_PAID':
            statusColor = Colors.green;
            statusText = "Succès";
            break;
          case 'STATUS_FAILED':
            statusColor = Colors.red;
            statusText = "Échec";
            break;
          default:
            statusColor = Colors.orange;
            statusText = "En attente";
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            runSpacing: 10,
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(Icons.receipt_long, size: 40, color: appColors.btnColor),
                    const SizedBox(height: 8),
                    MyTextView(
                      "Détails de l'opération",
                      styleNew: MyTextStyle(
                        colorNew: appColors.btnColor,
                        fontWeightNew: FontWeight.bold,
                        size: ResponsiveFlutter.of(context).fontSize(2.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              _detailRow("Référence", op.reference.toString()),
              _detailRow("Montant", "${op.amount}\$"),
              _detailRow("Crédits", op.credits?.toString() ?? "-"),
              _detailRow("Titre", op.title ?? "-"),
              _detailRow("Tél.", op.phoneNumber ?? "-"),
              _detailRow("Méthode", op.paymentMethod ?? "-"),
              Row(
                children: [
                  Expanded(child: _detailRow("Statut", "")),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                  ),
                ],
              ),
              _detailRow("Date", _formatDate(op.date)),
              _detailRow("Type", op.type.toString()),
              _detailRow("Commande", op.orderNumber ?? "-"),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white,),
                  label: const Text("Fermer", style: TextStyle(
                    color: Colors.white
                  ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.btnColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

// Utilitaire pour formater la date proprement
  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    final formatter = DateFormat("dd/MM/yyyy à HH:mm");
    return formatter.format(date);
  }


  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyle(color: Colors.black.withOpacity(.6)))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: ChangeNotifierProvider.value(
        value: walletViewModel,
        child: Consumer<WalletViewModel>(
          builder: (_, viewModel, __) {
            final status = viewModel.operationsList.status;
            if (status == Status.LOADING) return _buildShimmerList();
            if (status == Status.ERROR) return Center(child: Text(viewModel.operationsList.message ?? 'Erreur'));

            final operations = viewModel.operationsList.data?.reversed.toList();
            if (operations == null || operations.isEmpty) return _buildEmptyMessage();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.separated(
                itemCount: operations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _buildOperationTile(operations[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOperationTile(OperationModel op) {
    final icon = op.type == OperationType.recharge ? ImagePath.greenUp : ImagePath.redDown;
    final iconColor = op.status == OperationStatus.paid ? Colors.green : (op.status == OperationStatus.waiting ? Colors.orange : Colors.red);

    return InkWell(
      onTap: () => _showOperationDetails(op),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appColors.appLightColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: iconColor, width: 2),
              ),
              child: Center(
                child: op.status == OperationStatus.paid
                    ? Image.asset(icon, height: 12)
                    : Icon(
                  op.status == OperationStatus.waiting ? Icons.refresh : Icons.close,
                  color: iconColor,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextView(
                    op.title ?? '-',
                    styleNew: MyTextStyle(
                      colorNew: appColors.lightColor,
                      fontWeightNew: FontWeight.bold,
                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                    ),
                  ),
                  Text(
                    "#${op.reference}",
                    style: TextStyle(color: appColors.transactionText, fontSize: 12),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${op.amount}\$",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: op.type == OperationType.recharge ? Colors.green : Colors.red,
                  ),
                ),
                if (op.date != null)
                  Text(
                    Utils.formatDate(op.date!),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() => Column(children: const [EventShimmer(), SizedBox(height: 10), EventShimmer()]);

  Widget _buildEmptyMessage() => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.block, color: Colors.grey.shade400),
          const SizedBox(width: 10),
          Text("Aucune opération enregistrée", style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    ),
  );


  void _showCreditsInfoDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColors.appLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          title: Column(
            children: [
              Icon(Icons.info_outline_rounded, size: 30, color: appColors.appMediumColorDark),
              const SizedBox(height: 5),
              MyTextView(
                "À propos des crédits",
                textAligntNew: TextAlign.center,
                maxLinesNew: 5,
                styleNew: MyTextStyle(
                  colorNew: appColors.lightColor,
                  fontWeightNew: FontWeight.w700,
                  size: ResponsiveFlutter.of(context).fontSize(3.5),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              MyTextView(
                "Les crédits permettent de partager les invitations électroniques.",
                textAligntNew: TextAlign.left,
                maxLinesNew: 5,
                styleNew: MyTextStyle(
                  colorNew: appColors.appMediumColorDark,
                  fontWeightNew: FontWeight.w600,
                  size: ResponsiveFlutter.of(context).fontSize(1.8),
                ),
              ),
              const SizedBox(height: 10),
              MyTextView(
                "Chaque template de design a un prix en crédit par invitation (1 crédit pour le moins coûteux).",
                textAligntNew: TextAlign.left,
                maxLinesNew: 10,
                styleNew: MyTextStyle(
                  colorNew: appColors.appMediumColorDark.withOpacity(0.8),
                  fontWeightNew: FontWeight.w500,
                  size: ResponsiveFlutter.of(context).fontSize(1.7),
                ),
              ),
              const SizedBox(height: 10),
              MyTextView(
                "5 \$ = 20 crédits",
                textAligntNew: TextAlign.left,
                styleNew: MyTextStyle(
                  colorNew: appColors.btnColor,
                  fontWeightNew: FontWeight.w700,
                  size: ResponsiveFlutter.of(context).fontSize(3.5),
                ),
              ),
              const SizedBox(height: 15),
              MyTextView(
                "La recharge peut se faire via Mobile Money ou carte de crédit.",
                textAligntNew: TextAlign.left,
                maxLinesNew: 10,
                styleNew: MyTextStyle(
                  colorNew: appColors.appMediumColorDark.withOpacity(0.8),
                  fontWeightNew: FontWeight.w500,
                  size: ResponsiveFlutter.of(context).fontSize(1.7),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Compris",
                style: TextStyle(color: appColors.btnColor, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
