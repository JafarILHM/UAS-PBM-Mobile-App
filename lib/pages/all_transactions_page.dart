import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../widgets/main_layout.dart';
import '../../widgets/admin_card.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart'; 
import '../../core/theme.dart';

class AllTransactionsPage extends StatefulWidget {
  const AllTransactionsPage({super.key});

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data setelah frame pertama dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).fetchAllTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return MainLayout(
      title: 'Semua Transaksi',
      body: AdminCard(
        title: "Riwayat Transaksi",
        // expandChild: true, // Hapus atau set false jika bikin overflow
        padding: const EdgeInsets.all(0),
        child: provider.isLoading
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()),
              )
            : provider.transactions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text('Belum ada transaksi.')),
                  )
                : ListView.separated(
                    shrinkWrap: true, // Agar tidak error height unlimited
                    physics: const NeverScrollableScrollPhysics(), // Scroll ikut MainLayout
                    itemCount: provider.transactions.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final tx = provider.transactions[index];
                      return _buildTransactionTile(tx);
                    },
                  ),
      ),
    );
  }

  Widget _buildTransactionTile(Transaction tx) {
    bool isIncoming = tx.type == "in";
    
    // Format quantity
    String qty = isIncoming ? '+ ${tx.quantity}' : '- ${tx.quantity}';
    
    // Format tanggal (Pastikan field createdAt di model Transaction ada dan bertipe DateTime)
    String date = '-';
    try {
       date = DateFormat('d MMM yyyy, HH:mm').format(tx.createdAt);
    } catch (e) {
       date = tx.createdAt.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isIncoming ? AdminKitTheme.success.withOpacity(0.1) : AdminKitTheme.danger.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncoming ? AdminKitTheme.success : AdminKitTheme.danger,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.itemName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  isIncoming ? 'Barang Masuk' : 'Barang Keluar',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                  fontSize: 16,
                  color: isIncoming ? AdminKitTheme.success : AdminKitTheme.danger,
                ),
              ),
              const SizedBox(height: 4),
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