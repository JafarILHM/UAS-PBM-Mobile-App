import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/main_layout.dart';
import '../../widgets/admin_card.dart';
import '../../providers/transaction_provider.dart';
import '../../core/theme.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';

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
      body: AdminCard(
        title: "Riwayat Transaksi",
        expandChild: true,
        padding: const EdgeInsets.all(0),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.transactions.isEmpty
                ? const Center(child: Text('Belum ada transaksi.'))
                : ListView.separated(
                    itemCount: provider.transactions.length,
                    separatorBuilder: (context, index) => const Divider(),
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
