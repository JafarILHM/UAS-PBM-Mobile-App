import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Core & Theme
import 'core/theme.dart';

// Import Providers
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/supplier_provider.dart';
import 'providers/unit_provider.dart';
import 'providers/item_provider.dart'; 

// Import Pages
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/category_list_page.dart';
import 'pages/supplier_list_page.dart';
import 'pages/unit_list_page.dart';
import 'pages/item_list_page.dart';    

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider untuk Login/Auth
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Provider untuk Master Data
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SupplierProvider()),
        ChangeNotifierProvider(create: (_) => UnitProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Gudang',
      debugShowCheckedModeBanner: false, 
      
      // Menggunakan Tema AdminKit
      theme: AdminKitTheme.themeData, 
      
      // Halaman pertama yang dibuka
      initialRoute: '/login', 
      
      // Daftar Route (Alamat Halaman)
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        
        // --- MASTER DATA ---
        '/categories': (context) => const CategoryListPage(),
        '/suppliers': (context) => const SupplierListPage(),
        '/units': (context) => const UnitListPage(),
        '/items': (context) => const ItemListPage(), 
        
        // --- TRANSAKSI (Placeholder - Akan dibuat setelah ini) ---
        '/incoming': (context) => const Scaffold(body: Center(child: Text("Barang Masuk (Belum Dibuat)"))),
        '/outgoing': (context) => const Scaffold(body: Center(child: Text("Barang Keluar (Belum Dibuat)"))),
        
        // --- PROFILE (Placeholder) ---
        '/profile': (context) => const Scaffold(body: Center(child: Text("Profile (Belum Dibuat)"))),
      },
    );
  }
}