import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<ItemProvider>(context, listen: false).fetchItems()
    );
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ItemFormPage()));
        },
      ),
      body: AdminCard(
        title: "Stok Barang",
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
                  Color stockColor = isLowStock ? AdminKitTheme.danger : AdminKitTheme.success;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("SKU: ${item.sku}", style: const TextStyle(fontSize: 12)),
                        Text(item.category?.name ?? "-", style: const TextStyle(fontSize: 12, color: AdminKitTheme.secondary)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badge Stok
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: stockColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: stockColor.withOpacity(0.5)),
                          ),
                          child: Text(
                            "${item.stock} ${item.unit?.symbol ?? ''}",
                            style: TextStyle(fontWeight: FontWeight.bold, color: stockColor, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        
                        // Menu Edit/Hapus
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ItemFormPage(item: item)));
                            } else if (value == 'delete') {
                              // Dialog Konfirmasi Hapus
                              final confirm = await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Hapus Barang?"),
                                  content: const Text("Yakin hapus? History transaksi barang ini mungkin ikut terhapus."),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
                                  ],
                                )
                              );
                              if (confirm == true) {
                                await provider.deleteItem(item.id);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text("Edit")])),
                            const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 16, color: Colors.red), SizedBox(width: 8), Text("Hapus", style: TextStyle(color: Colors.red))])),
                          ],
                          child: const Icon(Icons.more_vert, color: AdminKitTheme.secondary),
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