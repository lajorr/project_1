import 'package:flutter/material.dart';
import 'package:my_app/provider/item_provider.dart';
import 'package:my_app/screens/add_item_screen.dart';
import 'package:my_app/screens/item_detail_screen.dart';
import 'package:my_app/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class AllItemsScreen extends StatefulWidget {
  const AllItemsScreen({super.key});

  @override
  State<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  String? input;
  final inputController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Items'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddItemScreen.routeName,
                  arguments: null,
                );
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
        drawer: const DrawerWidget(),
        body: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: TextField(
                    controller: inputController,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      setState(() {
                        input = value;
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffix: IconButton(
                          onPressed: () {
                            inputController.clear();
                            setState(() {
                              input = null;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        labelText: 'Search'),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                FutureBuilder(
                  future: Provider.of<ItemProvider>(context, listen: false)
                      .fetchAndSetItem(input),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('ERROR'),
                      );
                    }

                    return Consumer<ItemProvider>(
                      child: const Center(
                        child: Text('No Items'),
                      ),
                      builder: (context, data, ch) => data.items.isEmpty
                          ? ch!
                          : Expanded(
                              child: GridView.builder(
                                itemCount: data.items.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 1.5,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          ItemDetailScreen.routeName,
                                          arguments: data.items[index].id,
                                        );
                                      },
                                      child: GridTile(
                                        footer: GridTileBar(
                                          backgroundColor: Colors.black54,
                                          title: Text(
                                            data.items[index].name,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        child: Image.file(
                                          data.items[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
