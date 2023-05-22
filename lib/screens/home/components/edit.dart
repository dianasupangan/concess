import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../global/httpoverride.dart';
import '../../../global/link_hedear.dart';
import '../../../provider/concess_provider.dart';
import '../../../provider/items_provider.dart';

class EditItem extends StatefulWidget {
  final String categoryCode;
  final String subCatCode;
  final String classCode;
  final String subClassCode;
  final String locationCode;
  final String itemCode;
  final String description;
  final String price;
  const EditItem({
    super.key,
    required this.categoryCode,
    required this.subCatCode,
    required this.classCode,
    required this.subClassCode,
    required this.locationCode,
    required this.itemCode,
    required this.description,
    required this.price,
  });

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  late final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.description;
    priceController.text = widget.price;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Concess>(
      builder: (context, concessUser, child) => FractionallySizedBox(
        widthFactor: 0.7,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      enabled: false,
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
                    controller: priceController,
                    decoration: const InputDecoration(
                      hintText: "Price",
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
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (priceController.text.toString().isEmpty) {
                        showMyDialog('Please enter the price');
                      } else {
                        updateData(
                          priceController.text.toString(),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(84, 148, 98, 1.000),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Color.fromRGBO(84, 148, 98, 1.000),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text("Close"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateData(
    String price,
  ) async {
    final itemData = Provider.of<Items>(context, listen: false);
    final url =
        '${link_header}state=conces_Update&category_cd=${widget.categoryCode}&subcat_cd=${widget.subCatCode}&class_cd=${widget.classCode}&subclass_cd=${widget.subClassCode}&item_code=${widget.itemCode}&description=${widget.description}&retail_price=$price';
    print(url);
    HttpOverrides.global = MyHttpOverrides();
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final utf = utf8.decode(response.bodyBytes);
    final json = jsonDecode(utf);
    final result = json['status'];

    print(result);

    if (result == 'ok') {
      itemData.update(widget.itemCode, widget.description, price);
    } else {}
  }

  Future<void> showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
