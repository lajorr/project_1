import 'package:flutter/material.dart';
import 'package:my_app/provider/item_provider.dart';
import 'package:my_app/screens/add_item_screen.dart';
import 'package:my_app/screens/item_detail_screen.dart';
import 'package:my_app/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

class AllItemsScreen extends StatelessWidget {
  const AllItemsScreen({super.key});

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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 40,
                child: const TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      labelText: 'Search'),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder(
                future: Provider.of<ItemProvider>(context, listen: false)
                    .fetchAndSetItem(),
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
        ));
  }
}
