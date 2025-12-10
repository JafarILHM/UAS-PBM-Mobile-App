import 'package:flutter/material.dart';
import 'services/pages/item_list_page.dart';
import 'services/pages/category_list_page.dart';
import 'services/pages/unit_list_page.dart';
import 'services/pages/supplier_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          // App Bar dengan Gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[700]!, Colors.blue[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[400]!, Colors.blue[600]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Selamat Datang! 👋",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Kelola inventory Anda dengan mudah",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.inventory_2,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Stats Cards
                  Text(
                    "Statistik Cepat",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.inventory,
                          title: "Total Item",
                          value: "248",
                          color: Colors.blue,
                          delay: 600,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.trending_up,
                          title: "Stock In",
                          value: "45",
                          color: Colors.green,
                          delay: 700,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.trending_down,
                          title: "Stock Out",
                          value: "12",
                          color: Colors.orange,
                          delay: 800,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.warning_amber,
                          title: "Low Stock",
                          value: "8",
                          color: Colors.red,
                          delay: 900,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32),

                  // Quick Actions Section
                  Text(
                    "Menu Utama",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),

                  _buildMenuCard(
                    context: context,
                    icon: Icons.list_alt,
                    title: "Lihat Semua Item",
                    subtitle: "Kelola dan edit data inventory",
                    color: Colors.blue,
                    delay: 1000,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemListPage(token: "test-token"),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 12),

                  _buildMenuCard(
                    context: context,
                    icon: Icons.add_box,
                    title: "Tambah Item Baru",
                    subtitle: "Daftarkan produk baru ke sistem",
                    color: Colors.green,
                    delay: 1100,
                    onTap: () {
                      // TODO: Navigate to add item page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Fitur segera hadir!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 12),

                  _buildMenuCard(
                    context: context,
                    icon: Icons.analytics,
                    title: "Laporan & Analisis",
                    subtitle: "Lihat statistik dan trend inventory",
                    color: Colors.purple,
                    delay: 1200,
                    onTap: () {
                      // TODO: Navigate to reports page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Fitur segera hadir!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 12),

                  _buildMenuCard(
                    context: context,
                    icon: Icons.settings,
                    title: "Pengaturan",
                    subtitle: "Konfigurasi sistem dan preferensi",
                    color: Colors.grey,
                    delay: 1300,
                    onTap: () {
                      // TODO: Navigate to settings page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Fitur segera hadir!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 12),

                  _buildMenuCard(
                    context: context,
                    icon: Icons.category,
                    title: "Manajemen Kategori",
                    subtitle: "Tambah, edit, dan hapus kategori barang",
                    color: Colors.teal,
                    delay: 1050,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryListPage(token: "test-token"),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context: context,
                    icon: Icons.straighten,
                    title: "Manajemen Satuan",
                    subtitle: "Tambah, edit, dan hapus satuan",
                    color: Colors.indigo,
                    delay: 1100,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UnitListPage(token: "test-token"),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context: context,
                    icon: Icons.store,
                    title: "Manajemen Supplier",
                    subtitle: "Kelola data supplier barang",
                    color: Colors.orange,
                    delay: 300,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SupplierPage(token: "test-token"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double animValue, child) {
        return Opacity(
          opacity: animValue,
          child: Transform.scale(scale: 0.8 + (0.2 * animValue), child: child),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required int delay,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.8), color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
