import 'package:concess/provider/items_provider.dart';
import 'package:concess/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/concess_provider.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Concess(),
        ),
        ChangeNotifierProvider(
          create: (context) => Items(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorSchemeSeed: Color.fromARGB(255, 126, 192, 125),
          useMaterial3: true,
        ),
        home: const LogInScreen(),
        routes: routes,
      ),
    );
  }
}
