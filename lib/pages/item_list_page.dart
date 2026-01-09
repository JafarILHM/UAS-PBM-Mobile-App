import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_app/core/api_config.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../providers/item_provider.dart';
import '../core/theme.dart';
import 'item_form_page.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<ItemProvider>(context, listen: false).fetchItems(),
    );
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
      final url = Uri.parse('${ApiConfig.baseUrl}/export/items');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Generate a unique filename with a timestamp
        final timestamp = DateFormat(
          'yyyy-MM-dd_HH-mm-ss',
        ).format(DateTime.now());
        final filename = 'items_$timestamp.xlsx';

        // Save the file
        final bytes = response.bodyBytes;
        final directory = await getDownloadsDirectory();
        final path = '${directory!.path}/$filename';
        final file = File(path);
        await file.writeAsBytes(bytes);

        // Show success message and open the file
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('File saved to: $path')));
        OpenFile.open(path);
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error exporting to Excel: $e')));
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemProvider>(context);

    return MainLayout(
      title: 'Data Barang',
      floatingActionButton: FloatingActionButton(
        backgroundColor: AdminKitTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ItemFormPage()),
          );
        },
      ),
      body: AdminCard(
        title: "Stok Barang",
        action: _isExporting
            ? const CircularProgressIndicator()
            : IconButton(
                icon: const Icon(Icons.download),
                onPressed: _exportToExcel,
              ),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.items.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = provider.items[index];

                  // Logic Warna Stok: Merah jika stok <= minimum
                  bool isLowStock = item.stock <= (item.stockMinimum ?? 5);
                  Color stockColor = isLowStock
                      ? AdminKitTheme.danger
                      : AdminKitTheme.success;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SKU: ${item.sku}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          item.category?.name ?? "-",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AdminKitTheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badge Stok
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: stockColor.withAlpha((255 * 0.1).round()),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: stockColor.withAlpha((255 * 0.5).round()),
                            ),
                          ),
                          child: Text(
                            "${item.stock} ${item.unit?.symbol ?? ''}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: stockColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Menu Edit/Hapus
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ItemFormPage(item: item),
                                ),
                              );
                            } else if (value == 'delete') {
                              // Dialog Konfirmasi Hapus
                              final confirm = await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Hapus Barang?"),
                                  content: const Text(
                                    "Yakin hapus? History transaksi barang ini mungkin ikut terhapus.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await provider.deleteItem(item.id);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 16),
                                  SizedBox(width: 8),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Hapus",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          child: const Icon(
                            Icons.more_vert,
                            color: AdminKitTheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
