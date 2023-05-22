import 'package:concess/screens/home/components/item_card_list.dart';
import 'package:concess/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

import 'components/add.dart';
// import 'components/item_list.dart';
import 'package:flutter/material.dart';
import "../../provider/concess_provider.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Text('Modal bottom sheet'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Concess>(
      builder: (context, concessUser, child) =>
          concessUser.items.isEmpty == true
              ? LogInScreen()
              : Scaffold(
                  appBar: AppBar(
                    leading: GestureDetector(
                      child: Icon(
                        Icons.logout,
                        color: Color.fromRGBO(113, 171, 126, 1.000),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .popAndPushNamed(LogInScreen.routeName);
                      },
                    ),
                    title: Text(
                      "Concession Items",
                      style: TextStyle(
                        color: Color.fromRGBO(113, 171, 126, 1.000),
                      ),
                    ),
                  ),
                  body: ItemCardList(),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Color.fromRGBO(84, 148, 98, 1.000),
                    onPressed: () {
                      navigateToAdd(concessUser);
                    },
                    child: Icon(Icons.add),
                  ),
                ),
    );
  }

  Future<void> navigateToAdd(Concess concessUser) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return AddItem(
            categoryCode: concessUser.items.first.categoryCode,
            subCatCode: concessUser.items.first.subCatCode,
            classCode: concessUser.items.first.classCode,
            subClassCode: concessUser.items.first.subClassCode,
            locationCode: concessUser.items.first.locationCode);
      },
    );
  }
}
