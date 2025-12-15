import 'package:flutter/material.dart';
import 'package:inventory_app/core/api_config.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isExporting = false;

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

  Future<void> _exportToExcel() async {
    setState(() {
      _isExporting = true;
    });

    try {
      // Get token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      // API request to download the file
      final url = Uri.parse('${ApiConfig.baseUrl}/export/transactions');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Save the file
        final bytes = response.bodyBytes;
        final directory = await getDownloadsDirectory();
        final path = '${directory!.path}/transactions.xlsx';
        final file = File(path);
        await file.writeAsBytes(bytes);

        // Show success message and open the file
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File saved to: $path')),
        );
        OpenFile.open(path);
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting to Excel: $e')),
      );
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return MainLayout(
      title: 'Semua Transaksi',
      body: AdminCard(
        title: "Riwayat Transaksi",
        action: _isExporting
            ? const CircularProgressIndicator()
            : IconButton(
                icon: const Icon(Icons.download),
                onPressed: _exportToExcel,
              ),
        expandChild: true,
        padding: const EdgeInsets.all(0),
        child: provider.isLoading
            ? const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            : provider.transactions.isEmpty
            ? const SizedBox(
                height: 100,
                child: Center(child: Text('Belum ada transaksi.')),
              )
            : ListView.separated(
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
              color: isIncoming
                  ? AdminKitTheme.success.withOpacity(0.1)
                  : AdminKitTheme.danger.withOpacity(0.1),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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
