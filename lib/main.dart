import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import Core & Theme
import 'core/theme.dart';
// Import Providers
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
// Import Pages
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/category_list_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // 1. Provider untuk Login/Auth
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // 2. Provider untuk Kategori (BARU DITAMBAHKAN)
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        
        // Nanti tambah ItemProvider, SupplierProvider, dll di sini...
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
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug di pojok kanan atas
      
      // Menggunakan Tema AdminKit yang sudah kita buat
      theme: AdminKitTheme.themeData, 
      
      // Halaman pertama yang dibuka
      initialRoute: '/login', 
      
      // Daftar Alamat Halaman (Route)
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        
        // ROUTE MASTER DATA
        '/categories': (context) => const CategoryListPage(), // Route ini sudah aktif sekarang
        
        // Route Placeholder (Belum dibuat filenya)
        '/items': (context) => const Scaffold(body: Center(child: Text("Halaman Barang (Belum Dibuat)"))),
        '/suppliers': (context) => const Scaffold(body: Center(child: Text("Halaman Supplier (Belum Dibuat)"))),
        '/units': (context) => const Scaffold(body: Center(child: Text("Halaman Unit (Belum Dibuat)"))),
        
        // Route Transaksi Placeholder
        '/incoming': (context) => const Scaffold(body: Center(child: Text("Barang Masuk (Belum Dibuat)"))),
        '/outgoing': (context) => const Scaffold(body: Center(child: Text("Barang Keluar (Belum Dibuat)"))),
        
        // Route Profile Placeholder
        '/profile': (context) => const Scaffold(body: Center(child: Text("Profile (Belum Dibuat)"))),
      },
    );
  }
}