import 'package:kuuwaa/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case RoutesName.networkError:
        // return PageTransition(
        //     child: const NetworkError(),
        //     type: PageTransitionType.bottomToTop,
        //     settings: settings
        // );
    default:
      return MaterialPageRoute(builder: (_) {
        return const Scaffold(
          body: Center(
            child: Text("No route defined"),
          ),
        );
      });
    }
  }
}