import 'package:flutter/material.dart';
import 'login_page.dart'; // Mengimpor halaman login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gudang App',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      // Arahkan home ke LoginPage yang ada di file terpisah
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
