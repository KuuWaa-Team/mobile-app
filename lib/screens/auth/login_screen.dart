import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/common_widget.dart';
import 'package:kuuwaa/common/image_path.dart';
import 'package:kuuwaa/common/strings.dart';
import 'package:kuuwaa/common/utils.dart';
import 'package:kuuwaa/responsive/responsive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kuuwaa/service/notifications_service.dart';
import 'package:kuuwaa/view_model/auth/auth_view_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppColors appColors = AppColors();
  ImagePath imagePath = ImagePath();
  bool loadingGoogle = false;
  bool loadingApple = false;
  AuthViewModel authViewModel = AuthViewModel();
  NotificationsService? notificationsService;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _firebaseAuth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    setState(() {
      try {
        notificationsService = NotificationsService();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  void _handleGoogleSignIn() async {
    setState(() {
      loadingGoogle = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _firebaseAuth.signInWithCredential(credential).then((value) async {
          final user = value.user;
          final idToken = await user?.getIdToken();
          final email = user?.email;
          final name = user?.displayName;
          final avatar = user?.photoURL;
          String phoneId = "";

          if (notificationsService != null) {
            try {
              notificationsService!.isTokenRefresh();
              await notificationsService!.getDeviceToken().then((value) {
                phoneId = value ?? "";
              });
            } catch (e) {
              print(e.toString());
            }
          }

          final userData = {
            "firebase_token": idToken,
            "email": email,
            "password": "password",
            "displayName": name,
            "photoUrl": avatar,
            "provider": "google",
            "uid": user?.uid,
            "phoneId": phoneId
          };

          await authViewModel.loginApi(userData, context);
        });
      }
    }
    catch (error) {
      Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plus tard.", context);
    } finally {
      setState(() {
        loadingGoogle = false;
      });
    }
  }

  void _handleAppleSignIn() async {
    setState(() {
      loadingApple = true;
    });

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthCredentials = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode
      );

      await _firebaseAuth.signInWithCredential(oAuthCredentials).then((value) async {
        final user = value.user;
        final idToken = await user?.getIdToken();
        final email = user?.email;

        String name = "";
        if (credential.givenName != null && credential.familyName != null) {
          name = "${credential.givenName} ${credential.familyName}";
        } else {
          name = user?.displayName ?? ""; // fallback
        }

        Utils.flushBarErrorMessage(name, context);

        final avatar = user?.photoURL;
        String phoneId = "";

        if (notificationsService != null) {
          try {
            notificationsService!.isTokenRefresh();
            await notificationsService!.getDeviceToken().then((value) {
              phoneId = value ?? "";
            });
          } catch (e) {
            print(e.toString());
          }
        }

        final userData = {
          "firebase_token": idToken,
          "email": email,
          "password": "password",
          "displayName": name,
          "photoUrl": avatar,
          "provider": "Apple",
          "uid": user?.uid,
          "phoneId": phoneId
        };

        await authViewModel.loginApi(userData, context);
      });
    } catch (error) {
      Utils.flushBarErrorMessage("Une erreur est survenue. Veuillez réessayer plus tard.", context);
      print(error.toString());
    } finally {
      setState(() {
        loadingApple = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: appColors.appMediumColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
          systemNavigationBarDividerColor: appColors.appMediumColor
      ),
    );
    return Scaffold(
      backgroundColor: appColors.appMediumColor,
      body: SafeArea(
        top: false,
        bottom: Platform.isIOS ? false : true,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/authbg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        appColors.btnColor.withOpacity(.9),
                        Colors.black.withOpacity(0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: appColors.appMediumColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Image.asset("assets/images/logo.png", width: 40),
                                const SizedBox(width: 15,),
                                Flexible(
                                  child: MyTextView(
                                    Strings.login,
                                    textAligntNew: TextAlign.left,
                                    maxLinesNew: 5,
                                    styleNew: MyTextStyle(
                                      colorNew: appColors.lightColor,
                                      size: ResponsiveFlutter.of(context).fontSize(2.1),
                                      fontWeightNew: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15,),
                          Divider(color: appColors.grey.withOpacity(.1), height: 1,),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.create, color: appColors.btnColor, size: 20,),
                                    const SizedBox(width: 10,),
                                    Flexible(
                                      child: MyTextView(
                                        "Créez votre évenement en moins de une minutes",
                                        maxLinesNew: 4,
                                        textAligntNew: TextAlign.left,
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.mediumGrayColor,
                                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                                          fontWeightNew: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8,),
                                Divider(color: appColors.grey.withOpacity(.1), height: 1,),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Icon(Icons.design_services, color: appColors.btnColor, size: 20,),
                                    const SizedBox(width: 10,),
                                    Flexible(
                                      child: MyTextView(
                                        "Choisissez un template de design pour vos invitations",
                                        maxLinesNew: 4,
                                        textAligntNew: TextAlign.left,
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.mediumGrayColor,
                                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                                          fontWeightNew: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8,),
                                Divider(color: appColors.grey.withOpacity(.1), height: 1,),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Icon(Icons.people_alt_outlined, color: appColors.btnColor, size: 20,),
                                    const SizedBox(width: 10,),
                                    Flexible(
                                      child: MyTextView(
                                        "Enregistrez vos invités et partagez vos invitations rapidement",
                                        maxLinesNew: 4,
                                        textAligntNew: TextAlign.left,
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.mediumGrayColor,
                                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                                          fontWeightNew: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8,),
                                Divider(color: appColors.grey.withOpacity(.1), height: 1,),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Icon(Icons.my_library_books_outlined, color: appColors.btnColor, size: 20,),
                                    const SizedBox(width: 10,),
                                    Flexible(
                                      child: MyTextView(
                                        "Interagissez avec vos invités avec notre livre d'or text et audio",
                                        maxLinesNew: 4,
                                        textAligntNew: TextAlign.left,
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.mediumGrayColor,
                                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                                          fontWeightNew: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8,),
                                Divider(color: appColors.grey.withOpacity(.1), height: 1,),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Icon(Icons.light_mode_rounded, color: appColors.btnColor, size: 20,),
                                    const SizedBox(width: 10,),
                                    Flexible(
                                      child: MyTextView(
                                        "Découvrez plein d'autres fonctionnalités innovantes de KuuWaa",
                                        maxLinesNew: 4,
                                        textAligntNew: TextAlign.left,
                                        styleNew: MyTextStyle(
                                          colorNew: appColors.mediumGrayColor,
                                          size: ResponsiveFlutter.of(context).fontSize(1.8),
                                          fontWeightNew: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8,),
                                Divider(color: appColors.grey.withOpacity(.1), height: 1,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 20.0, top: 20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 1, color: Colors.black)
                    ),
                    child: CupertinoButton(
                      borderRadius: BorderRadius.circular(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icon/google.png", width: 20,),
                          const SizedBox(width: 8,),
                          MyTextView(
                            "Se connecter avec Google",
                            maxLinesNew: 1,
                            textAligntNew: TextAlign.left,
                            styleNew: MyTextStyle(
                              colorNew: appColors.black,
                              size: ResponsiveFlutter.of(context).fontSize(1.8),
                              fontWeightNew: FontWeight.w600,
                            ),
                          ),
                          if (loadingGoogle)
                            const SizedBox(width: 15,),
                          if (loadingGoogle)
                            const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                        ],
                      ),
                      color: CupertinoColors.white,
                      onPressed: loadingApple ? null : _handleGoogleSignIn,
                    ),
                  ),
                  if (Platform.isIOS || Platform.isMacOS)
                  const SizedBox(height: 10,),
                  if (Platform.isIOS || Platform.isMacOS)
                  CupertinoButton(
                    borderRadius: BorderRadius.circular(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icon/apple.png", width: 20,),
                        const SizedBox(width: 8,),
                        MyTextView(
                          "Se connecter avec Apple",
                          maxLinesNew: 1,
                          textAligntNew: TextAlign.left,
                          styleNew: MyTextStyle(
                            colorNew: appColors.white,
                            size: ResponsiveFlutter.of(context).fontSize(1.8),
                            fontWeightNew: FontWeight.w600,
                          ),
                        ),
                        if (loadingApple)
                          const SizedBox(width: 15,),
                        if (loadingApple)
                            const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                      ],
                    ),
                    color: appColors.black,
                    onPressed: loadingGoogle ? null : _handleAppleSignIn,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
