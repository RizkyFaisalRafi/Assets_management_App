import 'dart:convert';
import 'dart:typed_data';

import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../config/app_constant.dart';
import '../../models/asset_model.dart';

class UpdateAssetPage extends StatefulWidget {
  const UpdateAssetPage({super.key, required this.oldAsset});
  final AssetModel oldAsset;

  @override
  State<UpdateAssetPage> createState() => _UpdateAssetPageState();
}

class _UpdateAssetPageState extends State<UpdateAssetPage> {
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

  save() async {
    bool isValidInput = formKey.currentState!.validate();
    // If not valid, will stop / return
    if (!isValidInput) return;

    Uri url = Uri.parse(
      '${AppConstant.baseURL2}/assets/update.php',
    );

    try {
      // Method POST
      final response = await http.post(url, body: {
        'id': widget.oldAsset.id,
        'name': edtName.text,
        'type': type,
        'old_image': widget.oldAsset.image,
        'new_image': imageName ?? widget.oldAsset.image,
        'new_base64code':
            imageByte == null ? '' : base64Encode(imageByte as List<int>),
      });
      DMethod.printBasic('Execute request to API');
      DMethod.printResponse(response);

      debugPrint('Response body before decoding and casting to map: ');
      debugPrint(response.body.toString());

      Map respondBody = json.decode(response.body);

      debugPrint('responseBody is: ');
      debugPrint(respondBody.toString());

      bool success = respondBody['success'] ?? false;
      if (success) {
        DInfo.toastSuccess('Success Update Asset');
        Navigator.pop(context);
      } else {
        DInfo.toastError('Failed Update Asset');
      }
    } catch (e) {
      DMethod.printTitle('Catch', e.toString());
    }
  }

  @override
  void initState() {
    edtName.text = widget.oldAsset.name;
    type = widget.oldAsset.type;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Asset'),
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
                      ? Image.network(
                          '${AppConstant.baseURL2}/image/${widget.oldAsset.image}',
                        )
                      : Image.memory(
                          imageByte!,
                        ),
                ),
              ),
              ButtonBar(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    save();
                    debugPrint(type);
                  },
                  child: const Text('Save'))
            ],
          )),
    );
  }
}
