import 'package:flutter/material.dart';
import 'package:sqlite_provider_starter/pages/login.dart';
import 'package:sqlite_provider_starter/pages/register.dart';
import 'package:sqlite_provider_starter/pages/todo_page.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registerPage = '/registerPage';
  static const String todoPage = '/todoPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => Login(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => Register(),
        );

      case todoPage:
        return MaterialPageRoute(
          builder: (context) => TodoPage(),
        );

      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
