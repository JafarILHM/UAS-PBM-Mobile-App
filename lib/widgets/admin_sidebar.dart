import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data user yang sedang login dari Provider
    final user = Provider.of<AuthProvider>(context).user;

    return Drawer(
      backgroundColor: AdminKitTheme.sidebar, 
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // --- HEADER SIDEBAR (Logo & Brand) ---
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: AdminKitTheme.sidebar,
                border: Border(bottom: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.inventory_2, color: AdminKitTheme.primary, size: 32),
                  SizedBox(width: 12),
                  Text(
                    'Gudang App',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 22, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- INFO USER (Avatar & Nama) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AdminKitTheme.primary,
                    radius: 20,
                    child: Text(
                      user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : "U",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? "User", 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user?.email ?? "-", 
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // --- MENU NAVIGASI ---
          
          _buildMenuLabel("Menu Utama"),
          _buildMenuItem(context, 'Dashboard', Icons.dashboard, '/dashboard'),

          _buildMenuLabel("Master Data"),
          _buildMenuItem(context, 'Data Barang', Icons.inventory, '/items'),
          _buildMenuItem(context, 'Kategori', Icons.category, '/categories'),
          _buildMenuItem(context, 'Supplier', Icons.local_shipping, '/suppliers'),
          _buildMenuItem(context, 'Satuan (Unit)', Icons.straighten, '/units'),

          _buildMenuLabel("Transaksi"),
          _buildMenuItem(context, 'Barang Masuk', Icons.arrow_circle_down, '/incoming'),
          _buildMenuItem(context, 'Barang Keluar', Icons.arrow_circle_up, '/outgoing'),
          _buildMenuItem(context, 'Semua Transaksi', Icons.history, '/transactions'),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.white10),
          ),

          _buildMenuItem(context, 'Profile Saya', Icons.person, '/profile'),
          
          // --- TOMBOL LOGOUT ---
          ListTile(
            leading: const Icon(Icons.logout, color: AdminKitTheme.danger),
            title: const Text('Logout', style: TextStyle(color: AdminKitTheme.danger)),
            onTap: () async {
              // 1. Tampilkan Dialog Konfirmasi
              final confirm = await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Konfirmasi Logout"),
                  content: const Text("Apakah Anda yakin ingin keluar aplikasi?"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true), 
                      child: const Text("Logout", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              // 2. Jika Ya, Lakukan Logout
              if (confirm == true && context.mounted) {
                await Provider.of<AuthProvider>(context, listen: false).logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }
              }
            },
          ),
          
          const SizedBox(height: 24), // Spasi bawah
        ],
      ),
    );
  }

  // Widget Helper untuk Label Kategori Menu (Kecil)
  Widget _buildMenuLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // Widget Helper untuk Item Menu
  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    // Cek apakah route saat ini sama dengan route menu (untuk highlight aktif)
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isActive = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon, 
        color: isActive ? Colors.white : Colors.white70,
        size: 20,
      ),
      title: Text(
        title, 
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white70,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        )
      ),
      tileColor: isActive ? Colors.white.withOpacity(0.1) : null, // Highlight background jika aktif
      shape: isActive 
          ? const Border(left: BorderSide(color: AdminKitTheme.primary, width: 3)) // Garis biru di kiri
          : null,
      onTap: () {
        Navigator.pop(context); // Tutup Drawer
        if (!isActive) {
          Navigator.pushNamed(context, route); // Pindah halaman
        }
      },
    );
  }
}