import 'dart:typed_data';

import 'package:d_input/d_input.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateAssetPage extends StatefulWidget {
  const CreateAssetPage({super.key});

  @override
  State<CreateAssetPage> createState() => _CreateAssetPageState();
}

class _CreateAssetPageState extends State<CreateAssetPage> {
  final formKey = GlobalKey<FormState>();
  final edtName = TextEditingController();

  List<String> types = [
    'Clothes',
    'Transportation',
    'Electronic',
    'Place',
    'House',
    'Property',
    'Other',
  ];
  String type = 'Property';
  String? imageName;
  Uint8List? imageByte;

  pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      // if there data
      imageName = picked.name;
      imageByte = await picked.readAsBytes();
      setState(() {});
    }
    DMethod.printBasic('imageName: $imageName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Asset'),
        centerTitle: true,
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DInput(
                controller: edtName,
                title: 'Name',
                hint: 'Vas Bunga',
                fillColor: Colors.white,
                validator: (input) => input == '' ? "Don't Empty" : null,
                radius: BorderRadius.circular(10),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              DropdownButtonFormField(
                  value: type,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16)),
                  items: types.map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) type = value;
                  }),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: imageByte == null
                      ? const Text('Empty')
                      : Image.memory(imageByte!),
                ),
              ),
              ButtonBar(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: Icon(Icons.image),
                    label: Text('Gallery'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    print(type);
                  },
                  child: const Text('Save'))
            ],
          )),
    );
  }
}
