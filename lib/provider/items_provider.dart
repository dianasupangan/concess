import 'dart:js_interop';

import 'package:flutter/material.dart';

class ConcessItems {
  final String itemCode;
  final String description;
  late String retailPrice;

  ConcessItems({
    required this.itemCode,
    required this.description,
    required this.retailPrice,
  });
}

class Items extends ChangeNotifier {
  final List<ConcessItems> items = [];

  void add(
    String itemCd,
    String desc,
    String price,
  ) async {
    items.add(
      ConcessItems(
        itemCode: itemCd,
        description: desc,
        retailPrice: price,
      ),
    );

    notifyListeners();
  }

  void update(
    String itemCd,
    String desc,
    String price,
  ) async {
    var target = items.firstWhere((item) => item.itemCode == itemCd);
    if (!target.isNull) {
      target.retailPrice = price;
    }

    notifyListeners();
  }

  void delete(
    String itemCd,
  ) async {
    final result =
        items.where((element) => element.itemCode != itemCd).toList();
    clear();
    for (var i = 0; i < result.length; i++) {
      add(
        result[i].itemCode,
        result[i].description,
        result[i].retailPrice,
      );
    }

    notifyListeners();
  }

  void clear() {
    items.clear();

    notifyListeners();
  }
}
