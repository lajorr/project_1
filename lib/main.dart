import 'package:flutter/material.dart';
import 'package:my_app/provider/item_provider.dart';
import 'package:my_app/screens/add_item_screen.dart';
import 'package:my_app/screens/all_items_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ItemProvider(),
      builder: (context, _) {
        return MaterialApp(
          title: 'My App',
          debugShowCheckedModeBanner: false,
          routes: {
            AddItemScreen.routeName: (context) => const AddItemScreen(),
          },
          home: const AllItemsScreen(),
        );
      },
    );
  }
}
