import 'package:asset_management/pages/user/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
            primary: Colors.purple, secondary: Colors.amber),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            backgroundColor: const MaterialStatePropertyAll(Colors.purple),
          ),
        ),
        scaffoldBackgroundColor: Colors.purple[50],
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
