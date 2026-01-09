import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
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
  List<Transaction> _recentTransactions = [];
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

      // Proses data transaksi
      final List<Transaction> allTransactions = [];
      if (data['recent_incoming'] != null) {
        for (var tx in data['recent_incoming']) {
          allTransactions.add(Transaction.fromMap(tx, 'in'));
        }
      }
      if (data['recent_outgoing'] != null) {
        for (var tx in data['recent_outgoing']) {
          allTransactions.add(Transaction.fromMap(tx, 'out'));
        }
      }

      // Urutkan berdasarkan tanggal terbaru
      allTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _dashboardData = data;
        // Ambil 5 transaksi terbaru
        _recentTransactions = allTransactions.take(5).toList();
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
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // BARIS 1: Statistik Ringkas
                    Row(
                      children: [
                        _buildStatCard(
                          "Total Barang",
                          _dashboardData!['total_items'].toString(),
                          Icons.inventory,
                          AdminKitTheme.primary,
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          "Low Stock",
                          _dashboardData!['low_stock_count'].toString(),
                          Icons.warning,
                          AdminKitTheme.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatCard(
                          "Supplier",
                          _dashboardData!['total_suppliers'].toString(),
                          Icons.local_shipping,
                          AdminKitTheme.success,
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          "User",
                          "2",
                          Icons.people,
                          AdminKitTheme.danger,
                        ), // Hardcoded for now
                      ],
                    ),

                    const SizedBox(height: 24),

                    // BARIS 2: Transaksi Terakhir
                    AdminCard(
                      title: "Transaksi Terakhir",
                      action: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/transactions');
                        },
                        child: const Text("Lihat Semua"),
                      ),
                      child: _recentTransactions.isEmpty
                          ? const Center(child: Text("Belum ada transaksi."))
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _recentTransactions.length,
                              itemBuilder: (context, index) {
                                final tx = _recentTransactions[index];
                                return _buildTransactionTile(tx);
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Widget kecil helper untuk kartu statistik
  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.05).round()),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AdminKitTheme.primary,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: AdminKitTheme.secondary),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(icon, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(Transaction tx) {
    bool isIncoming = tx.type == "in";
    String qty = isIncoming ? '+ ${tx.quantity}' : '- ${tx.quantity}';
    String date = DateFormat('d MMM yyyy, HH:mm').format(tx.createdAt);

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
                Text(
                  tx.itemName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  isIncoming ? 'Masuk' : 'Keluar',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                qty,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isIncoming
                      ? AdminKitTheme.success
                      : AdminKitTheme.danger,
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
