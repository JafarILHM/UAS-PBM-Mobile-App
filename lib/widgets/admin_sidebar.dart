import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Drawer(
      backgroundColor: AdminKitTheme.sidebar, // Warna Gelap
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // HEADER SIDEBAR (Logo / Brand)
          SizedBox(
            height: 80,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: AdminKitTheme.sidebar,
              ),
              child: Row(
                children: const [
                  Icon(Icons.inventory_2, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Sistem Gudang',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // INFO USER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AdminKitTheme.primary,
                    child: Text(
                      user?.name[0].toUpperCase() ?? "U",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? "User", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(user?.role ?? "Staff", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("MENU UTAMA", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
          ),

          // MENU ITEMS
          _buildMenuItem(context, 'Dashboard', Icons.dashboard, '/dashboard'),
          
          // Menu Khusus Admin
          if (user?.role == 'admin') ...[
             const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(color: Colors.white24),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("MASTER DATA", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            _buildMenuItem(context, 'Data Barang', Icons.inventory, '/items'),
            _buildMenuItem(context, 'Kategori', Icons.category, '/categories'),
            _buildMenuItem(context, 'Supplier', Icons.local_shipping, '/suppliers'),
            _buildMenuItem(context, 'Satuan', Icons.straighten, '/units'),
          ],

           const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(color: Colors.white24),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("TRANSAKSI", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          
          _buildMenuItem(context, 'Barang Masuk', Icons.arrow_circle_down, '/incoming'),
          _buildMenuItem(context, 'Barang Keluar', Icons.arrow_circle_up, '/outgoing'),

           const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(color: Colors.white24),
          ),
          
          _buildMenuItem(context, 'Profile Saya', Icons.person, '/profile'),
          
          // TOMBOL LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFDC3545)), // Warna merah
            title: const Text('Logout', style: TextStyle(color: Color(0xFFDC3545))),
            onTap: () async {
              // Tampilkan dialog konfirmasi
              // Logic logout nanti di sini
              Navigator.pop(context); // Tutup drawer
              // context.read<AuthProvider>().logout(); ...
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  // Helper untuk membuat item menu yang seragam
  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    // Cek apakah halaman ini sedang aktif (logic sederhana)
    // Untuk implementasi kompleks bisa pakai ModalRoute
    bool isActive = false; 

    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.white : Colors.white70),
      title: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.white70)),
      tileColor: isActive ? Colors.white.withOpacity(0.1) : null,
      onTap: () {
        Navigator.pop(context); // Tutup Drawer
        Navigator.pushNamed(context, route); // Pindah halaman
      },
    );
  }
}