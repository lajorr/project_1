// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_app/provider/item_provider.dart';

class ItemGrid extends StatelessWidget {
  const ItemGrid({
    Key? key,
    required this.itemId,
  }) : super(key: key);
  final String itemId;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ItemProvider>(context);
    final item = data.findById(itemId);

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            item.name,
            textAlign: TextAlign.center,
          ),
        ),
        child: Image.file(
          item.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
