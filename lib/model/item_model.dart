// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';


class ItemModel {
  final String id;
  final String name;
  final double price;
  final String description;
  final File image;
  final Map<String, dynamic>? extraData;

  ItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.extraData,
  });
}
