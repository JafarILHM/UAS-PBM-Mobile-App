import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../core/theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await DashboardService().getDashboardStats();
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Dashboard',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _dashboardData == null
                  ? const Center(child: Text('No data available'))
                  : Column(
                      children: [
                        // BARIS 1: Statistik Ringkas
                        Row(
                          children: [
                            _buildStatCard(
                                "Total Barang",
                                _dashboardData!['total_items'].toString(),
                                Icons.inventory,
                                AdminKitTheme.primary),
                            const SizedBox(width: 16),
                            _buildStatCard(
                                "Low Stock",
                                _dashboardData!['low_stock_count'].toString(),
                                Icons.warning,
                                AdminKitTheme.warning),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildStatCard(
                                "Supplier",
                                _dashboardData!['total_suppliers'].toString(),
                                Icons.local_shipping,
                                AdminKitTheme.success),
                            const SizedBox(width: 16),
                            _buildStatCard("User", "2", Icons.people, AdminKitTheme.danger), // Hardcoded for now
                          ],
                        ),

                        const SizedBox(height: 24),

                        // BARIS 2: Grafik atau Tabel (Dibungkus AdminCard)
                        AdminCard(
                          title: "Transaksi Terakhir",
                          action: TextButton(
                              onPressed: () {}, child: const Text("Lihat Semua")),
                          child: Column(
                            children: [
                              _buildTransactionTile(
                                  "Masuk", "Laptop Dell", "+ 10 Pcs", "Hari ini"),
                              const Divider(),
                              _buildTransactionTile(
                                  "Keluar", "Mouse Logitech", "- 2 Pcs", "Kemarin"),
                              const Divider(),
                              _buildTransactionTile(
                                  "Masuk", "Aqua Botol", "+ 50 Box", "2 hari lalu"),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }

  // Widget kecil helper untuk kartu statistik
  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              )
            ]),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AdminKitTheme.primary)),
                Text(label,
                    style: const TextStyle(color: AdminKitTheme.secondary)),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(icon, color: color),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(
      String type, String item, String qty, String date) {
    bool isIncoming = type == "Masuk";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            isIncoming ? Icons.arrow_circle_down : Icons.arrow_circle_up,
            color: isIncoming ? AdminKitTheme.success : AdminKitTheme.danger,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(type,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(qty,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isIncoming
                          ? AdminKitTheme.success
                          : AdminKitTheme.danger)),
              Text(date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}