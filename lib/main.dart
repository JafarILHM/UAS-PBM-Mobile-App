import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';

// Import Providers
import 'providers/auth_provider.dart';
import 'providers/item_provider.dart';
import 'providers/category_provider.dart';
import 'providers/supplier_provider.dart';
import 'providers/unit_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/user_provider.dart'; 

// Import Pages
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/item_list_page.dart';
import 'pages/item_form_page.dart';
import 'pages/category_list_page.dart';
import 'pages/category_form_page.dart';
import 'pages/supplier_list_page.dart';
import 'pages/supplier_form_page.dart';
import 'pages/unit_list_page.dart';
import 'pages/unit_form_page.dart';
import 'pages/incoming_form_page.dart';
import 'pages/outgoing_form_page.dart';
import 'pages/all_transactions_page.dart';
import 'pages/profile_page.dart';
import 'pages/user_list_page.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SupplierProvider()),
        ChangeNotifierProvider(create: (_) => UnitProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), 
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
      theme: AdminKitTheme.themeData, 
      initialRoute: '/login', 
      routes: {
        // Auth & Dashboard
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        
        // Master Data Items
        '/items': (context) => const ItemListPage(),
        '/items/create': (context) => const ItemFormPage(),
        
        // Master Data Categories
        '/categories': (context) => const CategoryListPage(),
        '/categories/create': (context) => const CategoryFormPage(),

        // Master Data Suppliers
        '/suppliers': (context) => const SupplierListPage(),
        '/suppliers/create': (context) => const SupplierFormPage(),

        // Master Data Units
        '/units': (context) => const UnitListPage(),
        '/units/create': (context) => const UnitFormPage(),

        // [BARU] Master Data Users
        '/users': (context) => const UserListPage(),

        // Transactions
        '/transactions': (context) => const AllTransactionsPage(),
        '/incoming': (context) => const IncomingFormPage(),
        '/outgoing': (context) => const OutgoingFormPage(),

        // Profile
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}