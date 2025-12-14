import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../providers/supplier_provider.dart';
import '../core/theme.dart';
import 'supplier_form_page.dart';

class SupplierListPage extends StatefulWidget {
  const SupplierListPage({super.key});

  @override
  State<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends State<SupplierListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<SupplierProvider>(context, listen: false).fetchSuppliers()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SupplierProvider>(context);

    return MainLayout(
      title: 'Data Supplier',
      floatingActionButton: FloatingActionButton(
        backgroundColor: AdminKitTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SupplierFormPage()));
        },
      ),
      body: AdminCard(
        title: "Daftar Supplier",
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.suppliers.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = provider.suppliers[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.contact != null) 
                          Text("📞 ${item.contact}", style: const TextStyle(fontSize: 12)),
                        if (item.address != null) 
                          Text("📍 ${item.address}", style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: AdminKitTheme.primary, size: 20),
                          onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => SupplierFormPage(supplier: item)));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AdminKitTheme.danger, size: 20),
                          onPressed: () async {
                            final confirm = await showDialog(
                              context: context, 
                              builder: (ctx) => AlertDialog(
                                title: const Text("Hapus Supplier?"),
                                content: const Text("Yakin ingin menghapus data ini?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
                                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
                                ],
                              )
                            );
                            if (confirm == true) {
                              await provider.deleteSupplier(item.id);
                            }
                          },
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