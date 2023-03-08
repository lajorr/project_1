import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/provider/item_provider.dart';
import 'package:provider/provider.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  static const routeName = '/addItemScreen';

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  List<Widget> containers = [];

  void _addContainers() {
    setState(() {
      containers.add(containerContent());
    });
  }

  void removeContainer(int index) {
    setState(() {
      containers.removeAt(index);
    });
  }

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  File? selectedImage;
  void pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      selectedImage = File(image!.path);
    });
  }

  void onDone() {
    if (nameController.text.trim().isEmpty || priceController.text.isEmpty) {
      return;
    }
    Provider.of<ItemProvider>(context, listen: false).addItem(
      nameController.text.trim(),
      double.parse(
        priceController.text.trim(),
      ),
      descController.text.trim(),
      selectedImage!,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
        actions: [
          IconButton(
            onPressed: onDone,
            icon: const Icon(
              Icons.done,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: selectedImage == null
                          ? null
                          : FileImage(
                              selectedImage!,
                            ),
                      radius: 60,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 200,
                    child: IconButton(
                        onPressed: pickImage,
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(
                  //     color: Colors.black,
                  //     width: 1.25,
                  //   ),
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.red),
                  // ),

                  labelText: 'Name',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price',
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              ...buildContainerList(),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  title: const Text('Add New Field'),
                  leading: const Icon(
                    Icons.add_circle,
                    size: 30,
                  ),
                  onTap: _addContainers,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 150,
                child: TextField(
                  controller: descController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerContent() {
    String? fieldText;
    String? valueText;
    return Column(
      children: [
        const SizedBox(
          height: 40,
          width: double.infinity,
          child: TextField(
            maxLength: 33,
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Field Name',
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 40,
          width: double.infinity,
          child: TextField(
            onChanged: (value) {
              valueText = value;
            },
            onEditingComplete: () {
              print(valueText);
              FocusScope.of(context).unfocus();
            },
            maxLength: 33,
            decoration: const InputDecoration(
              counterText: '',
              hintText: 'Value',
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  List<Widget> buildContainerList() {
    return containers.map(
      (container) {
        final index = containers.indexOf(container);
        return Container(
          padding: const EdgeInsets.only(top: 3),
          height: 85,
          width: double.infinity,
          margin: const EdgeInsets.only(
            top: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                child: container,
              ),
              IconButton(
                onPressed: () => removeContainer(index),
                icon: const Icon(Icons.remove),
              ),
            ],
          ),
        );
      },
    ).toList();
  }
}
