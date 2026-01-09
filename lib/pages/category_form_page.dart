import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../providers/category_provider.dart';
import '../core/theme.dart';
import '../models/category_model.dart';

class CategoryFormPage extends StatefulWidget {
  final Category? category;

  const CategoryFormPage({super.key, this.category});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Jika Mode Edit, isi text field dengan nama kategori
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = Provider.of<CategoryProvider>(context, listen: false);
    bool success;

    if (widget.category == null) {
      // Mode Tambah
      success = await provider.addCategory(_nameController.text);
    } else {
      // Mode Edit
      success = await provider.updateCategory(
        widget.category!.id,
        _nameController.text,
      );
    }

    setState(() => _isSaving = false);

    if (success && mounted) {
      Navigator.pop(context); // Kembali ke list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil menyimpan data"),
          backgroundColor: AdminKitTheme.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan data"),
          backgroundColor: AdminKitTheme.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.category == null
        ? "Tambah Kategori"
        : "Edit Kategori";

    return MainLayout(
      title: title,
      body: AdminCard(
        title: "Form Kategori",
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nama Kategori",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Contoh: Elektronik",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: AdminKitTheme.secondary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminKitTheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Simpan"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
