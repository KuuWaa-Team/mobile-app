import 'package:kuuwaa/common/app_colors.dart';
import 'package:kuuwaa/common/constants.dart';
import 'package:kuuwaa/screens/invitation_details_screen.dart';
import 'package:kuuwaa/screens/on_boarding/on_boarding_screen.dart';
import 'package:kuuwaa/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kuuwaa/view_model/auth/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool initScreen = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getBool('initScreen') == true;
  if (initScreen != true) {
    await preferences.setBool('initScreen', true);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppColors appColors = AppColors();
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('fr', 'FR')
        ],
        locale: const Locale('fr', 'FR'),
        title: 'KuuWaa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: appColors.primarySwatchColors,
          fontFamily: Constants.carosSoft,
        ),
        home: initScreen ? const SplashScreen(): const OnBoardingView(),
        // home: InvitationDetailsScreen(),
      )
    );
  }
}
