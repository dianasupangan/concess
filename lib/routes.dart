import 'package:flutter/widgets.dart';

import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LogInScreen.routeName: (ctx) => const LogInScreen(),
  HomeScreen.routeName: (ctx) => const HomeScreen(),
};
