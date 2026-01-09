import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../providers/item_provider.dart';
import '../providers/category_provider.dart';
import '../providers/unit_provider.dart';
import '../core/theme.dart';
import '../models/item_model.dart';

class ItemFormPage extends StatefulWidget {
  final Item? item;

  const ItemFormPage({super.key, this.item});

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _skuController = TextEditingController();
  final _nameController = TextEditingController();
  final _stockController = TextEditingController(text: "0");
  final _minStockController = TextEditingController(text: "5");

  // Dropdown Values
  int? _selectedCategoryId;
  int? _selectedUnitId;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Load Data Kategori & Unit saat buka form agar dropdown ada isinya
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<UnitProvider>(context, listen: false).fetchUnits();
    });

    // Isi form jika mode Edit
    if (widget.item != null) {
      _skuController.text = widget.item!.sku;
      _nameController.text = widget.item!.name;
      _stockController.text = widget.item!.stock.toString();
      _minStockController.text = (widget.item!.stockMinimum ?? 5).toString();
      _selectedCategoryId = widget.item!.categoryId;
      _selectedUnitId = widget.item!.unitId;
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null || _selectedUnitId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kategori dan Satuan wajib dipilih!")),
      );
      return;
    }

    setState(() => _isSaving = true);

    final provider = Provider.of<ItemProvider>(context, listen: false);

    final data = Item(
      id: widget.item?.id ?? 0,
      sku: _skuController.text,
      name: _nameController.text,
      stock: int.tryParse(_stockController.text) ?? 0,
      stockMinimum: int.tryParse(_minStockController.text) ?? 5,
      categoryId: _selectedCategoryId!,
      unitId: _selectedUnitId!,
    );

    bool success;
    if (widget.item == null) {
      success = await provider.addItem(data);
    } else {
      success = await provider.updateItem(data);
    }

    setState(() => _isSaving = false);
    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Barang berhasil disimpan"),
          backgroundColor: AdminKitTheme.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menyimpan (Cek duplikasi SKU)"),
          backgroundColor: AdminKitTheme.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.item == null ? "Tambah Barang" : "Edit Barang";

    // Ambil Data Dropdown dari Provider
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final unitProvider = Provider.of<UnitProvider>(context);

    return MainLayout(
      title: title,
      body: AdminCard(
        title: "Informasi Barang",
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInput(
                "Kode SKU / Barcode",
                _skuController,
                "Scan atau ketik manual",
              ),
              const SizedBox(height: 16),

              _buildInput(
                "Nama Barang",
                _nameController,
                "Contoh: Laptop Asus",
              ),
              const SizedBox(height: 16),

              // DROPDOWN KATEGORI
              const Text(
                "Kategori",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                hint: const Text("Pilih Kategori"),
                items: categoryProvider.categories.map((cat) {
                  return DropdownMenuItem(value: cat.id, child: Text(cat.name));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
              ),
              const SizedBox(height: 16),

              // DROPDOWN UNIT
              const Text(
                "Satuan (Unit)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _selectedUnitId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                hint: const Text("Pilih Satuan"),
                items: unitProvider.units.map((unit) {
                  return DropdownMenuItem(
                    value: unit.id,
                    child: Text("${unit.name} (${unit.symbol})"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedUnitId = val),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildInput(
                      "Stok Awal",
                      _stockController,
                      "0",
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInput(
                      "Stok Minimum",
                      _minStockController,
                      "5",
                      isNumber: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminKitTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan Data Barang"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
        ),
      ],
    );
  }
}
