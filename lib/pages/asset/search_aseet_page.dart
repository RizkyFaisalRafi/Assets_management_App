import 'dart:convert';

import 'package:asset_management/config/app_constant.dart';
import 'package:asset_management/models/asset_model.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchAssetPage extends StatefulWidget {
  const SearchAssetPage({super.key});

  @override
  State<SearchAssetPage> createState() => _SearchAssetPageState();
}

class _SearchAssetPageState extends State<SearchAssetPage> {
  List<AssetModel> assets = []; //

  final edtSearch = TextEditingController();

  searchAssets() async {
    if (edtSearch.text == '') {
      DMethod.printBasic('Stop because input empty');
      return;
    }

    assets.clear();
    setState(() {});

    Uri url = Uri.parse(
      '${AppConstant.baseURL2}/assets/search.php',
    );

    try {
      // Method POST
      final response = await http.post(url, body: {
        'search': edtSearch.text,
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
        List data = respondBody['data'];
        assets = data.map((e) => AssetModel.fromJson(e)).toList();
      }

      setState(() {});
    } catch (e) {
      DMethod.printTitle('Catch', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: edtSearch,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search here...',
              isDense: true,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                searchAssets();
              },
              icon: const Icon(Icons.search)),
        ],
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
                searchAssets(),
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
                              fit: BoxFit
                                  .cover, // cover or contain sesuai kebutuhan
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
                                splashColor: Colors.purpleAccent,
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
