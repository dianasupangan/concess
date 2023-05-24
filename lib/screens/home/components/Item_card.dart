import 'package:concess/global/link_hedear.dart';

import '../../../provider/items_provider.dart';
import 'edit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'dart:convert';
import 'dart:io';

import '../../../global/httpoverride.dart';
import '../../../provider/concess_provider.dart';

class ItemCard extends StatefulWidget {
  final String itemCode;
  final String description;
  final String retailPrice;
  const ItemCard({
    super.key,
    required this.itemCode,
    required this.description,
    required this.retailPrice,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    final concessData = Provider.of<Concess>(context);
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text(widget.description),
            subtitle: Text(
              "₱${widget.retailPrice}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: PopupMenuButton(
              onSelected: (value) {
                if (value == 'edit') {
                  navigateToEdit(
                    widget.itemCode,
                    widget.description,
                    widget.retailPrice,
                    concessData,
                  );
                } else if (value == 'delete') {
                  deleteByID(widget.itemCode, widget.description,
                      widget.retailPrice, concessData);
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text("Edit"),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text("Delete"),
                  ),
                ];
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> navigateToEdit(String itemCode, String description, String price,
      Concess concessData) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return EditItem(
          categoryCode: concessData.items.first.categoryCode,
          subCatCode: concessData.items.first.subCatCode,
          classCode: concessData.items.first.classCode,
          subClassCode: concessData.items.first.subClassCode,
          locationCode: concessData.items.first.locationCode,
          itemCode: itemCode,
          description: description,
          price: price,
        );
      },
    );
  }

  void deleteByID(String itemCode, String description, String price,
      Concess concessData) async {
    final url =
        '${link_header}state=conces_Delete&category_cd=${concessData.items.first.categoryCode}&subcat_cd=${concessData.items.first.subCatCode}&class_cd=${concessData.items.first.classCode}&subclass_cd=${concessData.items.first.subClassCode}&description=$description&retail_price=$price&location_code=${concessData.items.first.locationCode}&item_code=$itemCode';

    HttpOverrides.global = MyHttpOverrides();
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final utf = utf8.decode(response.bodyBytes);
    final json = jsonDecode(utf);
    final result = json['status'];

    final itemData = Provider.of<Items>(context, listen: false);
    if (result == 'ok') {
      itemData.delete(itemCode);
    } else {}

    showMyDialog("Item deleted");
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
