import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Core & Theme
import 'core/theme.dart';

// Import Providers
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/supplier_provider.dart'; 

// Import Pages
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/category_list_page.dart';
import 'pages/supplier_list_page.dart';   

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider untuk Login/Auth
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Provider untuk Master Data
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SupplierProvider()), 
        
        // Nanti tambah UnitProvider dan ItemProvider di sini...
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
        '/suppliers': (context) => const SupplierListPage(), // 4. Route Supplier sudah aktif
        
        // --- PLACEHOLDERS (Belum Dibuat) ---
        '/units': (context) => const Scaffold(body: Center(child: Text("Halaman Unit (Belum Dibuat)"))),
        '/items': (context) => const Scaffold(body: Center(child: Text("Halaman Barang (Belum Dibuat)"))),
        
        // --- TRANSAKSI ---
        '/incoming': (context) => const Scaffold(body: Center(child: Text("Barang Masuk (Belum Dibuat)"))),
        '/outgoing': (context) => const Scaffold(body: Center(child: Text("Barang Keluar (Belum Dibuat)"))),
        
        // --- PROFILE ---
        '/profile': (context) => const Scaffold(body: Center(child: Text("Profile (Belum Dibuat)"))),
      },
    );
  }
}