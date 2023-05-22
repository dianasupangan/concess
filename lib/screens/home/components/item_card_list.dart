import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:concess/provider/items_provider.dart';

import 'Item_card.dart';

class ItemCardList extends StatelessWidget {
  const ItemCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<Items>(context);
    final items = itemsData.items;
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: items.length,
          itemBuilder: (ctx, i) => ItemCard(
            itemCode: items[i].itemCode,
            description: items[i].description,
            retailPrice: items[i].retailPrice,
          ),
        ),
      ),
    );
  }
}
