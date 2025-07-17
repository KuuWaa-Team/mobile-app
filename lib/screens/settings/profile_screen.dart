import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_button.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/model/user/user_model.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:kuuwaa/screens/auth/deleted_account_screen.dart';
import 'package:kuuwaa/screens/settings/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/view_model/auth/auth_view_model.dart';
import 'package:kuuwaa/view_model/user/user_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppColors appColors = AppColors();
  TabController? tabController;
  int tab = 0;
  UserModel user = UserModel();
  bool loading = false;
  AuthViewModel authViewModel = AuthViewModel();

  @override
  void initState() {
    UserViewModel().getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appColors.appMediumColor,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(
                    ResponsiveFlutter.of(context).moderateScale(20),
                  ),
                  child: Column(
                    children: [
                      // Profile photo and name
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              user.photoUrl?.isNotEmpty == true
                                  ? user.photoUrl!
                                  : "https://i.pravatar.cc/300",
                            ),
                          ),
                          SizedBox(height: 12),
                          MyTextView(
                            user.displayName ?? 'Nom inconnu',
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor,
                              fontWeightNew: FontWeight.bold,
                              size: ResponsiveFlutter.of(context).fontSize(2.5),
                            ),
                          ),
                          SizedBox(height: 4),
                          MyTextView(
                            user.email ?? '',
                            styleNew: MyTextStyle(
                              colorNew: appColors.lightColor.withOpacity(0.6),
                              size: ResponsiveFlutter.of(context).fontSize(1.8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow("Type de compte", user.provider ?? "-"),
                            _buildDetailRow("Crédits", user.credits?.toString() ?? "0"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (loading || user.id == null) ? null : () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: Text("Attention"),
                                    content: const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "Êtes-vous sûr de vouloir supprimer votre compte ?\n\n"
                                            "Toutes vos données, y compris vos événements et invitations, seront perdues de manière définitive.",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text("Annuler"),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Ferme le modal
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        child: const Text("Supprimer"),
                                        onPressed: () {
                                          final currentContext = context;

                                          setState(() {
                                            loading = true;
                                          });

                                          authViewModel.deleteAccountApi(currentContext, user.id!).then((value) {
                                            if (value) {
                                              Navigator.pushAndRemoveUntil(
                                                currentContext,
                                                MaterialPageRoute(
                                                  builder: (_) => DeletedAccountScreen(
                                                    id: user.id!,
                                                    deletedAt: DateTime.now(),
                                                  ),
                                                ),
                                                    (route) => false,
                                              );
                                            }
                                          });

                                          // Navigator.pop(context);
                                        },
                                      )

                                    ],
                                  );
                                },
                              );
                            },
                            child: CommonButton(
                              loading: loading,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              title: "Supprimer le compte",
                              icon: Icons.close,
                              btnColor: Colors.red,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

// Fonction utilitaire pour créer une ligne d’option stylée
  Widget _buildOptionTile(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Icon(icon, color: AppColors().btnColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

}
