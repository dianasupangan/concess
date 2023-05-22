import 'dart:io';

import 'package:concess/provider/concess_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../../global/httpoverride.dart';
import '../../../global/link_hedear.dart';
import '../../../provider/items_provider.dart';
import '../../home/home_screen.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController();
    final passwordController = TextEditingController();

    bool isUsername = false;
    bool isPassword = false;
    return Consumer<Concess>(
      builder: (context, concessUser, child) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Colors.white),
        child: SizedBox(
          height: 300,
          width: 450,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                    contentPadding: EdgeInsets.fromLTRB(10, 8, 20, 8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color.fromRGBO(84, 148, 98, 1.000),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    contentPadding: EdgeInsets.fromLTRB(10, 8, 20, 8),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Color.fromRGBO(84, 148, 98, 1.000),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ElevatedButton(
                  onPressed: () {
                    final userName = userNameController.text.toString();
                    final password = passwordController.text.toString();
                    logIn(userName, password, context, concessUser);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(84, 148, 98, 1.000),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(
                    "Log in",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(
              //       onPressed: () {},
              //       child: Padding(
              //         padding: const EdgeInsets.fromLTRB(0, 8, 20, 100),
              //         child: Text(
              //           "Forgot Password?",
              //           style: TextStyle(
              //             color: Color.fromRGBO(113, 171, 126, 1.000),
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logIn(
    String userName,
    String password,
    BuildContext context,
    Concess concess,
  ) async {
    if (userName.isNotEmpty && password.isNotEmpty) {
      final itemData = Provider.of<Items>(context, listen: false);
      print('Fetch');
      final url =
          '${link_header}state=conces_login&username=$userName&password=$password';

      final uri = Uri.parse(url);
      HttpOverrides.global = MyHttpOverrides();
      final response = await http.get(uri);
      final utf = utf8.decode(response.bodyBytes);
      final json = jsonDecode(utf);
      final result = json;

      print(result['status']);
      print(url);

      if (result['status'] == 'ok') {
        final url =
            '${link_header}state=conces_login&username=$userName&password=$password';

        final uri = Uri.parse(url);
        HttpOverrides.global = MyHttpOverrides();
        final response = await http.get(uri);
        final utf = utf8.decode(response.bodyBytes);
        final json = jsonDecode(utf);
        final result = json;

        final concessInfo = result['conces'][0];
        final categoryCd = concessInfo['category_cd'];
        final subCatCd = concessInfo['subcat_cd'];
        final classCd = concessInfo['class_cd'];
        final subClassCd = concessInfo['subclass_cd'];
        final locationCode = concessInfo['location_code'];

        validMessage("Log In successful");

        itemData.clear();
        concess.clear();

        concess.add(categoryCd, subCatCd, classCd, subClassCd, locationCode);

        final url1 =
            '${link_header}state=conces_Read&category_cd=$categoryCd&subcat_cd=$subCatCd&class_cd=$classCd&subclass_cd=$subClassCd';
        final uri1 = Uri.parse(url1);
        HttpOverrides.global = MyHttpOverrides();
        final response1 = await http.get(uri1);
        final utf1 = utf8.decode(response1.bodyBytes);
        final json1 = jsonDecode(utf1) as Map;
        final result1 = json1['items'] as List;

        for (var i = 0; i < result1.length; i++) {
          itemData.add(result1[i]['item_code'], result1[i]['description'],
              result1[i]['retail_price']);
        }
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else if (result['status'] == "error") {
        invalidMessage("Invalid Credentials");
      }
    } else if (userName.isEmpty || password.isEmpty) {
      invalidMessage("Please complete form");
    }
  }

  void validMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void invalidMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
