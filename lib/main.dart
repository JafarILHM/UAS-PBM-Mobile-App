import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Provider lain nanti di sini
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
      theme: AdminKitTheme.themeData, // GUNAKAN TEMA ADMINKIT
      initialRoute: '/login', // Mulai dari login
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/items': (context) => const Scaffold(body: Center(child: Text("Halaman Barang (Belum Dibuat)"))),
        '/categories': (context) => const Scaffold(body: Center(child: Text("Halaman Kategori (Belum Dibuat)"))),
        '/suppliers': (context) => const Scaffold(body: Center(child: Text("Halaman Supplier (Belum Dibuat)"))),
        '/units': (context) => const Scaffold(body: Center(child: Text("Halaman Unit (Belum Dibuat)"))),
        '/incoming': (context) => const Scaffold(body: Center(child: Text("Barang Masuk (Belum Dibuat)"))),
        '/outgoing': (context) => const Scaffold(body: Center(child: Text("Barang Keluar (Belum Dibuat)"))),
        '/profile': (context) => const Scaffold(body: Center(child: Text("Profile (Belum Dibuat)"))),
      },
    );
  }
}