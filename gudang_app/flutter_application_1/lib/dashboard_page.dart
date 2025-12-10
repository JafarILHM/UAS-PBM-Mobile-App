import 'package:flutter/material.dart';
import 'manage_account_page.dart'; // Import halaman Manage Account
import 'login_page.dart'; // Import login untuk logout

class DashboardPage extends StatelessWidget {
  final String role;
  const DashboardPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Gudang"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(role),
              accountEmail: Text(
                role == 'Admin' ? 'kepala@gudang.com' : 'staff@gudang.com',
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.indigo),
              ),
              decoration: const BoxDecoration(color: Colors.indigo),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            // Menu khusus Admin
            if (role == 'Admin')
              ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: const Text('Manajemen Akun'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageAccountPage(),
                    ),
                  );
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, $role!",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Statistik
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: "Total Stok",
                    value: "1,240",
                    icon: Icons.inventory_2,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: "Nilai Aset",
                    value: "Rp 50jt",
                    icon: Icons.monetization_on,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Warning Deadline
            const Card(
              color: Colors.redAccent,
              child: ListTile(
                leading: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 36,
                ),
                title: Text(
                  "Peringatan Expired!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Ada 5 item mendekati kadaluarsa (H-7)",
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Barang Terbanyak (Top 5)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Grafik Mockup
            Card(
              child: Column(
                children: [
                  _TopItemTile(
                    name: "Indomie Goreng",
                    count: 500,
                    percentage: 1.0,
                  ),
                  _TopItemTile(name: "Aqua Galon", count: 320, percentage: 0.8),
                  _TopItemTile(name: "Beras 5kg", count: 210, percentage: 0.6),
                  _TopItemTile(
                    name: "Minyak Goreng",
                    count: 150,
                    percentage: 0.4,
                  ),
                  _TopItemTile(name: "Gula Pasir", count: 80, percentage: 0.2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Helper (Saya taruh di file dashboard juga biar praktis)
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _TopItemTile extends StatelessWidget {
  final String name;
  final int count;
  final double percentage;

  const _TopItemTile({
    required this.name,
    required this.count,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      trailing: Text("$count Pcs"),
      subtitle: LinearProgressIndicator(
        value: percentage,
        backgroundColor: Colors.grey[200],
        color: Colors.indigo,
      ),
    );
  }
}
