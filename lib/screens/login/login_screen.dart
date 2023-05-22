import 'package:concess/screens/login/components/login_form.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});
  static const routeName = '/log-in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(242, 220, 242, 220),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              child: Image.asset('assets/icon.png'),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(64, 97, 71, 1.00),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 50),
              child: Text(
                "Please sign in to continue.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(64, 97, 71, 1.00),
                ),
              ),
            ),
            LogInForm(),
          ],
        ),
      ),
    );
  }
}
