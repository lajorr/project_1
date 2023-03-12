import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/model/item_model.dart';
import 'package:my_app/provider/item_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as syspath;

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  static const routeName = '/addItemScreen';

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  List<Widget> containers = [];
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  File? selectedImage;
  File? savedImage;
  var isEdit = true;

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

  void pickImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 130,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () => getImage(ImageSource.camera, context),
              ),
              const Divider(thickness: 2),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('gallery'),
                onTap: () => getImage(ImageSource.gallery, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source, BuildContext context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
      );
      print(image);

      final dir = await syspath.getApplicationDocumentsDirectory();
      final fileName = basename(image!.path);
      final imageFile = File(image.path);
      savedImage = await imageFile.copy('${dir.path}/$fileName');

      setState(() {
        selectedImage = File(image.path);
      });
    } on Exception catch (e) {
      print(e);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final itemData = ModalRoute.of(context)!.settings.arguments as ItemModel?;
    if (itemData == null) {
      isEdit = false;
    }
    if (isEdit && itemData != null) {
      nameController.text = itemData.name;
      priceController.text = itemData.price.toString();
      descController.text = itemData.description;
      selectedImage = itemData.image;
    }

    void onDone(BuildContext context) {
      if (!isEdit) {
        if (nameController.text.trim().isEmpty ||
            priceController.text.isEmpty) {
          return;
        }
        Provider.of<ItemProvider>(context, listen: false).addItem(
          nameController.text.trim(),
          double.parse(
            priceController.text.trim(),
          ),
          descController.text.trim(),
          savedImage!,
        );
      } else if (isEdit) {
        final ItemModel updatedValue = ItemModel(
            id: itemData!.id,
            name: nameController.text,
            price: double.parse(priceController.text),
            description: descController.text,
            image: selectedImage!);
        Provider.of<ItemProvider>(context, listen: false)
            .update(itemData.id, updatedValue);
      }
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit' : 'Add Item'),
        actions: [
          IconButton(
            onPressed: () => onDone(context),
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
                clipBehavior: Clip.none,
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
                    bottom: 0,
                    left: 210,
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        // backgroundColor: Col,
                        radius: 20,
                        child: Center(
                          child: IconButton(
                              onPressed: () => pickImage(context),
                              icon: const Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                                size: 25,
                              )),
                        ),
                      ),
                    ),
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
        SizedBox(
          height: 40,
          width: double.infinity,
          child: TextField(
            maxLength: 30,
            onChanged: (value) {
              fieldText = value;
            },
            decoration: const InputDecoration(
              counterText: '',
              hintText: 'Field Name',
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            style: const TextStyle(
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
            },
            maxLength: 30,
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
                onPressed: () {},
                icon: const Icon(Icons.done),
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
