import 'package:get/get.dart';

import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/dashboard/dashboard_view.dart';

class Routes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.login, page: () =>  LoginView()),
    GetPage(name: Routes.register, page: () =>  RegisterView()),
    GetPage(name: Routes.dashboard, page: () =>  DashboardView()),
  ];
}
