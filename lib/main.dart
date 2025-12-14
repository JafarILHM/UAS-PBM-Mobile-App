import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Core & Theme
import 'core/theme.dart';

// Import Semua Provider
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/supplier_provider.dart';
import 'providers/unit_provider.dart';
import 'providers/item_provider.dart';
import 'providers/transaction_provider.dart';

// Import Semua Halaman
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/category_list_page.dart';
import 'pages/supplier_list_page.dart';
import 'pages/unit_list_page.dart';
import 'pages/item_list_page.dart';
import 'pages/incoming_form_page.dart';
import 'pages/outgoing_form_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Pendaftaran Provider (State Management)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SupplierProvider()),
        ChangeNotifierProvider(create: (_) => UnitProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
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
      
      // Menggunakan Tema AdminKit yang sudah kita buat
      theme: AdminKitTheme.themeData, 
      
      // Halaman pertama yang dibuka saat aplikasi jalan
      initialRoute: '/login', 
      
      // Daftar Alamat Halaman (Routing)
      routes: {
        // Auth
        '/login': (context) => const LoginPage(),
        
        // Dashboard
        '/dashboard': (context) => const DashboardPage(),
        
        // Master Data (CRUD)
        '/items': (context) => const ItemListPage(),
        '/categories': (context) => const CategoryListPage(),
        '/suppliers': (context) => const SupplierListPage(),
        '/units': (context) => const UnitListPage(),
        
        // Transaksi
        '/incoming': (context) => const IncomingFormPage(),
        '/outgoing': (context) => const OutgoingFormPage(),
        
        // User Profile
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}