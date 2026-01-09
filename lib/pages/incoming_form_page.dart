import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../core/theme.dart';
import '../providers/item_provider.dart';
import '../providers/supplier_provider.dart';
import '../providers/transaction_provider.dart';

class IncomingFormPage extends StatefulWidget {
  const IncomingFormPage({super.key});

  @override
  State<IncomingFormPage> createState() => _IncomingFormPageState();
}

class _IncomingFormPageState extends State<IncomingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  int? _selectedItemId;
  int? _selectedSupplierId;

  @override
  void initState() {
    super.initState();
    // Load data untuk dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemProvider>(context, listen: false).fetchItems();
      Provider.of<SupplierProvider>(context, listen: false).fetchSuppliers();
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedItemId == null || _selectedSupplierId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barang dan Supplier wajib dipilih")),
      );
      return;
    }

    try {
      await Provider.of<TransactionProvider>(
        context,
        listen: false,
      ).addIncoming(
        _selectedItemId!,
        _selectedSupplierId!,
        int.parse(_qtyController.text),
        _dateController.text,
      );

      if (mounted) {
        Navigator.pop(context); // Kembali
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Stok berhasil ditambahkan!"),
            backgroundColor: AdminKitTheme.success,
          ),
        );
        // Refresh data barang agar stok terupdate di list
        Provider.of<ItemProvider>(context, listen: false).fetchItems();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal: $e"),
            backgroundColor: AdminKitTheme.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final supplierProvider = Provider.of<SupplierProvider>(context);
    final isLoading = Provider.of<TransactionProvider>(context).isLoading;

    return MainLayout(
      title: "Barang Masuk",
      body: AdminCard(
        title: "Input Barang Masuk",
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DATE PICKER
              const Text(
                "Tanggal Masuk",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _dateController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(picked);
                  }
                },
              ),
              const SizedBox(height: 16),

              // ITEM DROPDOWN
              const Text(
                "Pilih Barang",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _selectedItemId,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: itemProvider.items.map((item) {
                  return DropdownMenuItem(
                    value: item.id,
                    child: Text("${item.name} (Stok: ${item.stock})"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedItemId = val),
              ),
              const SizedBox(height: 16),

              // SUPPLIER DROPDOWN
              const Text(
                "Supplier",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _selectedSupplierId,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: supplierProvider.suppliers.map((s) {
                  return DropdownMenuItem(value: s.id, child: Text(s.name));
                }).toList(),
                onChanged: (val) => setState(() => _selectedSupplierId = val),
              ),
              const SizedBox(height: 16),

              // QTY INPUT
              const Text(
                "Jumlah Masuk",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "0",
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminKitTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan Transaksi"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
