import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:my_app/helper/db_helper.dart';

import 'package:my_app/model/item_model.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel> _items = [];
  bool? _isNameChecked;

  List<ItemModel> get items {
    return [..._items];
  }

  bool? get isNameChecked => _isNameChecked;

  void setNameBool(bool value) {
    _isNameChecked = value;
    notifyListeners();
  }

  ItemModel findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addItem(
    String name,
    double price,
    String description,
    File image,
    Map<String, String>? extraField,
  ) {
    final newItem = ItemModel(
      id: DateTime.now().toString(),
      name: name,
      price: price,
      description: description,
      image: image,
      extraData: extraField,
    );
    _items.add(newItem);
    notifyListeners();

    DbHelper.insert({
      'id': newItem.id,
      'title': newItem.name,
      'price': newItem.price,
      'image': newItem.image.path,
      'description': newItem.description,
      'extra': jsonEncode(
        newItem.extraData,
      )
    });
  }

  String capitalize(String value) {
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }

  Future<void> fetchAndSetItem(String? query) async {
    var data = await DbHelper.getData();
    if (query != null) {
      data = data
          .where(
            (element) => (element['title'] as String).toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    }

    _items = data.map((item) {
      Map<String, dynamic> map = jsonDecode(
        (item['extra'] as String),
      );

      return ItemModel(
        id: item['id'],
        name: item['title'],
        price: item['price'],
        description: item['description'],
        image: File(
          item['image'],
        ),
        // extraData: item['extra']
        extraData: map,
      );
    }).toList();
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
