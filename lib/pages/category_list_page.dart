import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../providers/category_provider.dart';
import '../core/theme.dart';
import 'category_form_page.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  void initState() {
    super.initState();
    // Ambil data saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    return MainLayout(
      title: 'Data Kategori',
      floatingActionButton: FloatingActionButton(
        backgroundColor: AdminKitTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Ke Halaman Tambah
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoryFormPage()),
          );
        },
      ),
      body: AdminCard(
        title: "List Kategori",
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                shrinkWrap: true, // Agar bisa di dalam Column
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.categories.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = provider.categories[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol Edit
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
                                builder: (context) =>
                                    CategoryFormPage(category: item),
                              ),
                            );
                          },
                        ),
                        // Tombol Hapus
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
                                title: const Text("Hapus Kategori?"),
                                content: const Text(
                                  "Data yang dihapus tidak bisa dikembalikan.",
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
                              await provider.deleteCategory(item.id);
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
