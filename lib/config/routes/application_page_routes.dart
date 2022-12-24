import 'package:flutter/material.dart';
import 'package:service365_admin_panel/landing_screen/dashboard/screens/dashboard_screen.dart';
import 'package:service365_admin_panel/utility/loading_indicator.dart';

class ScreenRouter {
  ScreenRouter();

  Route onGeneratedRouter(RouteSettings _routeSettings) {
    String? _routeName = _routeSettings.name;

    switch (_routeName) {
      case DashBoardScreen.routeName:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: _routeSettings.arguments),
          builder: (_) => const DashBoardScreen(),
        );
      //

      default:
        return errorRoute();
    }
  }

  static Route errorRoute() => MaterialPageRoute(
        settings: const RouteSettings(name: '/error'),
        builder: (_) => const Scaffold(
          body: Center(
            child: LoadingIndicator(
              color: Colors.red,
              strokeWidth: 5,
            ),
          ),
        ),
      );
}
