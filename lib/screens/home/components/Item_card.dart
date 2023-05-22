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
  bool isLoading = true;

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
    // print("$itemCode, $description, $price");
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
    setState(() {
      isLoading = true;
    });
  }

  void deleteByID(String itemCode, String description, String price,
      Concess concessData) async {
    print("$itemCode $description $price");
    final url =
        '${link_header}state=conces_Delete&category_cd=${concessData.items.first.categoryCode}&subcat_cd=${concessData.items.first.subCatCode}&class_cd=${concessData.items.first.classCode}&subclass_cd=${concessData.items.first.subClassCode}&description=$description&retail_price=$price&location_code=${concessData.items.first.locationCode}&item_code=$itemCode';
    print(url);
    HttpOverrides.global = MyHttpOverrides();
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final utf = utf8.decode(response.bodyBytes);
    final json = jsonDecode(utf);
    final result = json['status'];

    print(result);

    final itemData = Provider.of<Items>(context, listen: false);
    if (result == 'ok') {
      itemData.delete(itemCode);
    } else {}
  }
}
