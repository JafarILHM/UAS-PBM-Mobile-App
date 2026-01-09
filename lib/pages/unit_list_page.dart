import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../providers/unit_provider.dart';
import '../core/theme.dart';
import 'unit_form_page.dart';

class UnitListPage extends StatefulWidget {
  const UnitListPage({super.key});

  @override
  State<UnitListPage> createState() => _UnitListPageState();
}

class _UnitListPageState extends State<UnitListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<UnitProvider>(context, listen: false).fetchUnits(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UnitProvider>(context);

    return MainLayout(
      title: 'Data Satuan',
      floatingActionButton: FloatingActionButton(
        backgroundColor: AdminKitTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UnitFormPage()),
          );
        },
      ),
      body: AdminCard(
        title: "Daftar Satuan",
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.units.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = provider.units[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Menampilkan Simbol sebagai Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AdminKitTheme.secondary.withAlpha(
                              (255 * 0.1).round(),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.symbol,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: AdminKitTheme.primary,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UnitFormPage(unit: item),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: AdminKitTheme.danger,
                            size: 20,
                          ),
                          onPressed: () async {
                            final confirm = await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Hapus Satuan?"),
                                content: const Text(
                                  "Yakin ingin menghapus data ini?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
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
                              await provider.deleteUnit(item.id);
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
