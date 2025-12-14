import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../core/theme.dart';
import '../providers/item_provider.dart';
import '../providers/transaction_provider.dart';

class OutgoingFormPage extends StatefulWidget {
  const OutgoingFormPage({super.key});

  @override
  State<OutgoingFormPage> createState() => _OutgoingFormPageState();
}

class _OutgoingFormPageState extends State<OutgoingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final _purposeController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now())
  );

  int? _selectedItemId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemProvider>(context, listen: false).fetchItems();
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedItemId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Barang wajib dipilih")));
      return;
    }

    try {
      await Provider.of<TransactionProvider>(context, listen: false).addOutgoing(
        _selectedItemId!,
        int.parse(_qtyController.text),
        _dateController.text,
        _purposeController.text,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Barang Keluar berhasil dicatat!"), backgroundColor: AdminKitTheme.success),
        );
        Provider.of<ItemProvider>(context, listen: false).fetchItems(); // Update stok
      }
    } catch (e) {
      if (mounted) {
        // Tampilkan pesan error (misal: Stok tidak cukup)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: ${e.toString().replaceAll('Exception:', '')}"), backgroundColor: AdminKitTheme.danger));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final isLoading = Provider.of<TransactionProvider>(context).isLoading;

    return MainLayout(
      title: "Barang Keluar",
      body: AdminCard(
        title: "Input Barang Keluar",
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Tanggal Keluar", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
              ),
              const SizedBox(height: 16),

              const Text("Pilih Barang", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedItemId,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: itemProvider.items.map((item) {
                  return DropdownMenuItem(
                    value: item.id,
                    child: Text("${item.name} (Sisa: ${item.stock})"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedItemId = val),
              ),
              const SizedBox(height: 16),

              const Text("Jumlah Keluar", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "0"),
                validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              const Text("Tujuan / Keterangan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Misal: Produksi, Rusak, dll"),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: AdminKitTheme.danger, foregroundColor: Colors.white),
                  child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("Simpan Transaksi"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}