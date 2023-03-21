import 'dart:convert';

import 'package:asset_management/config/app_constant.dart';
import 'package:asset_management/pages/asset/home_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final edtUsername = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  login(BuildContext context) {
    bool isValid = formKey.currentState!.validate();
    if (isValid) {
      // Tervalidasi
      Uri url = Uri.parse('${AppConstant.baseURL2}/user/login.php');

      // Method POST
      http.post(url, body: {
        'username': edtUsername.text,
        'password': edtPassword.text,
      }).then((response) {
        DMethod.printResponse(response);

        debugPrint('Response body before decoding and casting to map: ');
        debugPrint(response.body.toString());

        Map respondBody = json.decode(response.body);

        debugPrint('responseBody is: ');
        debugPrint(respondBody.toString());

        bool success = respondBody['success'] ?? false;
        if (success) {
          DInfo.toastSuccess('Login Success');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          DInfo.toastError('Login Failed');
        }
      }).catchError((onError) {
        DInfo.toastError('Something Wrong, ${onError.toString()}');
        DMethod.printTitle('catchError', onError.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.purple[300],
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.purple[300],
            ),
          ),
          Positioned(
              bottom: 40,
              left: 20,
              child: Icon(
                Icons.scatter_plot,
                size: 90,
                color: Colors.purple[400],
              )),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formKey, // Untuk validasi Validator
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppConstant.appName,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.purple[700]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: edtUsername,
                    validator: (value) => value == '' ? "Don't Empty" : null,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                      hintText: 'Username',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: edtPassword,
                    validator: (value) => value == '' ? "Don't Empty" : null,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
