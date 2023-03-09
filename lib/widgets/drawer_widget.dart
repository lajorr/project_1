// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool onSelect = false;
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
                  'Filters:',
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
                  child: ListView(
                    children: const [
                      FilterTile(filterBy: 'By Name'),
                      FilterTile(filterBy: 'By Price'),
                      FilterTile(filterBy: 'By ...'),
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}

class FilterTile extends StatefulWidget {
  const FilterTile({
    Key? key,
    required this.filterBy,
  }) : super(key: key);
  final String filterBy;

  @override
  State<FilterTile> createState() => _FilterTileState();
}

class _FilterTileState extends State<FilterTile> {
  var isChecked = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.filterBy,
        style: const TextStyle(
          fontSize: 22,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          setState(() {
            isChecked = !isChecked;
          });
        },
        icon: Icon(
          isChecked ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        // size: 30,
        color: Colors.black,
      ),
      // onTap: () {
      //   setState(() {
      //     onSelect = !onSelect;
      //   });
      // },
    );
  }
}
