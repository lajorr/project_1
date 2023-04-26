import 'package:flutter/material.dart';
import 'package:my_app/provider/item_provider.dart';
import 'package:my_app/screens/add_item_screen.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});

  static const routeName = '/details_screen';

  @override
  Widget build(BuildContext context) {
    List<Widget> textWidgets = [];
    final descController = TextEditingController();

    final id = ModalRoute.of(context)!.settings.arguments as String?;
    final selectedItem = Provider.of<ItemProvider>(context).findById(id!);
    // final mapLen = selectedItem.extraData!.length;

    void onDelete() {
      Provider.of<ItemProvider>(context, listen: false).delete(selectedItem);
      Navigator.of(context).pop();
    }

    Widget newTextWidget(String field, String value) {
      final capializedField =
          Provider.of<ItemProvider>(context, listen: false).capitalize(field);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5),
        child: Text(
          '$capializedField : $value',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // var d = selectedItem.extraData!.keys;
    // d.expand((element) => )
    // int i = 0;
    // while (i < mapLen) {
    //   // selectedItem.extraData!.map((key, value) {
    //   //   textWidgets.add(
    //   //     newTextWidget(key, value),
    //   //   );
    //   // });
    // }
    var d = selectedItem.extraData!.map((key, value) {
      textWidgets.add(
        newTextWidget(key, value),
      );
      return MapEntry(key, value);
    });
    print("idk whut $d");

    descController.text = selectedItem.description;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AddItemScreen.routeName,
                arguments: selectedItem,
              );
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 500,
                width: double.infinity,
                color: Colors.grey,
                child: Image.file(
                  selectedItem.image,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    selectedItem.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price : ${selectedItem.price}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    ...textWidgets,
                    // Text(
                    //   'Price : ${selectedItem.price}',
                    //   style: const TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  readOnly: true,
                  controller: descController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onDelete,
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete),
      ),
    );
  }
}
