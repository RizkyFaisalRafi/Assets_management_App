import 'dart:convert';

import 'package:asset_management/config/app_constant.dart';
import 'package:asset_management/models/asset_model.dart';
import 'package:asset_management/pages/asset/create_asset_page.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AssetModel> assets = []; //

  readAssets() async {
    assets.clear();

    Uri url = Uri.parse(
      '${AppConstant.baseURL2}/assets/read.php',
    );

    try {
      // Method POST
      final response = await http.get(url);
      DMethod.printBasic('Execute request to API');
      DMethod.printResponse(response);

      debugPrint('Response body before decoding and casting to map: ');
      debugPrint(response.body.toString());

      Map respondBody = json.decode(response.body);

      debugPrint('responseBody is: ');
      debugPrint(respondBody.toString());

      bool success = respondBody['success'] ?? false;
      if (success) {
        List data = respondBody['data'];
        assets = data.map((e) => AssetModel.fromJson(e)).toList();
      }
      setState(() {});
    } catch (e) {
      DMethod.printTitle('Catch', e.toString());
    }
  }

  @override
  void initState() {
    readAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                readAssets();
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateAssetPage()));
        },
        child: const Icon(Icons.add),
      ),
      body: assets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Data Empty'),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => {
                readAssets(),
              },
              child: GridView.builder(
                itemCount: assets.length,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  AssetModel item = assets[index]; //
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${AppConstant.baseURL2}/image/${item.image}',
                              // item['image'], // Sesuai kata kunci image di db
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name, // Sesuai kata kunci name di db
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    item.type, // Sesuai kata kunci type di db
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.purple[50],
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Icon(Icons.more_vert),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
