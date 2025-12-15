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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).fetchAllTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return MainLayout(
      title: 'Semua Transaksi',
      body: SingleChildScrollView(
        child: AdminCard(
          title: "Riwayat Transaksi",
          expandChild: false, 
          padding: const EdgeInsets.all(0),
          child: provider.isLoading
              ? const SizedBox(
                  height: 200, 
                  child: Center(child: CircularProgressIndicator())
                )
              : provider.transactions.isEmpty
                  ? const SizedBox(
                      height: 100,
                      child: Center(child: Text('Belum ada transaksi.'))
                    )
                  : ListView.separated(
                      // 3. Tambahkan shrinkWrap dan physics agar ListView tidak konflik dengan ScrollView utama
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.transactions.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final tx = provider.transactions[index];
                        return _buildTransactionTile(tx);
                      },
                    ),
        ),
      ),
    );
  }

  Widget _buildTransactionTile(Transaction tx) {
    bool isIncoming = tx.type == "in";
    String qty = isIncoming ? '+ ${tx.quantity}' : '- ${tx.quantity}';
    
    // Safety check untuk format tanggal
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
          // Icon Background
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
          
          // Nama Barang & Status
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
          
          // Jumlah & Tanggal
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                qty,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isIncoming
                      ? AdminKitTheme.success
                      : AdminKitTheme.danger,
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