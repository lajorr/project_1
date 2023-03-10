// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/item_provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool onSelect = false;
  bool? isNameChecked;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blue[100],
              child: const Center(
                child: Text(
                  "Logo Here",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              color: Colors.blue[100],
              child: ListTile(
                title: const Text(
                  'Sort By:',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
                trailing: Icon(
                  onSelect
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 35,
                ),
                onTap: () {
                  setState(() {
                    onSelect = !onSelect;
                  });
                },
              ),
            ),
            if (onSelect)
              Container(
                height: 190,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                color: Colors.blue[200],
                child: Consumer<ItemProvider>(
                  builder: (context, value, child) {
                    isNameChecked = value.isNameChecked == null
                        ? false
                        : value.isNameChecked!;

                    return ListView(
                      children: [
                        ListTile(
                          title: const Text(
                            'Name (Asc)',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  isNameChecked = !isNameChecked!;
                                  print(isNameChecked);
                                  Provider.of<ItemProvider>(context,
                                          listen: false)
                                      .setNameBool(isNameChecked!);
                                },
                              );
                            },
                            icon: Icon(
                              isNameChecked!
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                            ),
                            // size: 30,
                            color: Colors.black,
                          ),
                        ),
                        // ListTile(
                        //   title: const Text(
                        //     'Price (Asc)',
                        //     style: TextStyle(
                        //       fontSize: 22,
                        //     ),
                        //   ),
                        //   trailing: IconButton(
                        //     onPressed: () {
                        //       setState(
                        //         () {
                        //           isPriceChecked = !isPriceChecked!;

                        //           Provider.of<ItemProvider>(context,
                        //                   listen: false)
                        //               .setPriceBool(isPriceChecked!);
                        //         },
                        //       );
                        //     },
                        //     icon: Icon(
                        //       isPriceChecked!
                        //           ? Icons.check_box
                        //           : Icons.check_box_outline_blank,
                        //     ),
                        //     // size: 30,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
