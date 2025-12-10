import 'package:flutter/material.dart';
import 'login_page.dart'; // Panggil halaman login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gudang App',
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Warna tema biru profesional
        useMaterial3: true,
      ),
      home: const LoginPage(), // Halaman pertama kali dibuka
      debugShowCheckedModeBanner: false,
    );
  }
}
