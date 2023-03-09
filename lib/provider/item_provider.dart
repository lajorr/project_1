import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/helper/db_helper.dart';

import 'package:my_app/model/item_model.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel> _items = [];

  List<ItemModel> get items {
    return [..._items];
  }

  ItemModel findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addItem(
    String name,
    double price,
    String description,
    File image,
  ) {
    final newItem = ItemModel(
      id: DateTime.now().toString(),
      name: name,
      price: price,
      description: description,
      image: image,
    );
    _items.add(newItem);
    notifyListeners();

    DbHelper.insert({
      'id': newItem.id,
      'title': newItem.name,
      'price': newItem.price,
      'image': newItem.image.path,
      'description': newItem.description,
    });
  }

  Future<void> fetchAndSetItem() async {
    final data = await DbHelper.getData();
    _items = data
        .map(
          (item) => ItemModel(
            id: item['id'],
            name: item['title'],
            price: item['price'],
            description: item['description'],
            image: File(
              item['image'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }

  Future delete(ItemModel item) async {
    _items.removeWhere((element) => element.id == item.id);
    DbHelper.delete(item.id);
    notifyListeners();
  }

  Future update(String id, ItemModel updatedItem) async {
    final index = _items.indexWhere((element) => element.id == id);
    _items[index] = updatedItem;
    notifyListeners();
    DbHelper.update({
      // 'id': updatedItem.id,
      'title': updatedItem.name,
      'price': updatedItem.price,
      'description': updatedItem.description,
      'image': updatedItem.image.path,
    }, updatedItem.id);
  }
}
