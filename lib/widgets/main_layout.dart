import 'package:flutter/material.dart';
import 'admin_sidebar.dart';
import '../core/theme.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const MainLayout({
    super.key, 
    required this.title, 
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminKitTheme.background, // Background abu-abu muda
      appBar: AppBar(
        title: Text(
          title, 
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          // Ikon lonceng notifikasi ala AdminKit
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          // Ikon User
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
               Navigator.pushNamed(context, '/profile');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const AdminSidebar(), // Sidebar Otomatis
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Padding besar ala AdminKit
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Halaman Besar di Body (Opsional, AdminKit punya ini)
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF495057),
                ),
              ),
              const SizedBox(height: 24),
              
              // Konten Halaman Sebenarnya
              body,
            ],
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}